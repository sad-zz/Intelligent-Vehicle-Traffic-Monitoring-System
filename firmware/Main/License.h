/*******************************************************************************
*  License.h  -  device activation / anti-copy binding
*
*  Tosee Noavaran Jonoub  --  Vehicle Traffic Counter (dsPIC30F4011)
*
*  What this protects and what it does NOT protect
*  -----------------------------------------------
*  The firmware itself is protected by the dsPIC30F code protection bits
*  (FGS: GCP + GWRP, already enabled in 91-7.cfg) - that is what stops the
*  .hex from being read back out of a programmed micro.
*
*  This module adds the second half: even if somebody obtains the .hex, a
*  board flashed with it will not become a fully working, sellable device
*  unless it also carries an activation code.  The code is derived from the
*  64 bit factory-unique serial number of the W25Q64JVS flash (command 0x4B),
*  so every board needs its own code and codes cannot be shared between
*  boards.  Only the manufacturer can generate one, because the derivation
*  needs LIC_SECRET, which lives inside the code-protected firmware.
*
*  Field workflow
*  --------------
*    1. After assembly, connect a terminal to UART1 and send  "0198".
*       The device prints its flash UID, e.g.  UID: E4680C51A1B23344
*    2. The manufacturer runs the same hash over that UID with LIC_SECRET
*       and returns 8 hexadecimal characters, e.g.  9F3C21D0
*    3. The installer sends  "01999F3C21D0"  (function code 0199 followed by
*       the 8 characters).  The code is stored in the data EEPROM of the
*       dsPIC and is verified again at every power-up.
*
*  Safety first
*  ------------
*  LICENSE_ENFORCE defaults to 0.  In that mode an unlicensed unit behaves
*  EXACTLY as before - it counts, stores and uploads normally - it only
*  reports "not activated" over the serial link and raises the LIC_ERR bit,
*  so nothing in the field can ever stop working because of this feature.
*  Set LICENSE_ENFORCE to 1 only when the activation codes of the whole
*  production fleet have been issued and archived.
*
*  With LICENSE_ENFORCE 1 an unlicensed unit still measures and still writes
*  to the flash; only the GPRS upload of the interval record is suppressed
*  and the identification reply reports NOLIC instead of READY.  Nothing is
*  bricked and nothing is erased - sending a valid code re-enables it
*  instantly, with no reprogramming.
*
*  If the flash cannot be identified (memory_error) the UID is unknown, so
*  the check is skipped entirely and the device keeps running: a defective
*  flash must never be mistaken for a stolen firmware.
*******************************************************************************/

#define LICENSE_ENFORCE      0            /* 0 = report only, 1 = limit GPRS  */

/* Change this per customer / per production batch, then keep it secret.
   Anybody who knows it can generate activation codes.                       */
#define LIC_SECRET           0x5A17C3E9uL

/* Data EEPROM words, well above the configuration block that ends at
   0x7FFCD4.  Same 4-step addressing the rest of the project uses.           */
#define LIC_EE_HIGH          0x7FFD00
#define LIC_EE_LOW           0x7FFD04

#define LIC_STATE_OK         0            /* activation code matches          */
#define LIC_STATE_BAD        1            /* missing or wrong code            */
#define LIC_STATE_UNKNOWN    2            /* flash UID unreadable - no check  */

short
    license_state;
unsigned long
    license_expected,
    license_stored;

const char license_hexchr[17] = "0123456789ABCDEF";

/* 32 bit FNV-1a style keyed digest of the flash unique id.
   Every step is masked to 32 bits so that the reference generator on the PC
   (tools/license_keygen.py) produces bit-identical results whatever the word
   width of the machine it runs on.                                          */
unsigned long license_hash()
{
    unsigned long h;
    unsigned char i;
    h = LIC_SECRET;
    for(i = 0; i < 8; i++)
    {
        h = (h ^ (unsigned long)flash_uid[i]) & 0xFFFFFFFFuL;
        h = (h * 16777619uL) & 0xFFFFFFFFuL;
        h = (h ^ (h >> 13)) & 0xFFFFFFFFuL;
    }
    h = (h ^ (unsigned long)XMICRO) & 0xFFFFFFFFuL;
    if(h == 0) h = LIC_SECRET;            /* never accept an all zero code    */
    return h;
}

char license_uid_is_valid()
{
    unsigned char i, all00, allff;
    all00 = 1;
    allff = 1;
    for(i = 0; i < 8; i++)
    {
        if(flash_uid[i] != 0x00) all00 = 0;
        if(flash_uid[i] != 0xFF) allff = 0;
    }
    if(all00 || allff) return 0;
    return 1;
}

void license_check()
{
    if(memory_error || !license_uid_is_valid())
    {
        license_state = LIC_STATE_UNKNOWN;
        reset_error(LIC_ERR);
        return;
    }

    license_expected = license_hash();
    license_stored   = (unsigned long)((unsigned int)eeprom_read(LIC_EE_HIGH));
    license_stored   = license_stored << 16;
    license_stored  |= (unsigned long)((unsigned int)eeprom_read(LIC_EE_LOW));

    if(license_stored == license_expected)
    {
        license_state = LIC_STATE_OK;
        reset_error(LIC_ERR);
    }
    else
    {
        license_state = LIC_STATE_BAD;
        set_error(LIC_ERR);
    }
}

void license_store(unsigned long key)
{
    eeprom_write(LIC_EE_HIGH, (unsigned int)(key >> 16));
    delay_ms(30);
    eeprom_write(LIC_EE_LOW,  (unsigned int)(key & 0x0000FFFFuL));
    delay_ms(30);
    NVMADR  = 0xFF00;
    NVMADRU = 0x007F;
}

/* 1 = the unit is allowed to do the full job */
char license_granted()
{
#if LICENSE_ENFORCE == 1
    if(license_state == LIC_STATE_BAD) return 0;
#endif
    return 1;
}

/* ------------------------------ serial helpers --------------------------- */
void license_write_hex8(unsigned char b)
{
    UART1_Write(license_hexchr[(b >> 4) & 0x0F]);
    UART1_Write(license_hexchr[b & 0x0F]);
}

void license_write_hex32(unsigned long v)
{
    license_write_hex8((unsigned char)(v >> 24));
    license_write_hex8((unsigned char)(v >> 16));
    license_write_hex8((unsigned char)(v >> 8));
    license_write_hex8((unsigned char)(v));
}

unsigned char license_hex_value(char c)
{
    if(c >= '0' && c <= '9') return (unsigned char)(c - '0');
    if(c >= 'A' && c <= 'F') return (unsigned char)(c - 'A' + 10);
    if(c >= 'a' && c <= 'f') return (unsigned char)(c - 'a' + 10);
    return 0xFF;
}

/* parses 8 hex characters starting at src[0]; returns 1 on a format error */
char license_parse(char *src, unsigned long *out)
{
    unsigned char i, v;
    unsigned long k;
    k = 0;
    for(i = 0; i < 8; i++)
    {
        v = license_hex_value(src[i]);
        if(v == 0xFF) return 1;
        k = (k << 4) | (unsigned long)v;
    }
    *out = k;
    return 0;
}
