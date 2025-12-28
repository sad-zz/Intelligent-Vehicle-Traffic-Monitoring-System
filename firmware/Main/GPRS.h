void send_atc(const char *s)
{
   while(*s) 
   {              // send command string
       if(*s!=10 && *s!=13 && *s!=' ')
       {
           if(debug_gsm) UART1_Write(*s);
           UART2_Write(*s);
           delay_us(15);
       }
       s++;
      //delay_us(10);
      
   }
}
void send_out(const char *s)
{
   while(*s)
   {              // send command string
       if(*s!=10 && *s!=13)
       {
           //#ifndef ZTCSLAVE
           UART1_Write(*s);
           //#endif
           //UART2_Write(*s);
           delay_us(15);
       }
       s++;
      //delay_us(10);

   }
}
void set_gprs_timer(unsigned short timer)
{
    gprs_timer=0;
    gprs_end_timer=timer+1;
    gprs_timer_en=1;
}
void sim900_restart()
{
    sim_reset=1;
}