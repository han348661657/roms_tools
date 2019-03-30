% 生成需要下载的NCEP-CFSV2原始文件下载地址
% CFSV2是在CFSR基础上改进而来的，日期从2011.4-2016.9
Ymin=2016;
Ymax=2016;
Mmin=9;
Mmax=9;
% ncep_url_generate
t1='http://nomads.ncdc.noaa.gov/thredds/ncss/grid/modeldata/cfsv2_analysis_flxf/';
t2='?var=Downward_Long-Wave_Rad_Flux&var=Downward_Short-Wave_Rad_Flux&var=Land_cover_1land_2sea';
t3='&var=Precipitation_rate&var=Temperature_surface&var=Upward_Long-Wave_Rad_Flux&var=Upward_Short-Wave_Rad_Flux&var=U-component_of_wind';
t4='&var=V-component_of_wind&var=Specific_humidity&var=Temperature_height_above_ground$';
t5='&spatial=all&north=89.8435&west=0.0000&east=0.5949&south=-89.8435';
t6='&temporal=all&';
g1='http://nomads.ncdc.noaa.gov/modeldata/cfsv2_analysis_flxf/';
%Loop no years
for Y=Ymin:Ymax
      disp(['=========================='])
      disp(['Processing year: ',num2str(Y)])
      disp(['=========================='])
% Loop on the months
%
      if Y==Ymin
        mo_min=Mmin;
      else
        mo_min=1;
      end
      if Y==Ymax
        mo_max=Mmax;
      else
        mo_max=12;
      end  
      for M=mo_min:mo_max
       fid1=fopen(['grib_cfsv2-',num2str(Y),num2str(M,'%02d'),'月份下载.txt'],'w');
%        fid2=fopen(['win_cfsv2-',num2str(Y),num2str(M,'%02d'),'月份下载.txt'],'w');
       Days=daysinmonth(Y,M);
       for D=1:Days
           for T=0:6:18               
           fname=get_filename_CFSR(Y,M,D,T);
%            time_start=[num2str(Y),'-',num2str(M,'%02d'),'-',num2str(D,'%02d'),'T',num2str(T,'%02d')...
%               '%3A00%3A00Z&' ];
%            time_end=[num2str(Y),'-',num2str(M,'%02d'),'-',num2str(D,'%02d'),'T',num2str(T,'%02d')...
%               '%3A00%3A00Z&horizStride=' ];
          url0=[g1,fname];
%           url=[t1,fname,t2,t3,t4,t5,t6,'time_start=',time_start,'time_end=',time_end];%下载地址
          
          % 为下载文件重新命名：cfsr_2014010106.nc
%          newname=['cfsr_',num2str(Y),num2str(M,'%02d'),num2str(D,'%02d'),num2str(T,'%02d'),'.nc'];
%          out_log=['out',num2str(Y),num2str(M,'%02d'),'.log'];% 输出日志
%           command=['wget -o ',out_log,' -O ',newname,' -c '];%命令，-o日志输出，-O文件重命名，-c断续重连
          fprintf(fid1,'%s\r\n',url0);
%           fprintf(fid2,'%s\r\n',url);
           end % T
       end %D
       fclose(fid1);
%        fclose(fid2);
      end %M
end %Y 