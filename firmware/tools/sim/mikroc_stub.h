/* minimal stand-in for the mikroC PRO for dsPIC environment + a behavioural
   model of a W25Q64JVS, so the driver logic can be exercised on a PC.      */
#ifndef MIKROC_STUB_H
#define MIKROC_STUB_H
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* ---- from Variables.h ---- */
#define INTERVALPERIOD 5
#define XMICRO         4
#define FLASH_ERR      0x0001
#define LIC_ERR        0x0400

char          memory_error = 1;

/* /CS is modelled as a proxy object so that every level change made by the
   driver is observed exactly as the real chip would observe it.            */
static void sim_cs_changed(int level);
struct CsPin {
    int v;
    CsPin& operator=(int x){ if(x!=v){ v=x; sim_cs_changed(x); } return *this; }
    operator int() const { return v; }
};
CsPin flash_cs = { 1 };
unsigned int  error_byte = 0;
unsigned int  NVMADR, NVMADRU;

void set_error(unsigned int b)   { error_byte |=  b; }
void reset_error(unsigned int b) { error_byte &= ~b; }
char is_error(unsigned int b)    { return (error_byte & b) ? 1 : 0; }

#define Clrwdt()
void delay_ms(unsigned long m) { (void)m; }

/* ---- data EEPROM model ---- */
static unsigned int ee[0x400];
static unsigned ee_idx(unsigned long a){ return (unsigned)((a - 0x7FFC00uL) / 4) & 0x3FF; }
unsigned int eeprom_read(unsigned long a)              { return ee[ee_idx(a)]; }
void         eeprom_write(unsigned long a, unsigned int d){ ee[ee_idx(a)] = d; }

/* ---- UART model ---- */
static char uart_out[8192]; static int uart_len = 0;
void UART1_Write(unsigned char c){ if(uart_len < 8191) uart_out[uart_len++] = (char)c; }
void uart_reset(void){ uart_len = 0; uart_out[0] = 0; }
const char *uart_text(void){ uart_out[uart_len] = 0; return uart_out; }

/* ---- SPI + W25Q64JVS behavioural model ---- */
#define SIM_SIZE (8UL*1024UL*1024UL)
static unsigned char chip[SIM_SIZE];
static const unsigned char chip_uid[8] = {0xE4,0x68,0x0C,0x51,0xA1,0xB2,0x33,0x44};
static unsigned char sr1 = 0x00, sr2 = 0x00;
static int  last_cs = 1;
static int  fr_n;                 /* byte index inside the current frame    */
static unsigned char fr_cmd;
static unsigned long fr_addr;
/* deferred operations, committed when the frame ends */
static int  pend_op;              /* 0 none, 1 program, 2 erase, 3 wrsr     */
static unsigned long pend_addr;
static unsigned char pend_buf[256]; static int pend_len;
static unsigned char pend_sr1, pend_sr2;
long sim_erase_count = 0, sim_program_count = 0;

static void sim_commit(void)
{
    unsigned long i, page_base;
    if(pend_op == 1)                                   /* page program      */
    {
        page_base = pend_addr & ~0xFFuL;
        for(i = 0; i < (unsigned long)pend_len; i++)
        {
            unsigned long a = page_base + ((pend_addr + i) & 0xFF); /* wraps */
            chip[a] &= pend_buf[i];                    /* NOR: only 1 -> 0  */
        }
        sim_program_count++;
    }
    else if(pend_op == 2)                              /* 4K sector erase   */
    {
        memset(chip + (pend_addr & ~0xFFFuL), 0xFF, 4096);
        sim_erase_count++;
    }
    else if(pend_op == 3) { sr1 = pend_sr1; sr2 = pend_sr2; }
    if(pend_op) sr1 &= ~0x02;                          /* WEL cleared       */
    pend_op = 0;
}

static void sim_cs_changed(int level)
{
    if(level == 0) fr_n = 0;      /* falling edge: a new command frame      */
    else           sim_commit();  /* rising  edge: execute what was clocked */
    last_cs = level;
}

static unsigned char sim_xfer(unsigned char out)
{
    unsigned char in = 0xFF;
    if(flash_cs != 0) return 0xFF;

    if(fr_n == 0) { fr_cmd = out; fr_addr = 0; }
    switch(fr_cmd)
    {
        case 0x06: if(fr_n == 0) sr1 |= 0x02; break;
        case 0x04: if(fr_n == 0) sr1 &= ~0x02; break;
        case 0x05: if(fr_n >  0) in = sr1; break;
        case 0x35: if(fr_n >  0) in = sr2; break;
        case 0x01:
            if(fr_n == 1) { pend_sr1 = out; pend_sr2 = sr2; }
            if(fr_n == 2) { pend_sr2 = out; pend_op = 3; }
            break;
        case 0x9F:
            if(fr_n == 1) in = 0xEF;
            if(fr_n == 2) in = 0x40;
            if(fr_n == 3) in = 0x17;
            break;
        case 0x4B: if(fr_n >= 5 && fr_n <= 12) in = chip_uid[fr_n - 5]; break;
        case 0xAB: case 0x66: case 0x99: break;
        case 0x03:
            if(fr_n >= 1 && fr_n <= 3) fr_addr = (fr_addr << 8) | out;
            else if(fr_n > 3)
            {
                unsigned long a = (fr_addr + (unsigned long)(fr_n - 4)) % SIM_SIZE;
                in = chip[a];
            }
            break;
        case 0x02:
            if(fr_n >= 1 && fr_n <= 3) fr_addr = (fr_addr << 8) | out;
            else if(fr_n > 3)
            {
                if(!(sr1 & 0x02)) break;               /* no WEL -> ignored */
                if(fr_n == 4) { pend_addr = fr_addr; pend_len = 0; pend_op = 1; }
                if(pend_len < 256) pend_buf[pend_len++] = out;
            }
            break;
        case 0x20:
            if(fr_n >= 1 && fr_n <= 3) fr_addr = (fr_addr << 8) | out;
            if(fr_n == 3) { if(sr1 & 0x02) { pend_addr = fr_addr; pend_op = 2; } }
            break;
        default: break;
    }
    fr_n++;
    return in;
}

void         SPI1_Write(unsigned int d) { sim_xfer((unsigned char)d); }
unsigned int SPI1_Read (unsigned int d) { return sim_xfer((unsigned char)d); }

#define _SPI_MASTER 0
#define _SPI_8_BIT 0
#define _SPI_PRESCALE_SEC_1 0
#define _SPI_PRESCALE_PRI_4 0
#define _SPI_SS_DISABLE 0
#define _SPI_DATA_SAMPLE_MIDDLE 0
#define _SPI_CLK_IDLE_HIGH 0
#define _SPI_ACTIVE_2_IDLE 0
void SPI1_Init_Advanced(int a,int b,int c,int d,int e,int f,int g,int h)
{ (void)a;(void)b;(void)c;(void)d;(void)e;(void)f;(void)g;(void)h; }

void sim_power_on(void){ memset(chip, 0xFF, SIM_SIZE); sr1 = 0; sr2 = 0; last_cs = 1; }
#endif
