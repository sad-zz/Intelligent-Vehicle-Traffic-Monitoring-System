#define                 ZTCLITE
#define                 XMICRO                  4
#define                 INTERVALPERIOD          5
#define                 system_model            "RATCX1"
#define                 version                 "HW:B-06,SW:JA11"
#define                 MMC_ERR                 0x0001
#define                 LP1_ERR                 0x0002
#define                 LP2_ERR                 0x0004
#define                 LP3_ERR                 0x0008
#define                 LP4_ERR                 0x0010
#define                 VMN_ERR                 0x0020
#define                 SOL_ERR                 0x0040
#define                 LBT_ERR                 0x0080
#define                 L1D_ERR                 0x0100
#define                 L2D_ERR                 0x0200
#define                 line1dir                12
#define                 line2dir                12
#define                 gap_delay               2000

void set_error(unsigned int errb);
void reset_error(unsigned int errb);
const char
    system_id[]="10001704",
    gsm_cipshut[] = "T+CIPSHUT",
    gsm_cstt[3][100] = {"AT+CSTT=\"mtnirancell\",\"\",\"\"","AT+CSTT=\"mcinet\",\"\",\"\""},
    gsm_ciicr[] = "AT+CIICR",
    gsm_cifsr[] = "AT+CIFSR",
    gsm_cipstart[] = "AT+CIPSTART=\"TCP\",\"",
    gsm_cipsend[]  = "T+CIPSEND=",
    gsm_ata[]  = "ATA",
    gsm_ate0[] = "ATE0&W";
sbit status  at LATE4_bit;
sbit onloop0 at LATE0_bit;
sbit onloop1 at LATE1_bit;
sbit onloop2 at LATE2_bit;
sbit onloop3 at LATE3_bit;
sbit rtc     at LATF0_bit;
sbit mmc     at LATF1_bit;
sbit modem_pwr     at LATB2_bit;
sbit mmc_error     at LATB5_bit;
sbit charge_control     at LATB8_bit;
sbit mdmstat     at RB6_bit;
sbit pwrkey     at LATB7_bit;
sbit connection_state at LATE5_bit;
sbit Mmc_Chip_Select           at LATF1_bit;
sbit Mmc_Chip_Select_Direction at TRISF1_bit;

short
    loop_error_tmp,
    memory_error_sent      ,
    memory_ok_sent         ,
    debug                  ,
    spi_busy               ,
    mmc_int_send           ,
    mmc_vbv_send           ,
    timer_1_sec            ,
    docal                  ,
    dis_int                ,
    debug_gsm              ,
    sending_ready          ,
    sending_ready_i        ,
    current_loop           ,
    tmpcnt                 ,
    onloop[4]              ,
    Line_Dir[2]            ,
    timexen[2]             ,
    fileHandle             ,
    forth                  ,
    gprs_send              ,
    gprs_state=0           ,
    gprs_timer=0           ,
    gprs_end_timer=0       ,
    uart1_data_pointer=0   ,
    uart2_data_pointer=0   ,

    line1step              ,
    line2step              ,
    statu                  ,
    uart2_data_received    ,
    uart2_data_received2   ,
    gprs_timer_en          ,
    uart1_data_received    ,
    last_temp1=0           ,
    rtc_read_cnt           ;
unsigned short
    cal_timer[4]           ,

    foundd                 ,
    wspeed                 ,
    wgrab                  ,
    wheadway               ,
    sim_reset              ,
    sim_reset_step         ,
    sim_reset_timer        ,
    cal_class0             ,
    cal_class1             ,
    cal_k                  ,
    longk                  ,
    clear_uart1_cnt        ,
    clear_uart2_cnt        ,
    gsm_ready              ;
char
    tmp4[7]                ,
    err_cnt                ,
    memory_error           ,
    err_cnt2               ,
    sms_step               ,
    send_sms               ,
    debug_txt[12]          ,
    uart1_data[50]         ,
    uart2_data[50]         ,
    tsdata[34]= "12.06.07,11:54:23.2,1,A,136,100  "
                           ,
    datetimesec[22]="2000.00.00-00:00:00.0"
                           ,
    tmp3[4]                ,
    tmp7[7]                ,
    udata                  ,
    udata2                 ,
    dataname[11]="1212120000"
                           ,
    location_name[33]="________________________________"
                           ,
    sms_number_1[12]="09123701598"
                           ,
    interval_data[512] = "0000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000  "
                           ;
int
    function_code          ,
    jj                     ,
    port                   ,
    u2func                 ,
    LIMX                   ,
    LIMA                   ,
    LIMB                   ,
    LIMC                   ,
    LIMD                   ,
    PRVAL                  ,
    DSPEED1                ,
    NSPEED1                ,
    DSPEED2                ,
    NSPEED2                ,
    HMM                    ,
    AUTCAL                 ,
    mmc_i                  ,
    power_type             ,
    LIMITE                 ,
    MARGINTOP              ,
    MARGINBOT              ,
    apndata                ,
    ip1                    ,
    ip2                    ,
    ip3                    ,
    ip4                    ,
    milisec                ,
    how_many_micro = 0     ,
    loop[4]                ,
    serial_vbv             ,
    loop_distance          ,
    loop_width             ,
    dev[4]                 ,
    current_gap[2]         ;
unsigned int
    error_byte=0b0000000000000000
                           ,
    cal_interval_cnt       ,
    error_byte_last=0b0000000000000000
                           ,
    calpointer[4]          ;
long
    vbat                   ,
    solar                  ,
    l1occ                  ,

    T2S                    ,
    l2occ                  ,
    T1[2]                  ,
    T2[2]                  ,
    T3[2]                  ,
    timex[2]               ;
unsigned long
    freq_mean[4]           ,
    capw                   ,
    capx                   ,
    capy                   ,
    capz                   ,
    freq_sum_cal           ,
    calsum[4]              ,
    caldata[4]             ,
    filesize               ,
    totalv1a               ,
    totalv1b               ,
    totalv1c               ,
    totalv1d               ,
    totalv1e               ,
    totalv1x               ,
    totalv2a               ,
    totalv2b               ,
    totalv2c               ,
    totalv2d               ,
    totalv2e               ,
    current_sector         ,
    totalv2x               ;

float

    freq_help              ;
double
    vehicle_speed0         ,
    vehicle_speed1         ,
    vehicle_speed          ,
    vehicle_lenght         ;


struct vehicle {
       short dir;
       unsigned short speed;
       char  vclass;
} lastvehicle              ;
struct time {
       char
                null,
                second,
                minute,
                hour,
                day,
                month,
                year;
} current_time            ;

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

} current_interval       ;




void cal();
void measure_loops();
void clear_uart1();

void clear_uart2();
void reset_interval_data();

void cal_class(unsigned short lane);