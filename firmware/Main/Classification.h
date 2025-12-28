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
    //vehicle speed va vehicle lenght be shekle float dar biaian
    vehicle_speed0=(double)(loop_distance)*1000;
    vehicle_speed1=(double)(loop_distance)*1000;
    vehicle_speed0=vehicle_speed0/((double)(T1[lane]));
    vehicle_speed1=vehicle_speed1/((double)(T3[lane]-T2[lane]));
    vehicle_speed = (vehicle_speed0+vehicle_speed1)/2;
    /*T2S=(T1[lane]+(T3[lane]-T2[lane]))/2;
    vehicle_speed0=(double)(loop_distance)*10000;
    vehicle_speed0=vehicle_speed0/((double)(T2S));*/
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
    if(lastvehicle.dir!=line1dir)
    {
        wgrab=1;
        if(lane==0) lane=1;
        else lane =0;
    }
    if(current_gap[lane]<gap_delay)
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
    else          tsdata[28] = 48;
    if(wgrab==1)  tsdata[29] = 49;
    else          tsdata[29] = 48;
    if(wheadway==1) tsdata[30] = 49;
    else          tsdata[30] = 48;

    tsdata[31]=0;
    tsdata[32]=0;
    for(tmpcnt=0;tmpcnt<strlen(tsdata);tmpcnt++) if(tsdata[tmpcnt]==' ') tsdata[tmpcnt]='0';
    //if(serial_vbv)
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
           //cal_class(0);
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
           //cal_class(1);
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
           //cal_class(0);
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
           //cal_class(1);
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
   /*#ifdef ZTCCOUNTER
   if(!onloop0 && loop[0] && dev[0]>MARGINTOP)
   {
       onloop0=1;
   }
   else if(onloop0 && loop[0] && dev[0]<MARGINBOT)
   {
       onloop0=0;
       counter_cal[0]=0;
       cal_class(0);
   }
   if(!onloop1 && loop[1] && dev[1]>MARGINTOP)
   {
       onloop1=1;
   }
   else if(onloop1 && loop[1] && dev[1]<MARGINBOT)
   {
       onloop1=0;
       counter_cal[1]=0;
       cal_class(1);
   }
   if(!onloop2 && loop[2] && dev[2]>MARGINTOP)
   {
       onloop2=1;
   }
   else if(onloop2 && loop[2] && dev[2]<MARGINBOT)
   {
       onloop2=0;
       counter_cal[2]=0;
       cal_class(2);
   }
   if(!onloop3 && loop[3] && dev[3]>MARGINTOP)
   {
       onloop3=1;
   }
   else if(onloop3 && loop[3] && dev[3]<MARGINBOT)
   {
       onloop3=0;
       counter_cal[3]=0;
       cal_class(3);
   }
   #endif   */

}