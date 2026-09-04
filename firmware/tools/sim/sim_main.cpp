#include "mikroc_stub.h"
#include "W25Q64.h"
#include "License.h"

static char rec[512];
static int failures = 0;

static void check(int cond, const char *what)
{
    if(!cond) { printf("  FAIL: %s\n", what); failures++; }
}

/* build the same record the firmware builds: id, then YYMMDDhhmm at [8..17] */
static void make_record(int mo,int da,int ho,int mi,int tag)
{
    int i;
    for(i=0;i<262;i++) rec[i]='0';
    memcpy(rec,"10001704",8);
    rec[8]='2'; rec[9]='4';
    rec[10]='0'+mo/10; rec[11]='0'+mo%10;
    rec[12]='0'+da/10; rec[13]='0'+da%10;
    rec[14]='0'+ho/10; rec[15]='0'+ho%10;
    rec[16]='0'+mi/10; rec[17]='0'+mi%10;
    rec[20]='0'+(tag%10);
    rec[262]=13; rec[263]=10;
    for(i=264;i<512;i++) rec[i]=0;
}

static unsigned long sector_of(int mo,int da,int ho,int mi)
{
    unsigned long s;
    s  = 31UL*24UL*60UL*(unsigned long)mo;
    s += 24UL*60UL*(unsigned long)da;
    s += 60UL*(unsigned long)ho;
    s += (unsigned long)mi;
    return s;
}

static char buf[512];
static int header_matches(int mo,int da,int ho,int mi)
{
    return buf[10]=='0'+mo/10 && buf[11]=='0'+mo%10 &&
           buf[12]=='0'+da/10 && buf[13]=='0'+da%10 &&
           buf[14]=='0'+ho/10 && buf[15]=='0'+ho%10 &&
           buf[16]=='0'+mi/10 && buf[17]=='0'+mi%10;
}

int main(void)
{
    int da,ho,mi,tag,i;
    long written = 0;

    sim_power_on();
    spifat_init();

    printf("== init ==\n");
    printf("  jedec  = %02X %02X %02X\n", flash_jedec[0],flash_jedec[1],flash_jedec[2]);
    printf("  uid    = ");
    for(i=0;i<8;i++) printf("%02X", flash_uid[i]);
    printf("\n  memory_error=%d flash_present=%d error_byte=%04X\n",
           memory_error, flash_present, error_byte);
    check(memory_error==0, "chip identified");
    check(flash_present==1, "flash_present set");
    check(!is_error(FLASH_ERR), "FLASH_ERR clear after init");

    /* ---- 1. write 20 consecutive intervals and read them back ---- */
    printf("== sequential write/read ==\n");
    tag = 0;
    for(mi=0; mi<100; mi+=5)
    {
        make_record(3, 7, 10+mi/60, mi%60, tag);
        check(Flash_Write_Sector(sector_of(3,7,10+mi/60,mi%60), rec)==0, "write ok");
        tag++;
    }
    tag = 0;
    for(mi=0; mi<100; mi+=5)
    {
        memset(buf,0,512);
        check(Flash_Read_Sector(sector_of(3,7,10+mi/60,mi%60), buf)==0, "read ok");
        check(header_matches(3,7,10+mi/60,mi%60), "header round-trips");
        check(buf[20]=='0'+(tag%10), "payload round-trips");
        check(memcmp(buf,"10001704",8)==0, "system id round-trips");
        tag++;
    }
    printf("  erases=%ld programs=%ld (20 records)\n", sim_erase_count, sim_program_count);
    check(sim_erase_count==3, "one erase per 8 slots");
    check(sim_program_count==40, "two page programs per record");

    /* ---- 2. a minute that was never written must not match ---- */
    memset(buf,0,512);
    Flash_Read_Sector(sector_of(3,7,11,7), buf);
    check(!header_matches(3,7,11,7), "unwritten minute reports a mismatch");

    /* ---- 3. a whole month of 5-minute records ---- */
    printf("== bulk: one month ==\n");
    sim_erase_count = 0; sim_program_count = 0;
    for(da=1; da<=30; da++)
      for(ho=0; ho<24; ho++)
        for(mi=0; mi<60; mi+=5)
        { make_record(6,da,ho,mi,da+ho+mi); Flash_Write_Sector(sector_of(6,da,ho,mi),rec); written++; }
    printf("  wrote %ld records, erases=%ld\n", written, sim_erase_count);
    check(sim_erase_count == written/8, "no extra erases in time order");

    for(da=1; da<=30; da+=7)
      for(ho=0; ho<24; ho+=6)
      { memset(buf,0,512);
        Flash_Read_Sector(sector_of(6,da,ho,25), buf);
        check(header_matches(6,da,ho,25), "month data still readable"); }

    /* ---- 4. ring wrap: 57 days later the oldest slot is recycled ---- */
    printf("== ring wrap ==\n");
    make_record(6,1,0,0,1);
    Flash_Write_Sector(sector_of(6,1,0,0), rec);
    check(flash_address_of(sector_of(6,1,0,0)) ==
          flash_address_of(sector_of(6,1,0,0) + 16384UL*INTERVALPERIOD),
          "slot repeats after 16384 intervals");
    make_record(9,1,0,0,2);
    Flash_Write_Sector(sector_of(6,1,0,0) + 16384UL*INTERVALPERIOD, rec);
    memset(buf,0,512);
    Flash_Read_Sector(sector_of(6,1,0,0), buf);
    check(!header_matches(6,1,0,0), "recycled slot reports a mismatch, not stale data");

    /* ---- 5. out of order write (clock stepped backwards) ---- */
    printf("== backwards clock ==\n");
    for(mi=0; mi<40; mi+=5) { make_record(7,1,5,mi,1); Flash_Write_Sector(sector_of(7,1,5,mi),rec); }
    make_record(8,1,5,20,9);
    check(Flash_Write_Sector(sector_of(7,1,5,20), rec)==0, "overwrite in place succeeds");
    memset(buf,0,512);
    Flash_Read_Sector(sector_of(7,1,5,20), buf);
    check(header_matches(8,1,5,20), "overwritten slot holds the new record");

    /* ---- 6. licence ---- */
    printf("== licence ==\n");
    license_check();
    printf("  state=%d (0=ok 1=bad 2=unknown)\n", license_state);
    check(license_state==LIC_STATE_BAD, "blank EEPROM -> not activated");
    check(is_error(LIC_ERR), "LIC_ERR raised");
    check(license_granted()==(LICENSE_ENFORCE?0:1), "enforcement follows LICENSE_ENFORCE");

    license_store(license_hash());
    license_check();
    check(license_state==LIC_STATE_OK, "correct code activates");
    check(!is_error(LIC_ERR), "LIC_ERR cleared");

    license_store(license_hash() ^ 1uL);
    license_check();
    check(license_state==LIC_STATE_BAD, "wrong code rejected");

    { unsigned long k;
      { char h1[]="9F3C21D0"; check(license_parse(h1, &k)==0 && k==0x9F3C21D0uL, "hex parser"); }
      { char h2[]="9F3C21DZ"; check(license_parse(h2, &k)==1, "hex parser rejects garbage"); } }

    { unsigned char save[8]; memcpy(save, flash_uid, 8);
      memset(flash_uid, 0, 8);
      license_check();
      check(license_state==LIC_STATE_UNKNOWN, "unreadable UID -> no enforcement");
      check(license_granted()==1, "unreadable UID never blocks");
      memcpy(flash_uid, save, 8); }

    uart_reset();
    license_write_hex32(0xDEADBEEFuL);
    check(strcmp(uart_text(),"DEADBEEF")==0, "hex printer");

    printf("\n%s  (%d failures)\n", failures ? "FAILED" : "ALL CHECKS PASSED", failures);
    return failures ? 1 : 0;
}
