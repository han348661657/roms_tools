% ������Ҫ���ص�CFSR-V3ԭʼ�ļ����ص�ַ
% CFSR�����ϸĽ������ģ����ڴ�1979.1.1-2011.3.31
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
       fid1=fopen(['grib_cfsr-',num2str(Y),num2str(M,'%02d'),'�·�����.txt'],'w');
       Days=daysinmonth(Y,M);
       for D=1:Days
           for T=0:6:18        
               yy=num2str(Y);
               mm=num2str(M,'%02d');
               dd=num2str(D,'%02d');
               TT=num2str(T,'%02d');
               folder=[yy,'/',yy,mm,'/',yy,mm,dd];%�����ļ���
               fname=[t2,yy,mm,dd,TT,'.grb2'];%grb2�ļ���
               url0=[t1,folder,fname];  

          fprintf(fid1,'%s\r\n',url0);

           end % T
       end %D
       fclose(fid1);
%        fclose(fid2);
      end %M
end %Y 