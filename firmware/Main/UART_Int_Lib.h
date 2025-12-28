void uart_init()
{
    UART1_init(115200);                          //   Setting UART Data
    U1MODE.ALTIO=1;
    U1MODE.USIDL=0;
    U2MODE.USIDL=0;
    U1RXIF_bit=0;
    UART2_init(115200);
    clear_uart1();
    U1RXIE_bit=1;

    clear_uart2();
    U2RXIF_bit=0;
    U2RXIE_bit=1;
    uart2_data_received=0;
    uart2_data_received2=0;

    U1STAbits.OERR=0;
    U2STAbits.OERR=0;
    u2func=0;
    function_code=0;
    send_out("Started, Step:");
    wordtostr((RCON-8192),tmp7);
    UART1_Write_Text(tmp7);
    send_out("  MMC Error:");
    RCON=0x0000;
}
void UART1INT() iv IVT_ADDR_U1RXINTERRUPT
{
     while(U1STAbits.URXDA)
     {
         udata=UART1_Read();
         UART1_Write(udata);
         if(udata==8 && uart1_data_pointer>0)
         {
             uart1_data_pointer--;
         }
         else if(udata==13)
         {
             uart1_data_received=1;
         }
         else if(udata!=10)
         {
             uart1_data[uart1_data_pointer]=udata;
             uart1_data_pointer++;
         }
     }
     if(uart1_data_pointer==48) clear_uart1();
     //UART1_Write(udata);
     U1RXIF_bit=0;
}

void UART2INT() iv IVT_ADDR_U2RXINTERRUPT
{
     while(U2STAbits.URXDA)
     {
         udata2=UART2_Read();
         if(debug_gsm) UART1_Write(udata2);
         if(!dis_int)
         {
             if(udata2!=10)
             {
                if(udata2!=13)
                {
                    uart2_data[uart2_data_pointer]=udata2;
                    uart2_data_pointer++;
                    if(udata2=='>') sending_ready=1;
                }
                else if(uart2_data_pointer>0)
                {
                    uart2_data_received=1;
                }
             }
             if(uart2_data_pointer==47) uart2_data_pointer=0;
         }
     }
     U2RXIF_bit=0;
}

void distance_write()
{
     loop_distance=(uart1_data[6]-48)+(uart1_data[5]-48)*10+(uart1_data[4]-48)*100;
     eeprom_write(0x7FFC18,loop_distance);
     delay_ms(5);
     NVMADR=0xFF00;
     NVMADRU=0x007F;
}
void looplen_write()
{
     loop_width=(uart1_data[6]-48)+(uart1_data[5]-48)*10+(uart1_data[4]-48)*100;
     eeprom_write(0x7FFC1C,loop_width);
     delay_ms(5);
     NVMADR=0xFF00;
     NVMADRU=0x007F;
}
void margin_write()
{
     MARGINTOP=(uart1_data[5]-48)+(uart1_data[4]-48)*10;
     eeprom_write(0x7FFC00,MARGINTOP);
     delay_ms(5);
     MARGINBOT=(uart1_data[7]-48)+(uart1_data[6]-48)*10;
     eeprom_write(0x7FFC04,MARGINBOT);
     delay_ms(5);
     NVMADR=0xFF00;
     NVMADRU=0x007F;
}
void process_interface()
{
     //extern int LIME;
     UART1_Write(13); UART1_Write(10);
     switch (function_code)
     {
         case 0: 
                 send_out(system_id);
                 //for(i=0;i<8;i++) UART1_Write(system_id[i]);
                 UART1_Write(',');
                 UART1_Write_Text(datetimesec);
                 UART1_Write(',');
                 send_out(system_model);
                 UART1_Write(',');
                 send_out(version);
                 UART1_Write(',');
                 send_out("READY");
                 break;
         case 2:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='0' && uart1_data[3]=='2')
                 {
                     loop[0]=uart1_data[4]-48;
                     eeprom_write(0x7FFC08,loop[0]);
                     delay_ms(5);
                     loop[1]=uart1_data[5]-48;
                     eeprom_write(0x7FFC0C,loop[1]);
                     delay_ms(5);
                     loop[2]=uart1_data[6]-48;
                     eeprom_write(0x7FFC10,loop[2]);
                     delay_ms(5);
                     loop[3]=uart1_data[7]-48;
                     eeprom_write(0x7FFC14,loop[3]);
                     delay_ms(5);
                     //send_out("LASET_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 197:
                 //mmc_search(uart1_data);
                 current_sector= 31*24*60*(unsigned long)((uart1_data[6]-48)*10+(uart1_data[7]-48));
                 current_sector+= 24*60*(unsigned long)((uart1_data[8]-48)*10+(uart1_data[9]-48));
                 current_sector+= 60*(unsigned long)((uart1_data[10]-48)*10+(uart1_data[11]-48));
                 current_sector+= (unsigned long)((uart1_data[12]-48)*10+(uart1_data[13]-48));
                Mmc_Read_Sector(current_sector, interval_data);
                 if(interval_data[8]!=uart1_data[4] ||
                    interval_data[9]!=uart1_data[5] ||
                    interval_data[10]!=uart1_data[6] ||
                    interval_data[11]!=uart1_data[7] ||
                    interval_data[12]!=uart1_data[8] ||
                    interval_data[13]!=uart1_data[9] ||
                    interval_data[14]!=uart1_data[10] ||
                    interval_data[15]!=uart1_data[11] ||
                    interval_data[16]!=uart1_data[12] ||
                    interval_data[17]!=uart1_data[13])
                 {
                 reset_interval_data();
                       interval_data[8]=uart1_data[4];
                      interval_data[9]=uart1_data[5];
                      interval_data[10]=uart1_data[6];
                      interval_data[11]=uart1_data[7];
                      interval_data[12]=uart1_data[8];
                      interval_data[13]=uart1_data[9];
                      interval_data[14]=uart1_data[10];
                      interval_data[15]=uart1_data[11];
                      interval_data[16]=uart1_data[12];
                      interval_data[17]=uart1_data[13];
                      }
                 for(cal_interval_cnt=0;cal_interval_cnt<264;cal_interval_cnt++)
                 {
                     UART1_Write(interval_data[cal_interval_cnt]);
                 }

                 break;
         case 3:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='0' && uart1_data[3]=='3')
                 {
                     AUTCAL=uart1_data[4]-48;
                     eeprom_write(0x7FFCCC,AUTCAL);
                     delay_ms(5);
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                     //send_out("AUTCAL_OK");
                 }
                 break;
         case 4:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='0' && uart1_data[3]=='4')
                 {
                     distance_write();
                     //send_out("LDSET_OK");
                 }
                 break;
         case 5: 
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='0' && uart1_data[3]=='5')
                 {
                     looplen_write();
                     //send_out("LLSET_OK");
                 }
                 break;
         case 6: 
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='0' && uart1_data[3]=='6')
                 {
                     onloop0=1;
                     onloop1=1;
                     onloop2=1;
                     onloop3=1;
                     cal();
                     onloop0=0;
                     onloop1=0;
                     onloop2=0;
                     onloop3=0;
                 }
                 break;
         case 7:
                 longtostr((long)(235930/caldata[0]),debug_txt);
                 UART1_Write_Text(debug_txt);
                 UART1_Write(',');
                 longtostr((long)(235930/caldata[1]),debug_txt);
                 UART1_Write_Text(debug_txt);
                 UART1_Write(',');
                 longtostr((long)(235930/caldata[2]),debug_txt);
                 UART1_Write_Text(debug_txt);
                 UART1_Write(',');
                 longtostr((long)(235930/caldata[3]),debug_txt);
                 UART1_Write_Text(debug_txt);
                 break;
         case 8:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='0' && uart1_data[3]=='8')

                 debug=!debug;
                 break;

         case 10:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='1' && uart1_data[3]=='0')
                 {
                     margin_write();
                     //send_out("MS_OK");
                 }
                 break;
         case 11:
                // if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='1' && uart1_data[3]=='1')
                 {
                     HMM=(uart1_data[4]-48)*10+(uart1_data[5]-48);
                     if(HMM<10) HMM = 10;
                     eeprom_write(0x7FFCC8,HMM);
                     delay_ms(5);
                     //send_out("HMM_OK");
                 }
                 break;
         case 12:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='1' && uart1_data[3]=='2')
                 {
                     rtc_write(1);
                     //send_out("DT_OK");
                 }
                 break;
         case 13:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='1' && uart1_data[3]=='3')

                 Reset();
                 break;

         case 17:
                 //temp=((long)(ADC1_Get_Sample(2)*0.488))-272;
                 sim900_restart();
                 break;
         case 18:
                 //temp=((long)(ADC1_Get_Sample(2)*0.488))-272;
                 UART2_Write('A');
                 delay_ms(50);
                 send_atc("T+CSQ");

                 clear_UART2();
                 debug_gsm=1;
                 UART2_Write(13);
                 delay_ms(100);
                 debug_gsm=0;
                 //while(!uart2_data_received);
                 //delay_ms(1000);

                 break;
         case 19:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='1' && uart1_data[3]=='9')
                 {
                     DSPEED1=(uart1_data[4]-48)*100+(uart1_data[5]-48)*10+(uart1_data[6]-48);
                     NSPEED1=(uart1_data[7]-48)*100+(uart1_data[8]-48)*10+(uart1_data[9]-48);
                     DSPEED2=(uart1_data[10]-48)*100+(uart1_data[11]-48)*10+(uart1_data[12]-48);
                     NSPEED2=(uart1_data[13]-48)*100+(uart1_data[14]-48)*10+(uart1_data[15]-48);

                     eeprom_write(0x7FFCC0,DSPEED1);
                     delay_ms(5);
                     eeprom_write(0x7FFCC4,NSPEED1);
                     delay_ms(5);
                     eeprom_write(0x7FFCD0,DSPEED2);
                     delay_ms(5);
                     eeprom_write(0x7FFCD4,NSPEED2);
                     delay_ms(5);
                     //send_out("SPD_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 21:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='2' && uart1_data[3]=='1')
                 {
                     power_type=uart1_data[4]-48;
                     eeprom_write(0x7FFC58,power_type);
                     delay_ms(5);
                     //send_out("PT_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 22:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='2' && uart1_data[3]=='2')
                 {
                     sms_number_1[0]=uart1_data[4];
                     sms_number_1[1]=uart1_data[5];
                     sms_number_1[2]=uart1_data[6];
                     sms_number_1[3]=uart1_data[7];
                     sms_number_1[4]=uart1_data[8];
                     sms_number_1[5]=uart1_data[9];
                     sms_number_1[6]=uart1_data[10];
                     sms_number_1[7]=uart1_data[11];
                     sms_number_1[8]=uart1_data[12];
                     sms_number_1[9]=uart1_data[13];
                     sms_number_1[10]=uart1_data[14];
                     eeprom_write(0x7FFC60,(int)(sms_number_1[0]*256+sms_number_1[1]));
                     delay_ms(5);
                     eeprom_write(0x7FFC64,(int)(sms_number_1[2]*256+sms_number_1[3]));
                     delay_ms(5);
                     eeprom_write(0x7FFC68,(int)(sms_number_1[4]*256+sms_number_1[5]));
                     delay_ms(5);
                     eeprom_write(0x7FFC6C,(int)(sms_number_1[6]*256+sms_number_1[7]));
                     delay_ms(5);
                     eeprom_write(0x7FFC70,(int)(sms_number_1[8]*256+sms_number_1[9]));
                     delay_ms(5);
                     eeprom_write(0x7FFC74,(int)(sms_number_1[10]*256));
                     delay_ms(5);
                     //send_out("SMS_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 23:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='2' && uart1_data[3]=='3')
                 {
                     location_name[0]=uart1_data[4];
                     location_name[1]=uart1_data[5];
                     location_name[2]=uart1_data[6];
                     location_name[3]=uart1_data[7];
                     location_name[4]=uart1_data[8];
                     location_name[5]=uart1_data[9];
                     location_name[6]=uart1_data[10];
                     location_name[7]=uart1_data[11];
                     location_name[8]=uart1_data[12];
                     location_name[9]=uart1_data[13];
                     location_name[10]=uart1_data[14];
                     location_name[11]=uart1_data[15];
                     location_name[12]=uart1_data[16];
                     location_name[13]=uart1_data[17];
                     location_name[14]=uart1_data[18];
                     location_name[15]=uart1_data[19];
                     location_name[16]=uart1_data[20];
                     location_name[17]=uart1_data[21];
                     location_name[18]=uart1_data[22];
                     location_name[19]=uart1_data[23];
                     location_name[20]=uart1_data[24];
                     location_name[21]=uart1_data[25];
                     location_name[22]=uart1_data[26];
                     location_name[23]=uart1_data[27];
                     location_name[24]=uart1_data[28];
                     location_name[25]=uart1_data[29];
                     location_name[26]=uart1_data[30];
                     location_name[27]=uart1_data[31];
                     location_name[28]=uart1_data[32];
                     location_name[29]=uart1_data[33];
                     location_name[30]=uart1_data[34];
                     location_name[31]=uart1_data[35];
                     eeprom_write(0x7FFC80,(int)(location_name[0]*256+location_name[1]));
                     delay_ms(5);
                     eeprom_write(0x7FFC84,(int)(location_name[2]*256+location_name[3]));
                     delay_ms(5);
                     eeprom_write(0x7FFC88,(int)(location_name[4]*256+location_name[5]));
                     delay_ms(5);
                     eeprom_write(0x7FFC8C,(int)(location_name[6]*256+location_name[7]));
                     delay_ms(5);
                     eeprom_write(0x7FFC90,(int)(location_name[8]*256+location_name[9]));
                     delay_ms(5);
                     eeprom_write(0x7FFC94,(int)(location_name[10]*256+location_name[11]));
                     delay_ms(5);
                     eeprom_write(0x7FFC98,(int)(location_name[12]*256+location_name[13]));
                     delay_ms(5);
                     eeprom_write(0x7FFC9C,(int)(location_name[14]*256+location_name[15]));
                     delay_ms(5);
                     eeprom_write(0x7FFCA0,(int)(location_name[16]*256+location_name[17]));
                     delay_ms(5);
                     eeprom_write(0x7FFCA4,(int)(location_name[18]*256+location_name[19]));
                     delay_ms(5);
                     eeprom_write(0x7FFCA8,(int)(location_name[20]*256+location_name[21]));
                     delay_ms(5);
                     eeprom_write(0x7FFCAC,(int)(location_name[22]*256+location_name[23]));
                     delay_ms(5);
                     eeprom_write(0x7FFCB0,(int)(location_name[24]*256+location_name[25]));
                     delay_ms(5);
                     eeprom_write(0x7FFCB4,(int)(location_name[26]*256+location_name[27]));
                     delay_ms(5);
                     eeprom_write(0x7FFCB8,(int)(location_name[28]*256+location_name[29]));
                     delay_ms(5);
                     eeprom_write(0x7FFCBC,(int)(location_name[30]*256+location_name[31]));
                     delay_ms(5);
                     //send_out("NAME_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 25:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='2' && uart1_data[3]=='5')
                 {
                     debug_gsm=~debug_gsm;
                 }
                 break;
         case 32:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='3' && uart1_data[3]=='2')
                 {
                     apndata=uart1_data[4]-48;
                     eeprom_write(0x7FFC20,apndata);
                     delay_ms(5);
                     //send_out("APN_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 34:
                 if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='3' && uart1_data[3]=='4')
                 {
                     ip1=(uart1_data[4]-48)*100+(uart1_data[5]-48)*10+(uart1_data[6]-48);
                     eeprom_write(0x7FFC24,ip1);
                     delay_ms(5);
                     ip2=(uart1_data[8]-48)*100+(uart1_data[9]-48)*10+(uart1_data[10]-48);
                     eeprom_write(0x7FFC28,ip2);
                     delay_ms(5);
                     ip3=(uart1_data[12]-48)*100+(uart1_data[13]-48)*10+(uart1_data[14]-48);
                     eeprom_write(0x7FFC2C,ip3);
                     delay_ms(5);
                     ip4=(uart1_data[16]-48)*100+(uart1_data[17]-48)*10+(uart1_data[18]-48);
                     eeprom_write(0x7FFC30,ip4);
                     delay_ms(5);
                     port=(uart1_data[20]-48)*10000+(uart1_data[21]-48)*1000+(uart1_data[22]-48)*100+(uart1_data[23]-48)*10+(uart1_data[24]-48);
                     eeprom_write(0x7FFC34,port);
                     delay_ms(5);
                 }
                 break;
         case 40:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='4' && uart1_data[3]=='0')
                 {
                     LIMX=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
                     eeprom_write(0x7FFC3C,LIMX);
                     delay_ms(5);
                     //send_out("X_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 41:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='4' && uart1_data[3]=='1')
                 {
                     LIMA=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
                     eeprom_write(0x7FFC40,LIMA);
                     delay_ms(5);
                     //send_out("A_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 42:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='4' && uart1_data[3]=='2')
                 {
                     LIMB=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
                     eeprom_write(0x7FFC44,LIMB);
                     delay_ms(5);
                     //send_out("B_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 43:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='4' && uart1_data[3]=='3')
                 {
                     LIMC=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
                     eeprom_write(0x7FFC48,LIMC);
                     delay_ms(5);
                     //send_out("C_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 44:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='4' && uart1_data[3]=='4')
                 {
                     LIMD=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
                     eeprom_write(0x7FFC4C,LIMD);
                     delay_ms(5);
                     //send_out("D_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
         case 45:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='4' && uart1_data[3]=='5')
                 {
                     LIMITE=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
                     eeprom_write(0x7FFC50,LIMITE);
                     delay_ms(5);
                     //send_out("E_OK");
                     NVMADR=0xFF00;
                     NVMADRU=0x007F;
                 }
                 break;
        case 46:
                 //if(uart1_data[0]=='0' && uart1_data[1]=='0' && uart1_data[2]=='4' && uart1_data[3]=='5')
                 {
                     longtostr(totalv1a,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv1a/current_interval.l1acount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv1b,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv1b/current_interval.l1bcount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv1c,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv1c/current_interval.l1ccount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv1d,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv1d/current_interval.l1dcount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv1e,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv1e/current_interval.l1ecount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv1x,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv1x/current_interval.l1xcount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv2a,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv2a/current_interval.l2acount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv2b,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv2b/current_interval.l2bcount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv2c,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv2c/current_interval.l2ccount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv2d,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv2d/current_interval.l2dcount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv2e,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv2e/current_interval.l2ecount),debug_txt);
                     UART1_Write_Text(debug_txt);
                     UART1_Write(13);
                     UART1_Write(10);
                     longtostr(totalv2x,debug_txt);
                     UART1_Write_Text(debug_txt);
                     bytetostr((unsigned short)(totalv2x/current_interval.l2xcount),debug_txt);
                     UART1_Write_Text(debug_txt);
                 }
                 break;
         case 88:
                 send_out("Loops: ");
                 UART1_Write(loop[0]+48);
                 UART1_Write(loop[1]+48);
                 UART1_Write(loop[2]+48);
                 UART1_Write(loop[3]+48);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("IS H Device?: ");
                 UART1_Write(AUTCAL+48);
                 UART1_Write(13);
                 UART1_Write(10);

                 send_out("X: ");
                 inttostr(LIMX,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("A: ");
                 inttostr(LIMA,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("B: ");
                 inttostr(LIMB,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("C: ");
                 inttostr(LIMC,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("D: ");
                 inttostr(LIMD,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("E: ");
                 inttostr(LIMITE,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("Margin: ");
                 inttostr(MARGINTOP,tmp7);
                 UART1_Write_Text(tmp7);
                 inttostr(MARGINBOT,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("APN: ");
                 inttostr(apndata,tmp7);
                 UART1_Write_Text(tmp7);
                 //inttostr(vbatcons,tmp7);
                 //UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("LoopLen: ");
                 inttostr(loop_distance,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("LoopWdt: ");
                 inttostr(loop_width,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("Speed: ");
                 inttostr(DSPEED1,tmp7);
                 UART1_Write_Text(tmp7);
                 inttostr(NSPEED1,tmp7);
                 UART1_Write_Text(tmp7);
                 inttostr(DSPEED2,tmp7);
                 UART1_Write_Text(tmp7);
                 inttostr(NSPEED2,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);

                 send_out("Err: ");
                 inttostr(error_byte,tmp7);
                 UART1_Write_Text(tmp7);
                 inttostr(error_byte_last,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 // (0:Solar, 1:Night Power, 2:Backup, 3:No Battery)
                 send_out("Power: ");
                 inttostr(power_type,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("Name: ");
                 UART1_Write_Text(location_name);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("SMS: ");
                 UART1_Write_Text(sms_number_1);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out("SRV: ");
                 inttostr(ip1,tmp7);

                 UART1_Write_Text(tmp7);
                 send_out(".");
                 inttostr(ip2,tmp7);
                 UART1_Write_Text(tmp7);
                 send_out(".");
                 inttostr(ip3,tmp7);
                 UART1_Write_Text(tmp7);
                 send_out(".");
                 inttostr(ip4,tmp7);
                 UART1_Write_Text(tmp7);
                 send_out(":");
                 inttostr(port,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);
                 /*bytetostr(gsm_ready,tmp7);
                 UART1_Write_Text(tmp7);
                 UART1_Write(13);
                 UART1_Write(10);*/
                 send_out(system_model);
                 UART1_Write(13);
                 UART1_Write(10);
                 send_out(version);
                 UART1_Write(13);
                 UART1_Write(10);
                 //send_out("By Ali Jalilvand");
                 send_out("By Ali Jalilvand");

                 break;

         default : UART1_Write_Text(datetimesec);
     }
      UART1_Write(13); UART1_Write(10); send_out("OK"); UART1_Write(13); UART1_Write(10);
}
void clear_uart1()
{
     //unsigned short clear_uart1_cnt;
     for(clear_uart1_cnt=0;clear_uart1_cnt<49;clear_uart1_cnt++)
     {
         uart1_data[clear_uart1_cnt]=0;
     }
     uart1_data_pointer=0;
     uart1_data_received=0;
     U1STAbits.OERR=0;
}

void clear_uart2()
{
     //short clear_uart2_cnt;
     for(clear_uart2_cnt=0;clear_uart2_cnt<49;clear_uart2_cnt++)
     {
         uart2_data[clear_uart2_cnt]=0;
     }
     uart2_data_pointer=0;
     U2STAbits.OERR=0;
}

void set_error(unsigned int errb)
{
    error_byte=error_byte|errb;
    //send_sms=6;
}
void reset_error(unsigned int errb)
{
    error_byte=error_byte&(~errb);
    //send_sms=6;
}
char is_error(unsigned int errb)
{
    if((error_byte&errb)==0) return(0);
    else  return(1);
}