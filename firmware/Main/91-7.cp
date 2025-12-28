#line 1 "C:/Users/Admin/Desktop/RATC-B4AJ11/Main/91-7.c"
#line 1 "c:/users/admin/desktop/ratc-b4aj11/main/variables.h"
#line 20 "c:/users/admin/desktop/ratc-b4aj11/main/variables.h"
void set_error(unsigned int errb);
void reset_error(unsigned int errb);
const char
 system_id[]="10001704",
 gsm_cipshut[] = "T+CIPSHUT",
 gsm_cstt[3][100] = {"AT+CSTT=\"mtnirancell\",\"\",\"\"","AT+CSTT=\"mcinet\",\"\",\"\""},
 gsm_ciicr[] = "AT+CIICR",
 gsm_cifsr[] = "AT+CIFSR",
 gsm_cipstart[] = "AT+CIPSTART=\"TCP\",\"",
 gsm_cipsend[] = "T+CIPSEND=",
 gsm_ata[] = "ATA",
 gsm_ate0[] = "ATE0&W";
sbit status at LATE4_bit;
sbit onloop0 at LATE0_bit;
sbit onloop1 at LATE1_bit;
sbit onloop2 at LATE2_bit;
sbit onloop3 at LATE3_bit;
sbit rtc at LATF0_bit;
sbit mmc at LATF1_bit;
sbit modem_pwr at LATB2_bit;
sbit mmc_error at LATB5_bit;
sbit charge_control at LATB8_bit;
sbit mdmstat at RB6_bit;
sbit pwrkey at LATB7_bit;
sbit connection_state at LATE5_bit;
sbit Mmc_Chip_Select at LATF1_bit;
sbit Mmc_Chip_Select_Direction at TRISF1_bit;

short
 loop_error_tmp,
 memory_error_sent ,
 memory_ok_sent ,
 debug ,
 spi_busy ,
 mmc_int_send ,
 mmc_vbv_send ,
 timer_1_sec ,
 docal ,
 dis_int ,
 debug_gsm ,
 sending_ready ,
 sending_ready_i ,
 current_loop ,
 tmpcnt ,
 onloop[4] ,
 Line_Dir[2] ,
 timexen[2] ,
 fileHandle ,
 forth ,
 gprs_send ,
 gprs_state=0 ,
 gprs_timer=0 ,
 gprs_end_timer=0 ,
 uart1_data_pointer=0 ,
 uart2_data_pointer=0 ,

 line1step ,
 line2step ,
 statu ,
 uart2_data_received ,
 uart2_data_received2 ,
 gprs_timer_en ,
 uart1_data_received ,
 last_temp1=0 ,
 rtc_read_cnt ;
unsigned short
 cal_timer[4] ,

 foundd ,
 wspeed ,
 wgrab ,
 wheadway ,
 sim_reset ,
 sim_reset_step ,
 sim_reset_timer ,
 cal_class0 ,
 cal_class1 ,
 cal_k ,
 longk ,
 clear_uart1_cnt ,
 clear_uart2_cnt ,
 gsm_ready ;
char
 tmp4[7] ,
 err_cnt ,
 memory_error ,
 err_cnt2 ,
 sms_step ,
 send_sms ,
 debug_txt[12] ,
 uart1_data[50] ,
 uart2_data[50] ,
 tsdata[34]= "12.06.07,11:54:23.2,1,A,136,100  "
 ,
 datetimesec[22]="2000.00.00-00:00:00.0"
 ,
 tmp3[4] ,
 tmp7[7] ,
 udata ,
 udata2 ,
 dataname[11]="1212120000"
 ,
 location_name[33]="________________________________"
 ,
 sms_number_1[12]="09123701598"
 ,
 interval_data[512] = "0000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000  "
 ;
int
 function_code ,
 jj ,
 port ,
 u2func ,
 LIMX ,
 LIMA ,
 LIMB ,
 LIMC ,
 LIMD ,
 PRVAL ,
 DSPEED1 ,
 NSPEED1 ,
 DSPEED2 ,
 NSPEED2 ,
 HMM ,
 AUTCAL ,
 mmc_i ,
 power_type ,
 LIMITE ,
 MARGINTOP ,
 MARGINBOT ,
 apndata ,
 ip1 ,
 ip2 ,
 ip3 ,
 ip4 ,
 milisec ,
 how_many_micro = 0 ,
 loop[4] ,
 serial_vbv ,
 loop_distance ,
 loop_width ,
 dev[4] ,
 current_gap[2] ;
unsigned int
 error_byte=0b0000000000000000
 ,
 cal_interval_cnt ,
 error_byte_last=0b0000000000000000
 ,
 calpointer[4] ;
long
 vbat ,
 solar ,
 l1occ ,

 T2S ,
 l2occ ,
 T1[2] ,
 T2[2] ,
 T3[2] ,
 timex[2] ;
unsigned long
 freq_mean[4] ,
 capw ,
 capx ,
 capy ,
 capz ,
 freq_sum_cal ,
 calsum[4] ,
 caldata[4] ,
 filesize ,
 totalv1a ,
 totalv1b ,
 totalv1c ,
 totalv1d ,
 totalv1e ,
 totalv1x ,
 totalv2a ,
 totalv2b ,
 totalv2c ,
 totalv2d ,
 totalv2e ,
 current_sector ,
 totalv2x ;

float

 freq_help ;
double
 vehicle_speed0 ,
 vehicle_speed1 ,
 vehicle_speed ,
 vehicle_lenght ;


struct vehicle {
 short dir;
 unsigned short speed;
 char vclass;
} lastvehicle ;
struct time {
 char
 null,
 second,
 minute,
 hour,
 day,
 month,
 year;
} current_time ;

struct interval_data {
 int l1acount;
 unsigned short l1avavg;
 int l1aspeed;
 int l1agrab;
 int l1aheadway;

 int l1bcount;
 unsigned short l1bvavg;
 int l1bspeed;
 int l1bgrab;
 int l1bheadway;

 int l1ccount;
 unsigned short l1cvavg;
 int l1cspeed;
 int l1cgrab;
 int l1cheadway;

 int l1dcount;
 unsigned short l1dvavg;
 int l1dspeed;
 int l1dgrab;
 int l1dheadway;

 int l1ecount;
 unsigned short l1evavg;
 int l1espeed;
 int l1egrab;
 int l1eheadway;

 int l1xcount;
 unsigned short l1xvavg;
 int l1xspeed;
 int l1xgrab;
 int l1xheadway;

 int l1occ;

 int l2acount;
 unsigned short l2avavg;
 int l2aspeed;
 int l2agrab;
 int l2aheadway;

 int l2bcount;
 unsigned short l2bvavg;
 int l2bspeed;
 int l2bgrab;
 int l2bheadway;

 int l2ccount;
 unsigned short l2cvavg;
 unsigned short l2cvavgnew;
 int l2cspeed;
 int l2cgrab;
 int l2cheadway;

 int l2dcount;
 unsigned short l2dvavg;
 int l2dspeed;
 int l2dgrab;
 int l2dheadway;

 int l2ecount;
 unsigned short l2evavg;
 int l2espeed;
 int l2egrab;
 int l2eheadway;

 int l2xcount;
 unsigned short l2xvavg;
 int l2xspeed;
 int l2xgrab;
 int l2xheadway;

 int l2occ;

} current_interval ;




void cal();
void measure_loops();
void clear_uart1();

void clear_uart2();
void reset_interval_data();

void cal_class(unsigned short lane);
#line 1 "c:/users/admin/desktop/ratc-b4aj11/main/ds1305_lib.h"

void rtc_read()
{
 shorttostr(current_time.year,tmp3);
 datetimesec[2]=tmp3[2];
 datetimesec[3]=tmp3[3];
 shorttostr(current_time.month,tmp3);
 datetimesec[5]=tmp3[2];
 datetimesec[6]=tmp3[3];
 shorttostr(current_time.day,tmp3);
 datetimesec[8]=tmp3[2];
 datetimesec[9]=tmp3[3];
 shorttostr(current_time.hour,tmp3);
 datetimesec[11]=tmp3[2];
 datetimesec[12]=tmp3[3];
 shorttostr(current_time.minute,tmp3);
 datetimesec[14]=tmp3[2];
 datetimesec[15]=tmp3[3];
 shorttostr(current_time.second,tmp3);
 datetimesec[17]=tmp3[2];
 datetimesec[18]=tmp3[3];
 datetimesec[20]=(char)((milisec/100)+48);
 for(rtc_read_cnt=0;rtc_read_cnt<strlen(datetimesec);rtc_read_cnt++) if(datetimesec[rtc_read_cnt]==' ') datetimesec[rtc_read_cnt]='0';
}
void rtc_init()
{
 current_time.second=0;
 current_time.minute=0;
 current_time.hour=0;
 current_time.day=1;
 current_time.month=1;
 current_time.year=0;






}
void rtc_write(char input)
{



 {

 rtc=1;
 if(input==1)
 {
 current_time.second=(uart1_data[15]-48)+(uart1_data[14]-48)*10;
 current_time.minute=(uart1_data[13]-48)+(uart1_data[12]-48)*10;
 current_time.hour=(uart1_data[11]-48)+(uart1_data[10]-48)*10;
 current_time.day=(uart1_data[9]-48)+(uart1_data[8]-48)*10;
 current_time.month=(uart1_data[7]-48)+(uart1_data[6]-48)*10;
 current_time.year=(uart1_data[5]-48)+(uart1_data[4]-48)*10;
 }
 else
 {
 current_time.second=(uart2_data[15]-48)+(uart2_data[14]-48)*10;
 current_time.minute=(uart2_data[13]-48)+(uart2_data[12]-48)*10;
 current_time.hour=(uart2_data[11]-48)+(uart2_data[10]-48)*10;
 current_time.day=(uart2_data[9]-48)+(uart2_data[8]-48)*10;
 current_time.month=(uart2_data[7]-48)+(uart2_data[6]-48)*10;
 current_time.year=(uart2_data[5]-48)+(uart2_data[4]-48)*10;
 }
#line 88 "c:/users/admin/desktop/ratc-b4aj11/main/ds1305_lib.h"
 rtc=0;
 }
}
#line 1 "c:/users/admin/desktop/ratc-b4aj11/main/gprs.h"
void send_atc(const char *s)
{
 while(*s)
 {
 if(*s!=10 && *s!=13 && *s!=' ')
 {
 if(debug_gsm) UART1_Write(*s);
 UART2_Write(*s);
 delay_us(15);
 }
 s++;


 }
}
void send_out(const char *s)
{
 while(*s)
 {
 if(*s!=10 && *s!=13)
 {

 UART1_Write(*s);


 delay_us(15);
 }
 s++;


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
#line 1 "c:/users/admin/desktop/ratc-b4aj11/main/mmc.h"
void spifat_init()
{
 SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64,_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_IDLE_2_ACTIVE);
 if(0==Mmc_Init())
 {
 memory_error=0;
 }
 else
 {
 delay_ms(1);
 if(0==Mmc_Init())
 {
 memory_error=0;
 }
 else
 {
 memory_error=1;
 }
 SPI1_read(0);
 SPI1_read(0);
 }

 SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_4,_SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
 SPI1_Write(0xFF);
}
#line 1 "c:/users/admin/desktop/ratc-b4aj11/main/interval.h"
void reset_interval_data()
{
 for(jj=0;jj<262;jj++) interval_data[jj]='0';
 for(jj=0;jj<8;jj++) interval_data[jj]=system_id[jj];
 interval_data[262]=13;
 interval_data[263]=10;
 interval_data[264]=0;
}
void reset_interval()
{
 current_interval.l1acount=0;
 current_interval.l1avavg=0;
 current_interval.l1aspeed=0;
 current_interval.l1agrab=0;
 current_interval.l1aheadway=0;

 current_interval.l1bcount=0;
 current_interval.l1bvavg=0;
 current_interval.l1bspeed=0;
 current_interval.l1bgrab=0;
 current_interval.l1bheadway=0;

 current_interval.l1ccount=0;
 current_interval.l1cvavg=0;
 current_interval.l1cspeed=0;
 current_interval.l1cgrab=0;
 current_interval.l1cheadway=0;

 current_interval.l1dcount=0;
 current_interval.l1dvavg=0;
 current_interval.l1dspeed=0;
 current_interval.l1dgrab=0;
 current_interval.l1dheadway=0;

 current_interval.l1ecount=0;
 current_interval.l1evavg=0;
 current_interval.l1espeed=0;
 current_interval.l1egrab=0;
 current_interval.l1eheadway=0;

 current_interval.l1xcount=0;
 current_interval.l1xvavg=0;
 current_interval.l1xspeed=0;
 current_interval.l1xgrab=0;
 current_interval.l1xheadway=0;

 current_interval.l2acount=0;
 current_interval.l2avavg=0;
 current_interval.l2aspeed=0;
 current_interval.l2agrab=0;
 current_interval.l2aheadway=0;

 current_interval.l2bcount=0;
 current_interval.l2bvavg=0;
 current_interval.l2bspeed=0;
 current_interval.l2bgrab=0;
 current_interval.l2bheadway=0;

 current_interval.l2ccount=0;
 current_interval.l2cvavg=0;
 current_interval.l2cvavgnew=0;
 current_interval.l2cspeed=0;
 current_interval.l2cgrab=0;
 current_interval.l2cheadway=0;

 current_interval.l2dcount=0;
 current_interval.l2dvavg=0;
 current_interval.l2dspeed=0;
 current_interval.l2dgrab=0;
 current_interval.l2dheadway=0;

 current_interval.l2ecount=0;
 current_interval.l2evavg=0;
 current_interval.l2espeed=0;
 current_interval.l2egrab=0;
 current_interval.l2eheadway=0;

 current_interval.l2xcount=0;
 current_interval.l2xvavg=0;
 current_interval.l2xspeed=0;
 current_interval.l2xgrab=0;
 current_interval.l2xheadway=0;


 totalv1a=0;
 totalv1b=0;
 totalv1c=0;
 totalv1d=0;
 totalv1e=0;
 totalv1x=0;
 totalv2a=0;
 totalv2b=0;
 totalv2c=0;

 totalv2d=0;
 totalv2e=0;
 totalv2x=0;

 l1occ=0;
 l2occ=0;

}
void cal_interval()
{
 reset_interval_data();

 if(current_interval.l1acount>0) current_interval.l1avavg=(unsigned short)(totalv1a/current_interval.l1acount);
 else current_interval.l1avavg=0;

 if(current_interval.l1bcount>0) current_interval.l1bvavg=(unsigned short)(totalv1b/current_interval.l1bcount);
 else current_interval.l1bvavg=0;

 if(current_interval.l1ccount>0) current_interval.l1cvavg=(unsigned short)(totalv1c/current_interval.l1ccount);
 else current_interval.l1cvavg=0;

 if(current_interval.l1dcount>0) current_interval.l1dvavg=(unsigned short)(totalv1d/current_interval.l1dcount);
 else current_interval.l1dvavg=0;

 if(current_interval.l1ecount>0) current_interval.l1evavg=(unsigned short)(totalv1e/current_interval.l1ecount);
 else current_interval.l1evavg=0;

 if(current_interval.l1xcount>0) current_interval.l1xvavg=(unsigned short)(totalv1x/current_interval.l1xcount);
 else current_interval.l1xvavg=0;

 if(current_interval.l2acount>0) current_interval.l2avavg=(unsigned short)(totalv2a/current_interval.l2acount);
 else current_interval.l2avavg=0;

 if(current_interval.l2bcount>0) current_interval.l2bvavg=(unsigned short)(totalv2b/current_interval.l2bcount);
 else current_interval.l2bvavg=0;

 if(current_interval.l2ccount>0) current_interval.l2cvavg=(unsigned short)(totalv2c/(unsigned long)(current_interval.l2ccount));
 else current_interval.l2cvavg=0;

 if(current_interval.l2dcount>0) current_interval.l2dvavg=(unsigned short)(totalv2d/current_interval.l2dcount);
 else current_interval.l2dvavg=0;

 if(current_interval.l2ecount>0) current_interval.l2evavg=(unsigned short)(totalv2e/current_interval.l2ecount);
 else current_interval.l2evavg=0;

 if(current_interval.l2xcount>0) current_interval.l2xvavg=(unsigned short)(totalv2x/current_interval.l2xcount);
 else current_interval.l2xvavg=0;

 bytetostr(current_time.year,tmp3);
 interval_data[8]=tmp3[1];
 interval_data[9]=tmp3[2];
 bytetostr(current_time.month,tmp3);
 interval_data[10]=tmp3[1];
 interval_data[11]=tmp3[2];
 bytetostr(current_time.day,tmp3);
 interval_data[12]=tmp3[1];
 interval_data[13]=tmp3[2];
 bytetostr(current_time.hour,tmp3);
 interval_data[14]=tmp3[1];
 interval_data[15]=tmp3[2];
 bytetostr(current_time.minute,tmp3);
 interval_data[16]=tmp3[1];
 interval_data[17]=tmp3[2];

 inttostr(current_interval.l1acount,tmp4);
 interval_data[18]=tmp4[2];
 interval_data[19]=tmp4[3];
 interval_data[20]=tmp4[4];
 interval_data[21]=tmp4[5];

 bytetostr(current_interval.l1avavg,tmp3);
 interval_data[22]=tmp3[0];
 interval_data[23]=tmp3[1];
 interval_data[24]=tmp3[2];

 inttostr(current_interval.l1aspeed,tmp4);
 interval_data[25]=tmp4[2];
 interval_data[26]=tmp4[3];
 interval_data[27]=tmp4[4];
 interval_data[28]=tmp4[5];

 inttostr(current_interval.l1agrab,tmp4);
 interval_data[29]=tmp4[2];
 interval_data[30]=tmp4[3];
 interval_data[31]=tmp4[4];
 interval_data[32]=tmp4[5];

 inttostr(current_interval.l1aheadway,tmp4);
 interval_data[33]=tmp4[2];
 interval_data[34]=tmp4[3];
 interval_data[35]=tmp4[4];
 interval_data[36]=tmp4[5];

 inttostr(current_interval.l1bcount,tmp4);
 interval_data[37]=tmp4[2];
 interval_data[38]=tmp4[3];
 interval_data[39]=tmp4[4];
 interval_data[40]=tmp4[5];

 bytetostr(current_interval.l1bvavg,tmp3);
 interval_data[41]=tmp3[0];
 interval_data[42]=tmp3[1];
 interval_data[43]=tmp3[2];

 inttostr(current_interval.l1bspeed,tmp4);
 interval_data[44]=tmp4[2];
 interval_data[45]=tmp4[3];
 interval_data[46]=tmp4[4];
 interval_data[47]=tmp4[5];

 inttostr(current_interval.l1bgrab,tmp4);
 interval_data[48]=tmp4[2];
 interval_data[49]=tmp4[3];
 interval_data[50]=tmp4[4];
 interval_data[51]=tmp4[5];

 inttostr(current_interval.l1bheadway,tmp4);
 interval_data[52]=tmp4[2];
 interval_data[53]=tmp4[3];
 interval_data[54]=tmp4[4];
 interval_data[55]=tmp4[5];

 inttostr(current_interval.l1ccount,tmp4);
 interval_data[56]=tmp4[2];
 interval_data[57]=tmp4[3];
 interval_data[58]=tmp4[4];
 interval_data[59]=tmp4[5];

 bytetostr(current_interval.l1cvavg,tmp3);
 interval_data[60]=tmp3[0];
 interval_data[61]=tmp3[1];
 interval_data[62]=tmp3[2];

 inttostr(current_interval.l1cspeed,tmp4);
 interval_data[63]=tmp4[2];
 interval_data[64]=tmp4[3];
 interval_data[65]=tmp4[4];
 interval_data[66]=tmp4[5];

 inttostr(current_interval.l1cgrab,tmp4);
 interval_data[67]=tmp4[2];
 interval_data[68]=tmp4[3];
 interval_data[69]=tmp4[4];
 interval_data[70]=tmp4[5];

 inttostr(current_interval.l1cheadway,tmp4);
 interval_data[71]=tmp4[2];
 interval_data[72]=tmp4[3];
 interval_data[73]=tmp4[4];
 interval_data[74]=tmp4[5];

 inttostr(current_interval.l1dcount,tmp4);
 interval_data[75]=tmp4[2];
 interval_data[76]=tmp4[3];
 interval_data[77]=tmp4[4];
 interval_data[78]=tmp4[5];

 bytetostr(current_interval.l1dvavg,tmp3);
 interval_data[79]=tmp3[0];
 interval_data[80]=tmp3[1];
 interval_data[81]=tmp3[2];

 inttostr(current_interval.l1dspeed,tmp4);
 interval_data[82]=tmp4[2];
 interval_data[83]=tmp4[3];
 interval_data[84]=tmp4[4];
 interval_data[85]=tmp4[5];

 inttostr(current_interval.l1dgrab,tmp4);
 interval_data[86]=tmp4[2];
 interval_data[87]=tmp4[3];
 interval_data[88]=tmp4[4];
 interval_data[89]=tmp4[5];

 inttostr(current_interval.l1dheadway,tmp4);
 interval_data[90]=tmp4[2];
 interval_data[91]=tmp4[3];
 interval_data[92]=tmp4[4];
 interval_data[93]=tmp4[5];

 inttostr(current_interval.l1ecount,tmp4);
 interval_data[94]=tmp4[2];
 interval_data[95]=tmp4[3];
 interval_data[96]=tmp4[4];
 interval_data[97]=tmp4[5];

 bytetostr(current_interval.l1evavg,tmp3);
 interval_data[98]=tmp3[0];
 interval_data[99]=tmp3[1];
 interval_data[100]=tmp3[2];

 inttostr(current_interval.l1espeed,tmp4);
 interval_data[101]=tmp4[2];
 interval_data[102]=tmp4[3];
 interval_data[103]=tmp4[4];
 interval_data[104]=tmp4[5];

 inttostr(current_interval.l1egrab,tmp4);
 interval_data[105]=tmp4[2];
 interval_data[106]=tmp4[3];
 interval_data[107]=tmp4[4];
 interval_data[108]=tmp4[5];

 inttostr(current_interval.l1eheadway,tmp4);
 interval_data[109]=tmp4[2];
 interval_data[110]=tmp4[3];
 interval_data[111]=tmp4[4];
 interval_data[112]=tmp4[5];

 inttostr(current_interval.l1xcount,tmp4);
 interval_data[113]=tmp4[2];
 interval_data[114]=tmp4[3];
 interval_data[115]=tmp4[4];
 interval_data[116]=tmp4[5];

 bytetostr(current_interval.l1xvavg,tmp3);
 interval_data[117]=tmp3[0];
 interval_data[118]=tmp3[1];
 interval_data[119]=tmp3[2];

 inttostr(current_interval.l1xspeed,tmp4);
 interval_data[120]=tmp4[2];
 interval_data[121]=tmp4[3];
 interval_data[122]=tmp4[4];
 interval_data[123]=tmp4[5];

 inttostr(current_interval.l1xgrab,tmp4);
 interval_data[124]=tmp4[2];
 interval_data[125]=tmp4[3];
 interval_data[126]=tmp4[4];
 interval_data[127]=tmp4[5];

 inttostr(current_interval.l1xheadway,tmp4);
 interval_data[128]=tmp4[2];
 interval_data[129]=tmp4[3];
 interval_data[130]=tmp4[4];
 interval_data[131]=tmp4[5];

 inttostr((int)(l1occ/( 5 *2*600)),debug_txt);
 interval_data[132]=debug_txt[3];
 interval_data[133]=debug_txt[4];
 interval_data[134]=debug_txt[5];






 inttostr(current_interval.l2acount,tmp4);
 interval_data[135]=tmp4[2];
 interval_data[136]=tmp4[3];
 interval_data[137]=tmp4[4];
 interval_data[138]=tmp4[5];

 bytetostr(current_interval.l2avavg,tmp3);
 interval_data[139]=tmp3[0];
 interval_data[140]=tmp3[1];
 interval_data[141]=tmp3[2];

 inttostr(current_interval.l2aspeed,tmp4);
 interval_data[142]=tmp4[2];
 interval_data[143]=tmp4[3];
 interval_data[144]=tmp4[4];
 interval_data[145]=tmp4[5];

 inttostr(current_interval.l2agrab,tmp4);
 interval_data[146]=tmp4[2];
 interval_data[147]=tmp4[3];
 interval_data[148]=tmp4[4];
 interval_data[149]=tmp4[5];

 inttostr(current_interval.l2aheadway,tmp4);
 interval_data[150]=tmp4[2];
 interval_data[151]=tmp4[3];
 interval_data[152]=tmp4[4];
 interval_data[153]=tmp4[5];

 inttostr(current_interval.l2bcount,tmp4);
 interval_data[154]=tmp4[2];
 interval_data[155]=tmp4[3];
 interval_data[156]=tmp4[4];
 interval_data[157]=tmp4[5];

 bytetostr(current_interval.l2bvavg,tmp3);
 interval_data[158]=tmp3[0];
 interval_data[159]=tmp3[1];
 interval_data[160]=tmp3[2];

 inttostr(current_interval.l2bspeed,tmp4);
 interval_data[161]=tmp4[2];
 interval_data[162]=tmp4[3];
 interval_data[163]=tmp4[4];
 interval_data[164]=tmp4[5];

 inttostr(current_interval.l2bgrab,tmp4);
 interval_data[165]=tmp4[2];
 interval_data[166]=tmp4[3];
 interval_data[167]=tmp4[4];
 interval_data[168]=tmp4[5];

 inttostr(current_interval.l2bheadway,tmp4);
 interval_data[169]=tmp4[2];
 interval_data[170]=tmp4[3];
 interval_data[171]=tmp4[4];
 interval_data[172]=tmp4[5];

 inttostr(current_interval.l2ccount,tmp4);
 interval_data[173]=tmp4[2];
 interval_data[174]=tmp4[3];
 interval_data[175]=tmp4[4];
 interval_data[176]=tmp4[5];

 bytetostr(current_interval.l2cvavg,tmp3);
 interval_data[177]=tmp3[0];
 interval_data[178]=tmp3[1];
 interval_data[179]=tmp3[2];

 inttostr(current_interval.l2cspeed,tmp4);
 interval_data[180]=tmp4[2];
 interval_data[181]=tmp4[3];
 interval_data[182]=tmp4[4];
 interval_data[183]=tmp4[5];

 inttostr(current_interval.l2cgrab,tmp4);
 interval_data[184]=tmp4[2];
 interval_data[185]=tmp4[3];
 interval_data[186]=tmp4[4];
 interval_data[187]=tmp4[5];

 inttostr(current_interval.l2cheadway,tmp4);
 interval_data[188]=tmp4[2];
 interval_data[189]=tmp4[3];
 interval_data[190]=tmp4[4];
 interval_data[191]=tmp4[5];

 inttostr(current_interval.l2dcount,tmp4);
 interval_data[192]=tmp4[2];
 interval_data[193]=tmp4[3];
 interval_data[194]=tmp4[4];
 interval_data[195]=tmp4[5];

 bytetostr(current_interval.l2dvavg,tmp3);
 interval_data[196]=tmp3[0];
 interval_data[197]=tmp3[1];
 interval_data[198]=tmp3[2];

 inttostr(current_interval.l2dspeed,tmp4);
 interval_data[199]=tmp4[2];
 interval_data[200]=tmp4[3];
 interval_data[201]=tmp4[4];
 interval_data[202]=tmp4[5];

 inttostr(current_interval.l2dgrab,tmp4);
 interval_data[203]=tmp4[2];
 interval_data[204]=tmp4[3];
 interval_data[205]=tmp4[4];
 interval_data[206]=tmp4[5];

 inttostr(current_interval.l2dheadway,tmp4);
 interval_data[207]=tmp4[2];
 interval_data[208]=tmp4[3];
 interval_data[209]=tmp4[4];
 interval_data[210]=tmp4[5];

 inttostr(current_interval.l2ecount,tmp4);
 interval_data[211]=tmp4[2];
 interval_data[212]=tmp4[3];
 interval_data[213]=tmp4[4];
 interval_data[214]=tmp4[5];

 bytetostr(current_interval.l2evavg,tmp3);
 interval_data[215]=tmp3[0];
 interval_data[216]=tmp3[1];
 interval_data[217]=tmp3[2];

 inttostr(current_interval.l2espeed,tmp4);
 interval_data[218]=tmp4[2];
 interval_data[219]=tmp4[3];
 interval_data[220]=tmp4[4];
 interval_data[221]=tmp4[5];

 inttostr(current_interval.l2egrab,tmp4);
 interval_data[222]=tmp4[2];
 interval_data[223]=tmp4[3];
 interval_data[224]=tmp4[4];
 interval_data[225]=tmp4[5];

 inttostr(current_interval.l2eheadway,tmp4);
 interval_data[226]=tmp4[2];
 interval_data[227]=tmp4[3];
 interval_data[228]=tmp4[4];
 interval_data[229]=tmp4[5];

 inttostr(current_interval.l2xcount,tmp4);
 interval_data[230]=tmp4[2];
 interval_data[231]=tmp4[3];
 interval_data[232]=tmp4[4];
 interval_data[233]=tmp4[5];

 bytetostr(current_interval.l2xvavg,tmp3);
 interval_data[234]=tmp3[0];
 interval_data[235]=tmp3[1];
 interval_data[236]=tmp3[2];

 inttostr(current_interval.l2xspeed,tmp4);
 interval_data[237]=tmp4[2];
 interval_data[238]=tmp4[3];
 interval_data[239]=tmp4[4];
 interval_data[240]=tmp4[5];

 inttostr(current_interval.l2xgrab,tmp4);
 interval_data[241]=tmp4[2];
 interval_data[242]=tmp4[3];
 interval_data[243]=tmp4[4];
 interval_data[244]=tmp4[5];

 inttostr(current_interval.l2xheadway,tmp4);
 interval_data[245]=tmp4[2];
 interval_data[246]=tmp4[3];
 interval_data[247]=tmp4[4];
 interval_data[248]=tmp4[5];


 inttostr((int)(l2occ/( 5 *2*600)),debug_txt);
 interval_data[249]=debug_txt[3];
 interval_data[250]=debug_txt[4];
 interval_data[251]=debug_txt[5];


 inttostr((int)(vbat*0.388509+7),debug_txt);
 interval_data[252]=debug_txt[3];
 interval_data[253]=debug_txt[4];
 interval_data[254]=debug_txt[5];

 if(solar<50)
 inttostr(0,debug_txt);
 else
 inttostr((int)(solar*0.388509),debug_txt);
 interval_data[255]=debug_txt[3];
 interval_data[256]=debug_txt[4];
 interval_data[257]=debug_txt[5];


 inttostr(error_byte,debug_txt);
 interval_data[258]=debug_txt[2];
 interval_data[259]=debug_txt[3];
 interval_data[260]=debug_txt[4];
 interval_data[261]=debug_txt[5];



 reset_interval();

 for(cal_interval_cnt=0;cal_interval_cnt<262;cal_interval_cnt++) if(interval_data[cal_interval_cnt]==' ') interval_data[cal_interval_cnt]='0';
}
#line 1 "c:/users/admin/desktop/ratc-b4aj11/main/capture_int_lib.h"
void tris_init()
{
 TRISB.RB3=0;
 TRISB.RB5=0;
 mmc_error=0;
 TRISB.RB6=1;
 TRISB.RB7=0;
 LATB.RB7=0;
 TRISB.RB8=0;


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
#line 1 "c:/users/admin/desktop/ratc-b4aj11/main/uart_int_lib.h"
void uart_init()
{
 UART1_init(115200);
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
#line 80 "c:/users/admin/desktop/ratc-b4aj11/main/uart_int_lib.h"
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

 UART1_Write(13); UART1_Write(10);
 switch (function_code)
 {
 case 0:
 send_out(system_id);

 UART1_Write(',');
 UART1_Write_Text(datetimesec);
 UART1_Write(',');
 send_out( "RATCX1" );
 UART1_Write(',');
 send_out( "HW:B-06,SW:JA11" );
 UART1_Write(',');
 send_out("READY");
 break;
 case 2:

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

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 197:

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

 {
 AUTCAL=uart1_data[4]-48;
 eeprom_write(0x7FFCCC,AUTCAL);
 delay_ms(5);
 NVMADR=0xFF00;
 NVMADRU=0x007F;

 }
 break;
 case 4:

 {
 distance_write();

 }
 break;
 case 5:

 {
 looplen_write();

 }
 break;
 case 6:

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


 debug=!debug;
 break;

 case 10:

 {
 margin_write();

 }
 break;
 case 11:

 {
 HMM=(uart1_data[4]-48)*10+(uart1_data[5]-48);
 if(HMM<10) HMM = 10;
 eeprom_write(0x7FFCC8,HMM);
 delay_ms(5);

 }
 break;
 case 12:

 {
 rtc_write(1);

 }
 break;
 case 13:


  asm{RESET} ;
 break;

 case 17:

 sim900_restart();
 break;
 case 18:

 UART2_Write('A');
 delay_ms(50);
 send_atc("T+CSQ");

 clear_UART2();
 debug_gsm=1;
 UART2_Write(13);
 delay_ms(100);
 debug_gsm=0;



 break;
 case 19:

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

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 21:

 {
 power_type=uart1_data[4]-48;
 eeprom_write(0x7FFC58,power_type);
 delay_ms(5);

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 22:

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

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 23:

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

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 25:

 {
 debug_gsm=~debug_gsm;
 }
 break;
 case 32:

 {
 apndata=uart1_data[4]-48;
 eeprom_write(0x7FFC20,apndata);
 delay_ms(5);

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

 {
 LIMX=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
 eeprom_write(0x7FFC3C,LIMX);
 delay_ms(5);

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 41:

 {
 LIMA=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
 eeprom_write(0x7FFC40,LIMA);
 delay_ms(5);

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 42:

 {
 LIMB=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
 eeprom_write(0x7FFC44,LIMB);
 delay_ms(5);

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 43:

 {
 LIMC=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
 eeprom_write(0x7FFC48,LIMC);
 delay_ms(5);

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 44:

 {
 LIMD=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
 eeprom_write(0x7FFC4C,LIMD);
 delay_ms(5);

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 45:

 {
 LIMITE=(uart1_data[7]-48)+(uart1_data[6]-48)*10+(uart1_data[5]-48)*100+(uart1_data[4]-48)*1000;
 eeprom_write(0x7FFC50,LIMITE);
 delay_ms(5);

 NVMADR=0xFF00;
 NVMADRU=0x007F;
 }
 break;
 case 46:

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
#line 732 "c:/users/admin/desktop/ratc-b4aj11/main/uart_int_lib.h"
 send_out( "RATCX1" );
 UART1_Write(13);
 UART1_Write(10);
 send_out( "HW:B-06,SW:JA11" );
 UART1_Write(13);
 UART1_Write(10);

 send_out("By Ali Jalilvand");

 break;

 default : UART1_Write_Text(datetimesec);
 }
 UART1_Write(13); UART1_Write(10); send_out("OK"); UART1_Write(13); UART1_Write(10);
}
void clear_uart1()
{

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

}
void reset_error(unsigned int errb)
{
 error_byte=error_byte&(~errb);

}
char is_error(unsigned int errb)
{
 if((error_byte&errb)==0) return(0);
 else return(1);
}
#line 1 "c:/users/admin/desktop/ratc-b4aj11/main/classification.h"
void reset_class(unsigned short lane)
{
 if(lane==0)
 {
 onloop0=0;
 onloop1=0;
 line1step=0;
 }
 else
 {
 onloop2=0;
 onloop3=0;
 line2step=0;
 }
 T1[lane]=0;
 T2[lane]=0;
 T3[lane]=0;
 Line_Dir[lane]=0;
 timexen[lane]=0;
 timex[lane]=0;
 wspeed=0;
 wgrab=0;
 wheadway=0;
}
void cal_class(unsigned short lane)
{

 vehicle_speed0=(double)(loop_distance)*1000;
 vehicle_speed1=(double)(loop_distance)*1000;
 vehicle_speed0=vehicle_speed0/((double)(T1[lane]));
 vehicle_speed1=vehicle_speed1/((double)(T3[lane]-T2[lane]));
 vehicle_speed = (vehicle_speed0+vehicle_speed1)/2;
#line 36 "c:/users/admin/desktop/ratc-b4aj11/main/classification.h"
 T2S=(T2[lane]+(T3[lane]-T1[lane]))/2;
 vehicle_lenght=vehicle_speed*(double)(T2S);
 vehicle_lenght/=1000;
 vehicle_lenght-=(double)loop_width;
 lastvehicle.speed=(unsigned short)(floor(0.036*vehicle_speed));
 lastvehicle.dir=Line_Dir[lane];

 tsdata[0]=datetimesec[2];
 tsdata[1]=datetimesec[3];
 tsdata[3]=datetimesec[5];
 tsdata[4]=datetimesec[6];
 tsdata[6]=datetimesec[8];
 tsdata[7]=datetimesec[9];
 tsdata[9]=datetimesec[11];
 tsdata[10]=datetimesec[12];
 tsdata[12]=datetimesec[14];
 tsdata[13]=datetimesec[15];
 tsdata[15]=datetimesec[17];
 tsdata[16]=datetimesec[18];
 tsdata[18]=datetimesec[20];
 if(vehicle_lenght<LIMA)
 {
 if(current_time.hour >5 && current_time.hour<21)
 {
 if(lastvehicle.speed > (unsigned short)(DSPEED1)) wspeed=1;
 }
 else
 {
 if(lastvehicle.speed > (unsigned short)(NSPEED1)) wspeed=1;
 }
 }
 else
 {
 if(current_time.hour >5 && current_time.hour<21)
 {
 if(lastvehicle.speed > (unsigned short)(DSPEED2)) wspeed=1;
 }
 else
 {
 if(lastvehicle.speed > (unsigned short)(NSPEED2)) wspeed=1;
 }
 }
 if(lastvehicle.dir!= 12 )
 {
 wgrab=1;
 if(lane==0) lane=1;
 else lane =0;
 }
 if(current_gap[lane]< 2000 )
 {
 wheadway=1;
 }

 if(lane==0)
 {
 if(vehicle_lenght<LIMX)
 {
 lastvehicle.vclass='X';
 current_interval.l1xcount++;
 if(wspeed==1) current_interval.l1xspeed++;
 if(wgrab==1) current_interval.l1xgrab++;
 if(wheadway==1) current_interval.l1xheadway++;
 totalv1x+=lastvehicle.speed;
 }
 else if(vehicle_lenght<LIMA)
 {
 lastvehicle.vclass='A';
 current_interval.l1acount++;
 if(wspeed==1) current_interval.l1aspeed++;
 if(wgrab==1) current_interval.l1agrab++;
 if(wheadway==1) current_interval.l1aheadway++;
 totalv1a+=lastvehicle.speed;
 }
 else if(vehicle_lenght<LIMB)
 {
 lastvehicle.vclass='B';
 current_interval.l1bcount++;
 if(wspeed==1) current_interval.l1bspeed++;
 if(wgrab==1) current_interval.l1bgrab++;
 if(wheadway==1) current_interval.l1bheadway++;
 totalv1b+=lastvehicle.speed;
 }
 else if(vehicle_lenght<LIMC)
 {
 lastvehicle.vclass='C';
 current_interval.l1ccount++;
 if(wspeed==1) current_interval.l1cspeed++;
 if(wgrab==1) current_interval.l1cgrab++;
 if(wheadway==1) current_interval.l1cheadway++;
 totalv1c+=lastvehicle.speed;
 }
 else if(vehicle_lenght<LIMD)
 {
 lastvehicle.vclass='D';
 current_interval.l1dcount++;
 if(wspeed==1) current_interval.l1dspeed++;
 if(wgrab==1) current_interval.l1dgrab++;
 if(wheadway==1) current_interval.l1dheadway++;
 totalv1d+=lastvehicle.speed;
 }
 else if(vehicle_lenght<LIMITE)
 {
 lastvehicle.vclass='E';
 current_interval.l1ecount++;
 if(wspeed==1) current_interval.l1espeed++;
 if(wgrab==1) current_interval.l1egrab++;
 if(wheadway==1) current_interval.l1eheadway++;
 totalv1e+=lastvehicle.speed;
 }
 else
 {
 lastvehicle.vclass='X';
 current_interval.l1xcount++;
 if(wspeed==1) current_interval.l1xspeed++;
 if(wgrab==1) current_interval.l1xgrab++;
 if(wheadway==1) current_interval.l1xheadway++;
 totalv1x+=lastvehicle.speed;
 }
 }
 else if(lane==1)
 {
 if(vehicle_lenght<LIMX)
 {
 lastvehicle.vclass='X';
 current_interval.l2xcount++;
 if(wspeed==1) current_interval.l2xspeed++;
 if(wgrab==1) current_interval.l2xgrab++;
 if(wheadway==1) current_interval.l2xheadway++;
 totalv2x+=lastvehicle.speed;
 }
 else if(vehicle_lenght<LIMA)
 {
 lastvehicle.vclass='A';
 current_interval.l2acount++;
 if(wspeed==1) current_interval.l2aspeed++;
 if(wgrab==1) current_interval.l2agrab++;
 if(wheadway==1) current_interval.l2aheadway++;
 totalv2a+=lastvehicle.speed;
 }
 else if(vehicle_lenght<LIMB)
 {
 lastvehicle.vclass='B';
 current_interval.l2bcount++;
 if(wspeed==1) current_interval.l2bspeed++;
 if(wgrab==1) current_interval.l2bgrab++;
 if(wheadway==1) current_interval.l2bheadway++;
 totalv2b+=lastvehicle.speed;
 }
 else if(vehicle_lenght<LIMC)
 {
 lastvehicle.vclass='C';
 current_interval.l2ccount++;
 if(wspeed==1) current_interval.l2cspeed++;
 if(wgrab==1) current_interval.l2cgrab++;
 if(wheadway==1) current_interval.l2cheadway++;
 totalv2c+=lastvehicle.speed;
 }
 else if(vehicle_lenght<LIMD)
 {
 lastvehicle.vclass='D';
 current_interval.l2dcount++;
 if(wspeed==1) current_interval.l2dspeed++;
 if(wgrab==1) current_interval.l2dgrab++;
 if(wheadway==1) current_interval.l2dheadway++;
 totalv2d+=lastvehicle.speed;
 }
 else if(vehicle_lenght<LIMITE)
 {
 lastvehicle.vclass='E';
 current_interval.l2ecount++;
 if(wspeed==1) current_interval.l2espeed++;
 if(wgrab==1) current_interval.l2egrab++;
 if(wheadway==1) current_interval.l2eheadway++;
 totalv2e+=lastvehicle.speed;
 }
 else
 {
 lastvehicle.vclass='X';
 current_interval.l2xcount++;
 if(wspeed==1) current_interval.l2xspeed++;
 if(wgrab==1) current_interval.l2xgrab++;
 if(wheadway==1) current_interval.l2xheadway++;
 totalv2x+=lastvehicle.speed;
 }
 }
 tsdata[22] = lastvehicle.vclass;
 tsdata[20] = lane+49;
 bytetostr(lastvehicle.speed,tmp3);
 tsdata[24]=tmp3[0];
 tsdata[25]=tmp3[1];
 tsdata[26]=tmp3[2];
 if(wspeed==1) tsdata[28] = 49;
 else tsdata[28] = 48;
 if(wgrab==1) tsdata[29] = 49;
 else tsdata[29] = 48;
 if(wheadway==1) tsdata[30] = 49;
 else tsdata[30] = 48;

 tsdata[31]=0;
 tsdata[32]=0;
 for(tmpcnt=0;tmpcnt<strlen(tsdata);tmpcnt++) if(tsdata[tmpcnt]==' ') tsdata[tmpcnt]='0';

 {
 UART1_Write_Text(tsdata);
 UART1_Write(',');
 longtostr((long)(floor(vehicle_lenght)),debug_txt);
 UART1_Write_Text(debug_txt);
 UART1_Write(13);
 UART1_Write(10);
 }
 tsdata[31]=13;
 tsdata[32]=10;
 mmc_vbv_send=1;
 current_gap[lane]=0;

 reset_class(lane);

}
void measure_loops()
{
 if(!onloop0 && loop[0] && dev[0]>MARGINTOP && ((line1step==0) || (line1step==1 && Line_Dir[0]==21)))
 {
 onloop0=1;
 if(timexen[0])
 {
 T1[0]=timex[0];
 line1step=2;
 }
 else
 {
 timexen[0]=1;
 line1step=1;
 caldata[1]=freq_mean[1];
 Line_Dir[0]=12;
 }
 }
 else if(onloop0 && loop[0] && dev[0]<MARGINBOT && ((line1step==2 && Line_Dir[0]==12) || (line1step==3 && Line_Dir[0]==21)))
 {
 onloop0=0;
 if(T2[0]>0)
 {
 T3[0]=timex[0];
 line1step=0;
 caldata[1]=freq_mean[1];

 cal_class0=1;
 }
 else
 {
 T2[0]=timex[0];
 line1step=3;
 }
 }
 else if(onloop0 && loop[0] && dev[0]<MARGINBOT)
 {
 reset_class(0);
 }
 if(!onloop2 && loop[2] && dev[2]>MARGINTOP && ((line2step==0) || (line2step==1 && Line_Dir[1]==21)))
 {
 onloop2=1;
 if(timexen[1])
 {
 T1[1]=timex[1];
 line2step=2;
 }
 else
 {
 timexen[1]=1;
 line2step=1;
 caldata[3]=freq_mean[3];
 Line_Dir[1]=12;
 }
 }
 else if(onloop2 && loop[2] && dev[2]<MARGINBOT && ((line2step==2 && Line_Dir[1]==12) || (line2step==3 && Line_Dir[1]==21)))
 {
 onloop2=0;
 if(T2[1]>0)
 {
 T3[1]=timex[1];
 line2step=0;
 caldata[3]=freq_mean[3];

 cal_class1=1;

 }
 else
 {
 T2[1]=timex[1];
 line2step=3;
 }
 }
 else if(onloop2 && loop[2] && dev[2]<MARGINBOT)
 {
 reset_class(1);
 }

 if(!onloop1 && loop[1] && dev[1]>MARGINTOP && ((line1step==0) || (line1step==1 && Line_Dir[0]==12)))
 {
 onloop1=1;
 if(timexen[0])
 {
 T1[0]=timex[0];
 line1step=2;
 }
 else
 {
 timexen[0]=1;
 line1step=1;
 caldata[0]=freq_mean[0];
 Line_Dir[0]=21;
 }
 }
 else if(onloop1 && loop[1] && dev[1]<MARGINBOT && ((line1step==3 && Line_Dir[0]==12) || (line1step==2 && Line_Dir[0]==21)))
 {
 onloop1=0;
 if(T2[0]>0)
 {
 T3[0]=timex[0];
 line1step=0;
 caldata[0]=freq_mean[0];

 cal_class0=1;
 }
 else
 {
 T2[0]=timex[0];
 line1step=3;
 }
 }
 else if(onloop1 && loop[1] && dev[1]<MARGINBOT)
 {
 reset_class(0);
 }
 if(!onloop3 && loop[3] && dev[3]>MARGINTOP && ((line2step==0) || (line2step==1 && Line_Dir[1]==12)))
 {
 onloop3=1;
 if(timexen[1])
 {
 T1[1]=timex[1];
 line2step=2;
 }
 else
 {
 timexen[1]=1;
 line2step=1;
 caldata[2]=freq_mean[2];
 Line_Dir[1]=21;
 }
 }
 else if(onloop3 && loop[3] && dev[3]<MARGINBOT && ((line2step==3 && Line_Dir[1]==12) || (line2step==2 && Line_Dir[1]==21)))
 {
 onloop3=0;
 if(T2[1]>0)
 {

 T3[1]=timex[1];

 line2step=0;
 caldata[2]=freq_mean[2];

 cal_class1=1;
 }
 else
 {
 T2[1]=timex[1];
 line2step=3;
 }
 }
 else if(onloop3 && loop[3] && dev[3]<MARGINBOT)
 {
 reset_class(1);
 }
#line 451 "c:/users/admin/desktop/ratc-b4aj11/main/classification.h"
}
#line 13 "C:/Users/Admin/Desktop/RATC-B4AJ11/Main/91-7.c"
void TRAP_OSC() org 0x6
{
 OSCFAIL_bit=0;
  asm{RESET} ;
}
void TRAP_ADR() org 0x8
{
 ADDRERR_bit=0;
  asm{RESET} ;
}
void TRAP_STK() org 0xA
{
 STKERR_bit=0;
  asm{RESET} ;
}
void TRAP_ART() org 0xC
{
 MATHERR_bit=0;
  asm{RESET} ;
}

void TMR4INT() iv IVT_ADDR_T4INTERRUPT
{



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
 set_error( 0x0002 );
 }
 if(current_loop==1)
 {
 set_error( 0x0004 );
 }
 if(current_loop==2)
 {
 set_error( 0x0008 );
 }
 if(current_loop==3)
 {
 set_error( 0x0010 );
 }
 }
 else
 {

 freq_mean[current_loop]=(capz-capw);


 freq_help=(float)(caldata[current_loop]-freq_mean[current_loop]);
 freq_help/=(float)(caldata[current_loop]);
 freq_help*=10000;
 dev[current_loop]=(int)(freq_help);
 if(current_loop==0)
 {
 reset_error( 0x0002 );
 }
 if(current_loop==1)
 {
 reset_error( 0x0004 );
 }
 if(current_loop==2)
 {
 reset_error( 0x0008 );
 }
 if(current_loop==3)
 {
 reset_error( 0x0010 );
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
void cal()
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
 ADPCFG=0xFFFC;
 PWMCON1=0x0000;
 OVDCON=0x0000;
 gprs_timer_en=0;
 HMM=eeprom_read(0x7FFCC8);

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
#line 267 "C:/Users/Admin/Desktop/RATC-B4AJ11/Main/91-7.c"
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
  asm{CLRWDT} ;
 spifat_init();
  asm{CLRWDT} ;
 bytetostr(memory_error,debug_txt);
 UART1_Write_Text(debug_txt);
 err_cnt=0;
 err_cnt2=0;
 delay_ms(10);
 rtc_init();

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



 RTC_read();
 dis_int=1;
 sim900_restart();
 dis_int=0;

 cal_class0=0;
 cal_class1=0;
 send_sms=5;
 while(1)
 {
 asm{PWRSAV #1}

 rtc_read();


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
  asm{CLRWDT} ;
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
 if(current_time.minute% 5 ==0)
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
 if(vbat<230) set_error( 0x0080 );
 else reset_error( 0x0080 );
 solar=(long)ADC1_Get_Sample(1);
 if(power_type==0)
 {
 if(current_time.hour>10 && current_time.hour<14 && solar<200) set_error( 0x0040 );
 if(solar>250) reset_error( 0x0040 );

 }
 else if(power_type==1)
 {
 if(current_time.minute==30 && current_time.hour==22 && solar<200) set_error( 0x0020 );
 if(solar>250) reset_error( 0x0020 );
 }
 else if(power_type==2)
 {
 if(solar<200) set_error( 0x0020 );
 if(solar>250)
 {
 reset_error( 0x0020 );
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
 if(is_error( 0x0001 )) mmc_error=status;
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




 }
 UART1_Write(13);
 UART1_Write(10);

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






 }
 else if(sim_reset_step==3)
 {
 sim_reset_timer=1;
 sim_reset_step=4;

 pwrkey=0;
 clear_uart2();
 UART2_Write('A');

 UART2_Write('T');

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

 if(gprs_state==0)
 {

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

 if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
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

 if(uart2_data_pointer>1 && uart2_data[uart2_data_pointer-2] == 'O' && uart2_data[uart2_data_pointer-1] == 'K')
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

 if(uart2_data_pointer>6)
 {
 send_atc(gsm_cipstart);

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
 else
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




 sending_ready=0;
 sending_ready_i=0;
 while(!sending_ready && sending_ready_i<100)
 {
 delay_ms(20);
 sending_ready_i++;
 if(sending_ready_i==40)UART2_Write(13);
 }


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
 send_atc( "RATCX1" );
 send_atc( "HW:B-06,SW:JA11" );
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
