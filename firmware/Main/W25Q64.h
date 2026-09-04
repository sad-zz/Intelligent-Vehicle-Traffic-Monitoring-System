/*******************************************************************************
*  W25Q64.h  -  Winbond W25Q64JVS (64 Mbit / 8 MByte) SPI NOR Flash driver
*
*  Tosee Noavaran Jonoub  --  Vehicle Traffic Counter (dsPIC30F4011)
*
*  This module replaces the previous MMC/SD ("RAM") card that was attached to
*  SPI1.  The W25Q64JVS is wired to exactly the same pins as the old card:
*
*      dsPIC30F4011              W25Q64JVS (SOIC-8 / 208mil)
*      ------------------------  --------------------------------
*      RF3  / SDO1               pin 5  DI   (IO0)
*      RF2  / SDI1               pin 2  DO   (IO1)
*      RF6  / SCK1               pin 6  CLK
*      RF1  (flash_cs)           pin 1  /CS
*      VDD (3.3V)                pin 8  VCC   + 100nF
*      VSS                       pin 4  GND
*                                pin 3  /WP   -> VCC (10k)
*                                pin 7  /HOLD -> VCC (10k)
*
*  IMPORTANT: the W25Q64JVS is a 3.3V part (2.7 - 3.6V).  It is NOT 5V
*  tolerant.  See W25Q64_MIGRATION_FA.md for the level shifting notes.
*
*  Storage model
*  -------------
*  The application stores one 512-byte "sector" per measuring interval, the
*  sector number being the minute-of-year of the record:
*
*      sector = month*31*24*60 + day*24*60 + hour*60 + minute
*
*  A whole year of 5 minute records does not fit in 8 MByte, so the records
*  are packed (only one slot per INTERVALPERIOD) and mapped into a ring of
*  16384 slots:
*
*      slot    = (sector / INTERVALPERIOD) & 0x3FFF
*      address = slot * 512
*
*  16384 slots x INTERVALPERIOD(5) minutes = 81920 minutes = 56.9 days of
*  history.  When the ring wraps, the oldest record is overwritten.
*
*  This is safe for the application because every read is validated against
*  the date/time stamp stored inside the record itself (interval_data[8..17]).
*  If the slot holds a record of a different date - because it was recycled or
*  was never written - the caller already falls back to an empty record, which
*  is exactly what the old SD card returned for an unwritten sector.
*
*  NOR flash needs an erase (to 0xFF) before it can be programmed, and the
*  smallest erasable unit is 4096 bytes = 8 slots.  Records are written in
*  increasing time order, so the whole 4 KByte group is erased when its first
*  slot is written, and the remaining 7 slots are then programmed one by one
*  without any further erase.
*
*  Endurance: min. 100000 erase cycles per sector.  One erase per 8 records =
*  one erase per 40 minutes -> ~13140 erases/year -> > 7 years of continuous
*  logging in the worst case, and the ring spreads the wear over the chip.
*******************************************************************************/

/* ----------------------------- command set ------------------------------- */
#define W25_CMD_WRITE_ENABLE      0x06
#define W25_CMD_WRITE_DISABLE     0x04
#define W25_CMD_READ_SR1          0x05
#define W25_CMD_READ_SR2          0x35
#define W25_CMD_WRITE_SR          0x01
#define W25_CMD_READ_DATA         0x03
#define W25_CMD_PAGE_PROGRAM      0x02
#define W25_CMD_SECTOR_ERASE_4K   0x20
#define W25_CMD_BLOCK_ERASE_64K   0xD8
#define W25_CMD_CHIP_ERASE        0xC7
#define W25_CMD_JEDEC_ID          0x9F
#define W25_CMD_UNIQUE_ID         0x4B
#define W25_CMD_RELEASE_PD        0xAB
#define W25_CMD_POWER_DOWN        0xB9
#define W25_CMD_ENABLE_RESET      0x66
#define W25_CMD_RESET_DEVICE      0x99

#define W25_ID_WINBOND            0xEF     /* manufacturer                    */
#define W25_ID_MEMTYPE_JV         0x40     /* W25Q64JV standard SPI           */
#define W25_ID_MEMTYPE_JVDTR      0x70     /* W25Q64JV-IM (DTR) variant       */
#define W25_ID_CAPACITY_64M       0x17     /* 2^23 byte = 8 MByte             */

#define W25_SR1_BUSY              0x01
#define W25_SR1_WEL               0x02
#define W25_SR1_PROTECT_MASK      0x7C     /* BP0..BP2, TB, SEC               */

/* ------------------------------- geometry -------------------------------- */
#define FLASH_PAGE_SIZE           256
#define FLASH_ERASE_SIZE          4096
#define FLASH_SLOT_SIZE           512      /* one logical "sector"            */
#define FLASH_SLOTS_PER_ERASE     8
#define FLASH_SLOT_MASK           0x3FFFuL /* 16384 slots = 8 MByte           */
#define FLASH_ERASE_MASK          0xFFFFF000uL

/* timeouts in milliseconds (datasheet maxima: page 3ms, sector erase 400ms) */
#define FLASH_TMO_PROGRAM         20
#define FLASH_TMO_ERASE           600
#define FLASH_TMO_READY           800

/* --------------------------------- state --------------------------------- */
unsigned char
    flash_jedec[3],                        /* EF 40 17 for a good W25Q64JV    */
    flash_uid[8];                          /* 64 bit factory unique number    */
char
    flash_present;                         /* 1 = chip answered its JEDEC id  */
unsigned int
    flash_io_cnt;
unsigned long
    flash_slot_addr;

/* ------------------------------ primitives ------------------------------- */
void flash_command(unsigned char cmd)
{
    flash_cs = 0;
    SPI1_Write(cmd);
    flash_cs = 1;
}

unsigned char flash_status1()
{
    unsigned char s;
    flash_cs = 0;
    SPI1_Write(W25_CMD_READ_SR1);
    s = (unsigned char)SPI1_Read(0xFF);
    flash_cs = 1;
    return s;
}

/* returns 0 when the chip became ready, 1 on timeout */
char flash_wait_ready(unsigned int tmo_ms)
{
    unsigned int t;
    for(t = 0; t < tmo_ms; t++)
    {
        if((flash_status1() & W25_SR1_BUSY) == 0) return 0;
        delay_ms(1);
        Clrwdt();
    }
    return 1;
}

void flash_send_address(unsigned char cmd, unsigned long addr)
{
    flash_cs = 0;
    SPI1_Write(cmd);
    SPI1_Write((unsigned char)(addr >> 16));
    SPI1_Write((unsigned char)(addr >> 8));
    SPI1_Write((unsigned char)(addr));
}

/* --------------------------- read / erase / write ------------------------ */
char flash_read(unsigned long addr, char *buff, unsigned int len)
{
    if(flash_wait_ready(FLASH_TMO_READY)) return 1;
    flash_send_address(W25_CMD_READ_DATA, addr);
    for(flash_io_cnt = 0; flash_io_cnt < len; flash_io_cnt++)
    {
        buff[flash_io_cnt] = (char)SPI1_Read(0xFF);
    }
    flash_cs = 1;
    return 0;
}

char flash_erase_4k(unsigned long addr)
{
    if(flash_wait_ready(FLASH_TMO_READY)) return 1;
    flash_command(W25_CMD_WRITE_ENABLE);
    flash_send_address(W25_CMD_SECTOR_ERASE_4K, addr & FLASH_ERASE_MASK);
    flash_cs = 1;
    return flash_wait_ready(FLASH_TMO_ERASE);
}

/* len must be <= 256 and the page boundary must not be crossed */
char flash_program_page(unsigned long addr, char *buff, unsigned int len)
{
    if(flash_wait_ready(FLASH_TMO_READY)) return 1;
    flash_command(W25_CMD_WRITE_ENABLE);
    if((flash_status1() & W25_SR1_WEL) == 0) return 1;
    flash_send_address(W25_CMD_PAGE_PROGRAM, addr);
    for(flash_io_cnt = 0; flash_io_cnt < len; flash_io_cnt++)
    {
        SPI1_Write(buff[flash_io_cnt]);
    }
    flash_cs = 1;
    return flash_wait_ready(FLASH_TMO_PROGRAM);
}

/* 1 when the first four bytes of the slot are still erased (0xFF) */
char flash_slot_is_blank(unsigned long addr)
{
    unsigned char i, b;
    if(flash_wait_ready(FLASH_TMO_READY)) return 0;
    flash_send_address(W25_CMD_READ_DATA, addr);
    b = 0xFF;
    for(i = 0; i < 4; i++) b &= (unsigned char)SPI1_Read(0xFF);
    flash_cs = 1;
    if(b == 0xFF) return 1;
    return 0;
}

/* -------------------- logical sector <-> flash address ------------------- */
unsigned long flash_address_of(unsigned long sector)
{
    unsigned long slot;
    slot = (sector / INTERVALPERIOD) & FLASH_SLOT_MASK;
    return (slot * (unsigned long)FLASH_SLOT_SIZE);
}

/* ------------------------------ housekeeping ----------------------------- */
void flash_read_unique_id()
{
    unsigned char i;
    flash_cs = 0;
    SPI1_Write(W25_CMD_UNIQUE_ID);
    SPI1_Write(0xFF);                       /* 4 dummy bytes                  */
    SPI1_Write(0xFF);
    SPI1_Write(0xFF);
    SPI1_Write(0xFF);
    for(i = 0; i < 8; i++) flash_uid[i] = (unsigned char)SPI1_Read(0xFF);
    flash_cs = 1;
}

char flash_read_id()
{
    flash_cs = 0;
    SPI1_Write(W25_CMD_JEDEC_ID);
    flash_jedec[0] = (unsigned char)SPI1_Read(0xFF);
    flash_jedec[1] = (unsigned char)SPI1_Read(0xFF);
    flash_jedec[2] = (unsigned char)SPI1_Read(0xFF);
    flash_cs = 1;

    if(flash_jedec[0] != W25_ID_WINBOND)      return 1;
    if(flash_jedec[2] != W25_ID_CAPACITY_64M) return 1;
    if(flash_jedec[1] != W25_ID_MEMTYPE_JV &&
       flash_jedec[1] != W25_ID_MEMTYPE_JVDTR) return 1;
    return 0;
}

/* remove any block protection left over from a previous life of the chip */
void flash_unprotect()
{
    if((flash_status1() & W25_SR1_PROTECT_MASK) == 0) return;
    flash_command(W25_CMD_WRITE_ENABLE);
    flash_cs = 0;
    SPI1_Write(W25_CMD_WRITE_SR);
    SPI1_Write(0x00);                       /* status register 1              */
    SPI1_Write(0x00);                       /* status register 2 (QE off)     */
    flash_cs = 1;
    flash_wait_ready(FLASH_TMO_READY);
}

/* ---------------------------- public sector API -------------------------- */
/* Drop-in replacements for Mmc_Read_Sector() / Mmc_Write_Sector().          */
/* Both return 0 on success, 1 on error - same convention as the MMC lib.    */

/* Never talk to a chip that did not answer at start-up: a missing or dead
   device would make every access wait for the full busy time-out.  One cheap
   id read per access is enough to pick the chip up again if it recovers.   */
char flash_available()
{
    if(flash_present) return 1;
    if(flash_read_id() == 0)
    {
        flash_present = 1;
        flash_read_unique_id();
        flash_unprotect();
        memory_error = 0;
        reset_error(FLASH_ERR);
        return 1;
    }
    memory_error = 1;
    set_error(FLASH_ERR);
    return 0;
}

char Flash_Read_Sector(unsigned long sector, char *dbuff)
{
    if(!flash_available()) return 1;
    flash_slot_addr = flash_address_of(sector);
    if(flash_read(flash_slot_addr, dbuff, FLASH_SLOT_SIZE))
    {
        memory_error = 1;
        flash_present = 0;   /* re-probe on the next access */
        set_error(FLASH_ERR);
        return 1;
    }
    memory_error = 0;
    reset_error(FLASH_ERR);
    return 0;
}

char Flash_Write_Sector(unsigned long sector, char *dbuff)
{
    if(!flash_available()) return 1;
    flash_slot_addr = flash_address_of(sector);

    /* first slot of a 4 KByte group, or a slot that still holds an old
       record (clock jumped backwards): recycle the whole group first       */
    if(((flash_slot_addr & (unsigned long)(FLASH_ERASE_SIZE - 1)) == 0) ||
       (!flash_slot_is_blank(flash_slot_addr)))
    {
        if(flash_erase_4k(flash_slot_addr))
        {
            memory_error = 1;
            flash_present = 0;   /* re-probe on the next access */
            set_error(FLASH_ERR);
            return 1;
        }
    }

    if(flash_program_page(flash_slot_addr, dbuff, FLASH_PAGE_SIZE) ||
       flash_program_page(flash_slot_addr + FLASH_PAGE_SIZE,
                          dbuff + FLASH_PAGE_SIZE, FLASH_PAGE_SIZE))
    {
        memory_error = 1;
        flash_present = 0;   /* re-probe on the next access */
        set_error(FLASH_ERR);
        return 1;
    }

    memory_error = 0;
    reset_error(FLASH_ERR);
    return 0;
}

/* Kept under its historic name so the start-up sequence in 91-7.c does not
   have to change.  It now brings up the W25Q64JVS instead of the SD card.   */
void spifat_init()
{
    /* SPI mode 3 (CPOL=1, CPHA=1) at Fcy/4 = 3.686 MHz - the very same
       settings the SD card ran with, and fully inside the 50 MHz that the
       W25Q64JV allows for the 0x03 Read Data command.                       */
    SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1,
                       _SPI_PRESCALE_PRI_4, _SPI_SS_DISABLE,
                       _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH,
                       _SPI_ACTIVE_2_IDLE);

    flash_present = 0;
    flash_cs = 1;
    delay_ms(10);                           /* tVSL after power up            */

    flash_command(W25_CMD_RELEASE_PD);      /* in case it was powered down    */
    delay_ms(1);
    flash_command(W25_CMD_ENABLE_RESET);
    flash_command(W25_CMD_RESET_DEVICE);
    delay_ms(2);

    if(flash_read_id() == 0)
    {
        memory_error = 0;
    }
    else
    {
        delay_ms(5);                        /* one retry, as the MMC code did */
        if(flash_read_id() == 0) memory_error = 0;
        else                     memory_error = 1;
    }

    if(memory_error)
    {
        set_error(FLASH_ERR);
        flash_uid[0] = 0; flash_uid[1] = 0; flash_uid[2] = 0; flash_uid[3] = 0;
        flash_uid[4] = 0; flash_uid[5] = 0; flash_uid[6] = 0; flash_uid[7] = 0;
        return;
    }

    reset_error(FLASH_ERR);
    flash_present = 1;
    flash_read_unique_id();
    flash_unprotect();
}
