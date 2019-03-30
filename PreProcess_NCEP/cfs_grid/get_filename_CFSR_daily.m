function var=get_filename_CFSR_daily(Input_dir,vname,Y,M,D,T,index_xi,index_eta)
% 从指定文件中读取变量
stryear=num2str(Y);
strmonth=num2str(M,'%02d');
strday=num2str(D,'%02d');
strT=num2str(T,'%02d');
date=[stryear,'-',strmonth,'-',strday,'T',strT];
fname=[Input_dir,'cfs_',date,'.grib2'];
nc=ncgeodataset(fname);
var0=squeeze(nc.data(vname));
var1=var0(index_eta,index_xi);
var1=double(var1);
close(nc);
var=flipud(var1);


return
