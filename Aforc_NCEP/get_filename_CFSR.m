function fname=get_filename_CFSR(Y,M,D,T)

stryear=num2str(Y);
if M<10
  strmonth=['0',num2str(M)];
else
  strmonth=[num2str(M)];
end

if D<10
  strday=['0',num2str(D)];
else
  strday=[num2str(D)];
end

if T==0
  strtime=['00'];
elseif T<10
  strtime=['0',num2str(T)];
else
  strtime=[num2str(T)];
end

fname=[stryear,'/',stryear,strmonth,'/',...
       stryear,strmonth,strday,'/cdas1.t',...
       strtime,'z.sfluxgrbf09.grib2'];
       %cdas1.t00z.sfluxgrbf09.grib2
       
return
