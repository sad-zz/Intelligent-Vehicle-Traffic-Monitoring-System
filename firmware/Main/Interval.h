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
     //totalv2cnew=0;
     totalv2d=0;
     totalv2e=0;
     totalv2x=0;

     l1occ=0;
     l2occ=0;
    // #endif
}
void cal_interval()
{
     reset_interval_data();
     
     if(current_interval.l1acount>0) current_interval.l1avavg=(unsigned short)(totalv1a/current_interval.l1acount);
     else  current_interval.l1avavg=0;
     
     if(current_interval.l1bcount>0) current_interval.l1bvavg=(unsigned short)(totalv1b/current_interval.l1bcount);
     else  current_interval.l1bvavg=0;
     
     if(current_interval.l1ccount>0) current_interval.l1cvavg=(unsigned short)(totalv1c/current_interval.l1ccount);
     else  current_interval.l1cvavg=0;
     
     if(current_interval.l1dcount>0) current_interval.l1dvavg=(unsigned short)(totalv1d/current_interval.l1dcount);
     else  current_interval.l1dvavg=0;
     
     if(current_interval.l1ecount>0) current_interval.l1evavg=(unsigned short)(totalv1e/current_interval.l1ecount);
     else  current_interval.l1evavg=0;
     
     if(current_interval.l1xcount>0) current_interval.l1xvavg=(unsigned short)(totalv1x/current_interval.l1xcount);
     else  current_interval.l1xvavg=0;

     if(current_interval.l2acount>0) current_interval.l2avavg=(unsigned short)(totalv2a/current_interval.l2acount);
     else  current_interval.l2avavg=0;

     if(current_interval.l2bcount>0) current_interval.l2bvavg=(unsigned short)(totalv2b/current_interval.l2bcount);
     else  current_interval.l2bvavg=0;

     if(current_interval.l2ccount>0) current_interval.l2cvavg=(unsigned short)(totalv2c/(unsigned long)(current_interval.l2ccount));
     else  current_interval.l2cvavg=0;

     if(current_interval.l2dcount>0) current_interval.l2dvavg=(unsigned short)(totalv2d/current_interval.l2dcount);
     else  current_interval.l2dvavg=0;

     if(current_interval.l2ecount>0) current_interval.l2evavg=(unsigned short)(totalv2e/current_interval.l2ecount);
     else  current_interval.l2evavg=0;

     if(current_interval.l2xcount>0) current_interval.l2xvavg=(unsigned short)(totalv2x/current_interval.l2xcount);
     else  current_interval.l2xvavg=0;
     
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
     //////////////////////////
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
     //////////////////////////
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
     //////////////////////////
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
     //////////////////////////
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
     //////////////////////////
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
     //////////////////////////
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

     inttostr((int)(l1occ/(INTERVALPERIOD*2*600)),debug_txt);
     interval_data[132]=debug_txt[3];
     interval_data[133]=debug_txt[4];
     interval_data[134]=debug_txt[5];
     
     
     //////////////////////                     LINE 222222222222222222222222222222222
     
     
     //////////////////////////
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
     //////////////////////////
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
     //////////////////////////
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
     //////////////////////////
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
     //////////////////////////
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
     //////////////////////////
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


     inttostr((int)(l2occ/(INTERVALPERIOD*2*600)),debug_txt);
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
     //temp=((long)(ADC1_Get_Sample(2)*488));
     //temp/=1000;
     inttostr(error_byte,debug_txt);
     interval_data[258]=debug_txt[2];
     interval_data[259]=debug_txt[3];
     interval_data[260]=debug_txt[4];
     interval_data[261]=debug_txt[5];

     //#endif
     //UART1_Write('4');
     reset_interval();
     //UART1_Write('4');
     for(cal_interval_cnt=0;cal_interval_cnt<262;cal_interval_cnt++) if(interval_data[cal_interval_cnt]==' ') interval_data[cal_interval_cnt]='0';
}