void tris_init()
{
    TRISB.RB3=0;
    TRISB.RB5=0;
    mmc_error=0;
    TRISB.RB6=1;
    TRISB.RB7=0;
    LATB.RB7=0;
    TRISB.RB8=0;
    //TRISB.RC15=0;

    TRISB.RB0=1;
    TRISB.RB1=1;
    TRISB.RB4=1;
    TRISF.RF0=0;
    TRISF.RF1=0;
    TRISF.RF2=1;
    TRISF.RF3=0;
    TRISF.RF4=1;
    TRISF.RF5=0;
    TRISF.RF6=0;
    TRISE.RE0=0;
    TRISE.RE1=0;
    TRISE.RE2=0;
    TRISE.RE3=0;
    TRISE.RE4=0;
    TRISE.RE5=0;
    TRISE.RE8=1;
    TRISC.RC13=0;
    TRISC.RC14=1;
    TRISD=0;
    LATD=0;
    TRISB.RB2=0;
    //LATD.RD3=1;
    //LATD.RD1=1;
}
void tmrcp_init()
{
    current_loop=0;
    docal=0;
    TMR2=0x0000;
    T2CON=0x0000;
    T4CON=0x0000;
    PR4=14744;
    T4IF_bit=0;
    T4IE_bit=1;
    if(AUTCAL) IC7CON=0x00E5;
    else IC7CON=0x00E4;
    T4CON.TON=1;
    T2CON.TON=1;
    T4CON.TSIDL=0;
    T2CON.TSIDL=0;
}