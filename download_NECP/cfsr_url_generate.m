% 生成需要下载的CFSR-V3原始文件下载地址
% CFSR基础上改进而来的，日期从1979.1.1-2011.3.31
Ymin=2004;
Ymax=2004;
Mmin=12;
Mmax=12;
% ncep_url_generate
t1='https://nomads.ncdc.noaa.gov/modeldata/cmd_flxf/';
t2='/flxf09.gdas.';
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
       fid1=fopen(['grib_cfsr-',num2str(Y),num2str(M,'%02d'),'月份下载.txt'],'w');
       Days=daysinmonth(Y,M);
       for D=1:Days
           for T=0:6:18        
               yy=num2str(Y);
               mm=num2str(M,'%02d');
               dd=num2str(D,'%02d');
               TT=num2str(T,'%02d');
               folder=[yy,'/',yy,mm,'/',yy,mm,dd];%所在文件夹
               fname=[t2,yy,mm,dd,TT,'.grb2'];%grb2文件名
               url0=[t1,folder,fname];  

          fprintf(fid1,'%s\r\n',url0);

           end % T
       end %D
       fclose(fid1);
%        fclose(fid2);
      end %M
end %Y 