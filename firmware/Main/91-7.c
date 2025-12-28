#define Reset() asm{RESET}
#define Clrwdt() asm{CLRWDT}

#include "Variables.h"
#include "DS1305_Lib.h"
#include "GPRS.h"
#include "MMC.h"
#include "Interval.h"
#include "Capture_Int_Lib.h"
#include "UART_Int_Lib.h"
#include "Classification.h"

void TRAP_OSC() org 0x6
{
     OSCFAIL_bit=0;
     Reset();
}
void TRAP_ADR() org 0x8
{
     ADDRERR_bit=0;
     Reset();
}
void TRAP_STK() org 0xA
{
     STKERR_bit=0;
     Reset();
}
void TRAP_ART() org 0xC
{
     MATHERR_bit=0;
     Reset();
}

void TMR4INT() iv IVT_ADDR_T4INTERRUPT
{
    //how_many_micro++;
    
    //if(how_many_micro%10==0)
    {
        T2CON.TON=0;
        if(timexen[0]) timex[0]++;
        if(timexen[1]) timex[1]++;

        if(!docal)
        {
            if(current_gap[0]<10000) current_gap[0]++;
            if(current_gap[1]<10000) current_gap[1]++;
            if(onloop0) l1occ++;
            if(onloop1) l1occ++;
            if(onloop2) l2occ++;
            if(onloop3) l2occ++;

        }
        loop_error_tmp=0;
        capw=0;
        capx=0;
        capy=0;
        capz=0;

        capw=(unsigned long)(IC7BUF);
        capw=(unsigned long)(IC7BUF);
        if(IC7CON.ICBNE) loop_error_tmp=1;
        capz=(unsigned long)(IC7BUF);
        capx=(unsigned long)(IC7BUF);
        IC7CON=0;
        TMR2=0;
        if(loop_error_tmp==0)
        {
            dev[current_loop]=0;
            if(current_loop==0)
            {
                set_error(LP1_ERR);
            }
            if(current_loop==1)
            {
                set_error(LP2_ERR);
            }
            if(current_loop==2)
            {
                set_error(LP3_ERR);
            }
            if(current_loop==3)
            {
                set_error(LP4_ERR);
            }
        }
        else
        {
            //freq_mean[current_loop]=4*(capz-capw);
            freq_mean[current_loop]=(capz-capw);
            //freq_mean[current_loop]=freq_mean[current_loop]/loop_error_tmp;
            //freq_mean[current_loop]=(capz);
            freq_help=(float)(caldata[current_loop]-freq_mean[current_loop]);
            freq_help/=(float)(caldata[current_loop]);
            freq_help*=10000;
            dev[current_loop]=(int)(freq_help);
            if(current_loop==0)
            {
                reset_error(LP1_ERR);
            }
            if(current_loop==1)
            {
                reset_error(LP2_ERR);
            }
            if(current_loop==2)
            {
                reset_error(LP3_ERR);
            }
            if(current_loop==3)
            {
                reset_error(LP4_ERR);
            }
        }
        do
        {
            current_loop++;
            if(current_loop==4) current_loop=0;
        }while(loop[current_loop]==0);
        if(AUTCAL) IC7CON=0x00E5;
        else IC7CON=0x00E4;
        LATD=current_loop;
        T2CON.TON=1;
        if(docal) forth++;

        measure_loops();
    }
    how_many_micro++;
    if(how_many_micro==1000)
    {
       milisec=0;
       timer_1_sec=1;

       if(current_time.second<59) current_time.second++;
       else
       {
           current_time.second=0;
           if(current_time.minute<59) current_time.minute++;
           else
           {
               current_time.minute=0;
               if(current_time.hour<23) current_time.hour++;
               else
               {
                   current_time.hour=0;
                   if(current_time.day<31) current_time.day++;
                   else
                   {
                       current_time.day=1;
                       if(current_time.month<12) current_time.month++;
                       else
                       {
                           current_time.year++;
                       }
                   }
               }
           }
       }
       how_many_micro=0;
     }
     milisec=how_many_micro;
    T4IF_bit=0;
}
void cal()                  //CAlibrate
{

    docal=1;
    longk=0;
    for(cal_k=0;cal_k<4;cal_k++)
    {
        caldata[cal_k]=0;
        calsum[cal_k]=0;
        calpointer[cal_k]=0;
    }
    while(longk<10)
    {
        while(forth<4);
        calsum[0]+=(freq_mean[0]);
        calpointer[0]++;
        calsum[1]+=(freq_mean[1]);
        calpointer[1]++;
        calsum[2]+=(freq_mean[2]);
        calpointer[2]++;
        calsum[3]+=(freq_mean[3]);
        calpointer[3]++;
        forth=0;
        longk++;
        delay_ms(100);
    }
    for(cal_k=0;cal_k<4;cal_k++)
    {
        caldata[cal_k]=(unsigned long)(calsum[cal_k]/(unsigned long)(calpointer[cal_k]));
    }
    docal=0;
}
void main() {
{
    NSTDIS_bit=1;
    modem_pwr=1;
    PWRKEY=0;
    milisec=0;
    memory_error=1;
    reset_interval_data();
    forth=0;
    sim_reset=0;
    sim_reset_step=0;
    sim_reset_timer=0;
    ADPCFG=0xFFFC;                             //   Setting Analog Channels
    PWMCON1=0x0000;
    OVDCON=0x0000;
    gprs_timer_en=0;
    HMM=eeprom_read(0x7FFCC8);
    //delay_ms(2000);
    tris_init();

    l1occ=0;
    l2occ=0;
    rtc=0;
    mmc=1;
    current_gap[0]=0;
    current_gap[1]=0;
    mmc_int_send=0;
    spi_busy=0;
    reset_interval();
    IPC0=0x2000;
    IPC2=0x0010;
    IPC4=0x0000;
    IPC5=0x0070;
    IPC6=0x0003;
    debug=0;
    send_sms=0;
    delay_ms(100);
     MARGINTOP=eeprom_read(0x7FFC00);
     delay_ms(30);
     MARGINBOT=eeprom_read(0x7FFC04);
     delay_ms(30);
     loop[0]=eeprom_read(0x7FFC08);
     delay_ms(30);
     loop[1]=eeprom_read(0x7FFC0C);
     delay_ms(30);
     loop[2]=eeprom_read(0x7FFC10);
     delay_ms(30);
     loop[3]=eeprom_read(0x7FFC14);
     delay_ms(30);
     loop_distance=eeprom_read(0x7FFC18);
     delay_ms(30);
     loop_width=eeprom_read(0x7FFC1C);
     delay_ms(30);
     if(loop_distance<150 || loop_distance>500)
     {
         if(loop_width==140) loop_distance=200;
         else loop_distance=400;
     }
     apndata=eeprom_read(0x7FFC20);
     delay_ms(30);
     ip1=eeprom_read(0x7FFC24);
     delay_ms(30);
     ip2=eeprom_read(0x7FFC28);
     delay_ms(30);
     ip3=eeprom_read(0x7FFC2C);
     delay_ms(30);
     ip4=eeprom_read(0x7FFC30);
     delay_ms(30);
     port=eeprom_read(0x7FFC34);
     delay_ms(30);
     /*serial_vbv=eeprom_read(0x7FFC38);
     delay_ms(30); */
     DSPEED1=eeprom_read(0x7FFCC0);
     delay_ms(30);
     NSPEED1=eeprom_read(0x7FFCC4);
     delay_ms(30);
     DSPEED2=eeprom_read(0x7FFCD0);
     delay_ms(30);
     NSPEED2=eeprom_read(0x7FFCD4);
     delay_ms(30);
     AUTCAL=eeprom_read(0x7FFCCC);
     delay_ms(30);
     LIMX=eeprom_read(0x7FFC3C);
     delay_ms(30);
     LIMA=eeprom_read(0x7FFC40);
     delay_ms(30);
     LIMB=eeprom_read(0x7FFC44);
     delay_ms(30);
     LIMC=eeprom_read(0x7FFC48);
     delay_ms(30);
     LIMD=eeprom_read(0x7FFC4C);
     delay_ms(30);
     LIMITE=eeprom_read(0x7FFC50);
     delay_ms(30);
     PRVAL=eeprom_read(0x7FFC54);
     delay_ms(30);
     power_type=eeprom_read(0x7FFC58);
     delay_ms(30);
     sms_number_1[0]=(char)(eeprom_read(0x7FFC60)/256);
     delay_ms(3);
     sms_number_1[1]=(char)(eeprom_read(0x7FFC60)%256);
     delay_ms(3);
     sms_number_1[2]=(char)(eeprom_read(0x7FFC64)/256);
     delay_ms(3);
     sms_number_1[3]=(char)(eeprom_read(0x7FFC64)%256);
     delay_ms(3);
     sms_number_1[4]=(char)(eeprom_read(0x7FFC68)/256);
     delay_ms(3);
     sms_number_1[5]=(char)(eeprom_read(0x7FFC68)%256);
     delay_ms(3);
     sms_number_1[6]=(char)(eeprom_read(0x7FFC6C)/256);
     delay_ms(3);
     sms_number_1[7]=(char)(eeprom_read(0x7FFC6C)%256);
     delay_ms(3);
     sms_number_1[8]=(char)(eeprom_read(0x7FFC70)/256);
     delay_ms(3);
     sms_number_1[9]=(char)(eeprom_read(0x7FFC70)%256);
     delay_ms(3);
     sms_number_1[10]=(char)(eeprom_read(0x7FFC74)/256);
     delay_ms(3);

     location_name[0]=(char)(eeprom_read(0x7FFC80)/256);
     delay_ms(3);
     location_name[1]=(char)(eeprom_read(0x7FFC80)%256);
     delay_ms(3);
     location_name[2]=(char)(eeprom_read(0x7FFC84)/256);
     delay_ms(3);
     location_name[3]=(char)(eeprom_read(0x7FFC84)%256);
     delay_ms(3);
     location_name[4]=(char)(eeprom_read(0x7FFC88)/256);
     delay_ms(3);
     location_name[5]=(char)(eeprom_read(0x7FFC88)%256);
     delay_ms(3);
     location_name[6]=(char)(eeprom_read(0x7FFC8C)/256);
     delay_ms(3);
     location_name[7]=(char)(eeprom_read(0x7FFC8C)%256);
     delay_ms(3);
     location_name[8]=(char)(eeprom_read(0x7FFC90)/256);
     delay_ms(3);
     location_name[9]=(char)(eeprom_read(0x7FFC90)%256);
     delay_ms(3);
     location_name[10]=(char)(eeprom_read(0x7FFC94)/256);
     delay_ms(3);
     location_name[11]=(char)(eeprom_read(0x7FFC94)%256);
     delay_ms(3);
     location_name[12]=(char)(eeprom_read(0x7FFC98)/256);
     delay_ms(3);
     location_name[13]=(char)(eeprom_read(0x7FFC98)%256);
     delay_ms(3);
     location_name[14]=(char)(eeprom_read(0x7FFC9C)/256);
     delay_ms(3);
     location_name[15]=(char)(eeprom_read(0x7FFC9C)%256);
     delay_ms(3);
     location_name[16]=(char)(eeprom_read(0x7FFCA0)/256);
     delay_ms(3);
     location_name[17]=(char)(eeprom_read(0x7FFCA0)%256);
     delay_ms(3);
     location_name[18]=(char)(eeprom_read(0x7FFCA4)/256);
     delay_ms(3);
     location_name[19]=(char)(eeprom_read(0x7FFCA4)%256);
     delay_ms(3);
     location_name[20]=(char)(eeprom_read(0x7FFCA8)/256);
     delay_ms(3);
     location_name[21]=(char)(eeprom_read(0x7FFCA8)%256);
     delay_ms(3);
     location_name[22]=(char)(eeprom_read(0x7FFCAC)/256);
     delay_ms(3);
     location_name[23]=(char)(eeprom_read(0x7FFCAC)%256);
     delay_ms(3);
     location_name[24]=(char)(eeprom_read(0x7FFCB0)/256);
     delay_ms(3);
     location_name[25]=(char)(eeprom_read(0x7FFCB0)%256);
     delay_ms(3);
     location_name[26]=(char)(eeprom_read(0x7FFCB4)/256);
     delay_ms(3);
     location_name[27]=(char)(eeprom_read(0x7FFCB4)%256);
     delay_ms(3);
     location_name[28]=(char)(eeprom_read(0x7FFCB8)/256);
     delay_ms(3);
     location_name[29]=(char)(eeprom_read(0x7FFCB8)%256);
     delay_ms(3);
     location_name[30]=(char)(eeprom_read(0x7FFCBC)/256);
     delay_ms(3);
     location_name[31]=(char)(eeprom_read(0x7FFCBC)%256);
     delay_ms(3);
     
     
     NVMADR=0xFF00;
     NVMADRU=0x007F;

     timer_1_sec=0;
    }
    dis_int=0;
    gsm_ready=0;
    debug_gsm=0;
     line1step=0;
     line2step=0;
     tmrcp_init();
     uart_init();
     delay_ms(10);
     ADC1_Init();
     delay_ms(10);
     Clrwdt();
     spifat_init();
     Clrwdt();
     bytetostr(memory_error,debug_txt);
     UART1_Write_Text(debug_txt);
     err_cnt=0;
     err_cnt2=0;
     delay_ms(10);
     rtc_init();
     //UART1_Write('d');
     delay_ms(10);
     INT0EP_bit=1;
     INT0IF_bit=0;
     INT0IE_bit=0;
     status=0;
     charge_control=0;
     onloop0=1;
     onloop1=1;
     onloop2=1;
     onloop3=1;
     cal();
     onloop0=0;
     onloop1=0;
     onloop2=0;
     onloop3=0;
     reset_class(0);
     reset_class(1);
     jj=0;
     memory_error_sent=0;
     memory_ok_sent=1;
     connection_state=0;
     gprs_send=0;
     //send_atc(gsm_at);
     //UART2_Write(13);
     //delay_ms(1000);
     RTC_read();
     dis_int=1;
     sim900_restart();
     dis_int=0;
     //modem_pwr=1;
     cal_class0=0;
     cal_class1=0;
     send_sms=5;
     while(1)
     {
          asm{PWRSAV #1}
         //modem_pwr=1;
         rtc_read();

         //measure_loops();
         if(cal_class0>0)
         {
             cal_class(0);
             cal_class0=0;
         }
         if(cal_class1>0)
         {
             cal_class(1);
             cal_class1=0;
         }
         for(tmpcnt=0;tmpcnt<4;tmpcnt++)
         {
             if(abs(dev[tmpcnt])<3) cal_timer[tmpcnt]=0;
         }
         if(uart1_data_received==1)
         {
            function_code=(int)((uart1_data[3]-48))+(int)((uart1_data[2]-48)*10)+(int)((uart1_data[1]-48)*100)+(int)((uart1_data[0]-48)*1000);
            process_interface();
            clear_uart1();
         }
         if(timer_1_sec==1)
         {
            rtc_read();
            status=!status;
            Clrwdt();
            if(sim_reset_timer>0) sim_reset_timer=sim_reset_timer-1;
            for(tmpcnt=0;tmpcnt<4;tmpcnt++)
            {
                cal_timer[tmpcnt]++;
                if(cal_timer[tmpcnt]>30)
                {
                    freq_sum_cal=(unsigned long)(caldata[tmpcnt]+freq_mean[tmpcnt]);
                    caldata[tmpcnt]=(unsigned long)(freq_sum_cal/2);
                }
            }
            if(!onloop0 && !onloop1) reset_class(0);
            if(!onloop2 && !onloop3) reset_class(1);
            if(gprs_send>0) { clear_uart2(); UART2_Write(gprs_send); gprs_send=0; }
            if(current_time.second==0)
            {
                longtostr((vbat*0.388509+7),debug_txt);
                if(debug_gsm) UART1_Write_Text(debug_txt);
                if(solar<50)
                longtostr(0,debug_txt);
                else
                longtostr((solar*0.388509),debug_txt);
                if(debug_gsm) UART1_Write_Text(debug_txt);
                if(debug_gsm) UART1_Write(13);
                if(debug_gsm) UART1_Write(10);
                if(current_time.minute%INTERVALPERIOD==0)
                {
                    cal_interval();
                    interval_data[262]=13;
                    interval_data[263]=10;
                    if(debug_gsm)
                       for(cal_interval_cnt=0;cal_interval_cnt<264;cal_interval_cnt++)
                       {
                           UART1_Write(interval_data[cal_interval_cnt]);
                       }
                    mmc_int_send=1;
                    connection_state=0;
                    gprs_state=0;

                }
                if(current_time.minute==0 && current_time.hour==0)
                {
                    sim900_restart();
                }

            }
            if(!mdmstat) sim900_restart();
            vbat=(long)ADC1_Get_Sample(0);
            if(vbat<230) set_error(LBT_ERR);
            else reset_error(LBT_ERR);
            solar=(long)ADC1_Get_Sample(1);
            if(power_type==0)              //solar power
            {
                if(current_time.hour>10  && current_time.hour<14 && solar<200) set_error(SOL_ERR);
                if(solar>250) reset_error(SOL_ERR);

            }
            else if(power_type==1)              //night power
            {
                if(current_time.minute==30 && current_time.hour==22 && solar<200) set_error(VMN_ERR);
                if(solar>250) reset_error(VMN_ERR);
            }
            else if(power_type==2)              //backup power
            {
                if(solar<200) set_error(VMN_ERR);
                if(solar>250)
                {
                    reset_error(VMN_ERR);
                    charge_control=1;
                }
            }
            if(gprs_timer_en)
            {
                if(gprs_timer<=gprs_end_timer) gprs_timer++;
                else
                {
                    uart2_data_received=1;
                    err_cnt2++;
                    gprs_timer_en=0;
                }
            }
            timer_1_sec=0;
            if(gsm_ready>0) gsm_ready--;
            if(is_error(MMC_ERR)) mmc_error=status;
            else mmc_error=0;
         }
         if(err_cnt>60 || err_cnt2>20)
         {
              sim900_restart();
              err_cnt=0;
              err_cnt2=0;
         }
         if(mmc_int_send==1)
         {
            interval_data[262]=13;
            interval_data[263]=10;
            current_sector= 31*24*60*(unsigned long)((interval_data[10]-48)*10+(interval_data[11]-48));
            current_sector+= 24*60*(unsigned long)((interval_data[12]-48)*10+(interval_data[13]-48));
            current_sector+= 60*(unsigned long)((interval_data[14]-48)*10+(interval_data[15]-48));
            current_sector+= (unsigned long)((interval_data[16]-48)*10+(interval_data[17]-48));
            Mmc_Write_Sector(current_sector, interval_data);
            mmc_int_send=0;
         }
         if(debug)
         {
            for(tmpcnt=0;tmpcnt<4;tmpcnt++)
            if(loop[tmpcnt])
            {
                inttostr(dev[tmpcnt],tmp7);
                UART1_Write_Text(tmp7);
                //inttostr(freq_mean[tmpcnt],tmp7);
                //UART1_Write_Text(tmp7);
                //inttostr(caldata[tmpcnt],tmp7);
                //UART1_Write_Text(tmp7);
            }
            UART1_Write(13);
            UART1_Write(10);
            //delay_ms(10);
         }
         if(sim_reset==1)
         {
             if(sim_reset_step==0)
             {
                 modem_pwr=1;
                 sim_reset_timer=5;
                 sim_reset_step=1;

             }
             else if(sim_reset_timer==0)
             {
                 if(sim_reset_step==1)
                 {
                     sim_reset_timer=2;
                     sim_reset_step=2;

                     PWRKEY=0;
                     connection_state=0;
                     gprs_state=0;
                     modem_pwr=0;
                     pwrkey=1;
                 }
                 else if(sim_reset_step==2)
                 {
                     sim_reset_timer=15;
                     sim_reset_step=3;
                     gsm_ready=20;
                     pwrkey=0;
                     //clear_uart2();
                     //UART2_Write('A');
                     //delay_ms(10);
                     //UART2_Write('T');
                     //delay_ms(10);
                    // UART2_Write(13);
                 }
                 else if(sim_reset_step==3)
                 {
                     sim_reset_timer=1;
                     sim_reset_step=4;

                     pwrkey=0;
                     clear_uart2();
                     UART2_Write('A');
                     //delay_ms(10);
                     UART2_Write('T');
                     //delay_ms(10);
                     UART2_Write(13);
                 }
                 else if(sim_reset_step==4)
                 {
                     sim_reset_timer=1;
                     sim_reset_step=5;

                     send_atc("AT+IPR=115200");
                     UART2_Write(13);
                 }
                 else if(sim_reset_step==5)
                 {
                     sim_reset_timer=1;
                     sim_reset_step=6;

                     send_atc("AT+CSCLK=2");
                     UART2_Write(13);
                 }
                 else if(sim_reset_step==6)
                 {
                     sim_reset_timer=1;
                     sim_reset_step=7;

                     send_atc("AT&W");
                     UART2_Write(13);
                 }
                 else if(sim_reset_step==7)
                 {
                     sim_reset_timer=1;
                     sim_reset_step=8;

                     send_atc(gsm_ate0);
                     UART2_Write(13);
                 }
                 else if(sim_reset_step==8)
                 {
                     sim_reset_timer=3;
                     sim_reset_step=9;

                     send_atc("AT+CMGDA=\"DEL");
                     UART2_Write(' ');
                     send_atc("ALL\"");
                     UART2_Write(13);
                 }
                 else if(sim_reset_step==9)
                 {
                     sim_reset_timer=3;
                     sim_reset_step=10;

                     send_atc("AT+CGATT=1");
                     UART2_Write(13);
                     delay_ms(50);
                     send_atc("AT+CSMP=17,167,0,0");
                     UART2_Write(13);
                 }
                 else if(sim_reset_step==10)
                 {
                     clear_uart2();
                     connection_state=0;
                     gprs_state=0;
                     sim_reset=0;
                     sim_reset_step=0;
                     sim_reset_timer=0;

                 }
             }
         }
         else if(gsm_ready==0)
         {
              if(!connection_state)
              {
                  //
                  if(gprs_state==0)     // CIPSHUT
                  {
                      //send_atc(gsm_cipshut);
                      set_gprs_timer(0);
                      clear_uart2();
                      UART2_Write('A');
                      delay_ms(10);
                      send_atc(gsm_cipshut);
                      delay_us(50);

                      gprs_send=13;
                      gprs_state=1;
                  }
                  else if(uart2_data_received)
                  {
                      gprs_timer_en=0;
                      uart2_data_received=0;
                      if(gprs_state==1)
                      {
                          // AT+CSTT
                          if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
                          {
                              send_atc(gsm_cstt[apndata]);
                              set_gprs_timer(0);
                              delay_us(50);
                              clear_UART2();
                              gprs_send=13;
                              gprs_state=2;

                          }
                          else
                          {
                              err_cnt++;
                              gprs_state=0;
                          }
                      }
                      else if(gprs_state==2)
                      {
                          // AT+CIICR
                          if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O'  && uart2_data[uart2_data_pointer-1] == 'K')
                          {
                              send_atc(gsm_ciicr);
                              set_gprs_timer(35);
                              delay_us(50);
                              clear_UART2();
                              gprs_send=13;
                              gprs_state=3;
                          }
                          else
                          {
                              err_cnt++;
                              gprs_state=0;
                          }
                      }
                      else if(gprs_state==3)
                      {
                          // AT+CIFSR
                          if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O'  && uart2_data[uart2_data_pointer-1] == 'K')
                          {
                              send_atc(gsm_cifsr);
                              set_gprs_timer(0);
                              delay_us(50);
                              clear_UART2();
                              gprs_send=13;
                              gprs_state=4;
                          }
                          else
                          {
                              err_cnt++;
                              gprs_state=0;
                          }
                      }
                      else if(gprs_state==4)
                      {
                          // AT+CIPSTART
                          if(uart2_data_pointer>6)
                          {
                              send_atc(gsm_cipstart);
                              //send_atc(gsm_cipstart);
                              inttostr(ip1,tmp7);
                              send_atc(tmp7);
                              UART2_Write('.');
                              delay_us(5);
                              inttostr(ip2,tmp7);
                              send_atc(tmp7);
                              UART2_Write('.');
                              delay_us(5);
                              inttostr(ip3,tmp7);
                              send_atc(tmp7);
                              UART2_Write('.');
                              delay_us(5);
                              inttostr(ip4,tmp7);
                              send_atc(tmp7);
                              send_atc("\",");
                              inttostr(port,tmp7);
                              send_atc(tmp7);
                              gprs_send=13;
                              gprs_state=5;
                              clear_UART2();
                              set_gprs_timer(2);
                          }
                          else
                          {
                              err_cnt++;
                              gprs_state=0;
                          }
                      }
                      else if(gprs_state==5)
                      {
                          // AT+CIPSEND
                          if(uart2_data_pointer>3 && uart2_data[uart2_data_pointer-4] == 'T' && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
                          {
                              connection_state=1;
                              clear_uart2();
                              gprs_state=0;
                              uart2_data_received=1;
                              err_cnt=0;
                              err_cnt2=0;
                              u2func=100;
                          }
                          else if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
                          {
                              clear_UART2();
                              set_gprs_timer(20);
                          }
                          else
                          {
                              err_cnt++;
                              gprs_state=0;
                          }
                      }

                  }
              }
              else   //GPRSSTAT =1
              {
                if(uart2_data_received)
                {
                    uart2_data_received=0;
                    if(uart2_data[0]=='C' && uart2_data[1]=='L' && uart2_data[2]=='O' && uart2_data[3]=='S')
                    {
                        connection_state=0;
                        gprs_state=0;
                    }
                    else
                    {
                        if(gprs_state==0)
                        {
                            if((uart2_data[0]=='0') || u2func==100)
                            {
                                UART2_Write('A');
                                delay_ms(10);
                                send_atc(gsm_cipsend);
                                if(u2func==100)
                                {
                                    send_atc("59");
                                }
                                else if(uart2_data[0]=='0' && uart2_data[1]=='1' && uart2_data[2]=='9' && uart2_data[3]=='7')
                                {
                                    u2func=3;
                                    //mmc_search(uart2_data);
                                    current_sector= 31*24*60*(unsigned long)((uart2_data[6]-48)*10+(uart2_data[7]-48));
                                    current_sector+= 24*60*(unsigned long)((uart2_data[8]-48)*10+(uart2_data[9]-48));
                                    current_sector+= 60*(unsigned long)((uart2_data[10]-48)*10+(uart2_data[11]-48));
                                    current_sector+= (unsigned long)((uart2_data[12]-48)*10+(uart2_data[13]-48));
                                    Mmc_Read_Sector(current_sector, interval_data);
                                     if(interval_data[8]!=uart2_data[4] ||
                                        interval_data[9]!=uart2_data[5] ||
                                        interval_data[10]!=uart2_data[6] ||
                                        interval_data[11]!=uart2_data[7] ||
                                        interval_data[12]!=uart2_data[8] ||
                                        interval_data[13]!=uart2_data[9] ||
                                        interval_data[14]!=uart2_data[10] ||
                                        interval_data[15]!=uart2_data[11] ||
                                        interval_data[16]!=uart2_data[12] ||
                                        interval_data[17]!=uart2_data[13])
                                        {
                                         reset_interval_data();
                                         interval_data[8]=uart2_data[4];
                                        interval_data[9]=uart2_data[5];
                                        interval_data[10]=uart2_data[6];
                                        interval_data[11]=uart2_data[7];
                                        interval_data[12]=uart2_data[8];
                                        interval_data[13]=uart2_data[9];
                                        interval_data[14]=uart2_data[10];
                                        interval_data[15]=uart2_data[11];
                                        interval_data[16]=uart2_data[12];
                                        interval_data[17]=uart2_data[13];
                                        }
                                     interval_data[262]=13;
                                     interval_data[263]=10;
                                     interval_data[264]=0;
                                    send_atc("287");
                                }
                                else if(uart2_data[0]=='0' && uart2_data[1]=='0' && uart2_data[2]=='1' && uart2_data[3]=='2')
                                {
                                    rtc_write(2);
                                    rtc_read();
                                    u2func=12;
                                    send_atc("33");
                                }
                                UART2_Write(13);

                                //delay_ms(250);
                                //i=0;

                                sending_ready=0;
                                sending_ready_i=0;
                                while(!sending_ready && sending_ready_i<100)
                                {
                                    delay_ms(20);
                                    sending_ready_i++;
                                    if(sending_ready_i==40)UART2_Write(13);
                                }
                                //delay_ms(500);
                                //while(uart2_data[uart2_data_pointer-1]!=' ');
                                if(sending_ready)
                                {
                                    clear_UART2();
                                    if(u2func==3)
                                    {
                                        send_atc("8821");
                                        send_atc(datetimesec);
                                        send_atc(interval_data);
                                    }
                                    else if(u2func==12)
                                    {
                                        send_atc("8012");
                                        send_atc(datetimesec);
                                        send_atc(system_id);
                                    }
                                    else if(u2func==100)
                                    {
                                        send_atc("8000");
                                        send_atc(datetimesec);
                                        send_atc(system_id);
                                        send_atc(system_model);
                                        send_atc(version);
                                        send_atc("READY");
                                    }
                                    u2func=0;
                                    gprs_send=0;
                                    set_gprs_timer(20);
                                    gprs_state=1;
                                    clear_uart2();
                                    uart2_data_received=0;
                                }
                                else
                                {
                                    gprs_state=0;
                                    connection_state=0;
                                }
                            }
                            else
                            {
                                gprs_state=0;
                                connection_state=0;
                            }
                        }
                        else if(gprs_state==1)
                        {
                            if(uart2_data[0]=='S' && uart2_data[1]=='E' && uart2_data[5]=='O' && uart2_data[6]=='K')
                            {
                                gprs_state=0;
                                gprs_timer_en=0;
                                clear_uart2();
                                u2func=0;
                            }
                            else
                            {
                                gprs_state=0;
                                connection_state=0;
                            }
                        }
                    }
                }
             }
         }
     }
  }