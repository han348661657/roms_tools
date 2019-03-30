function var=get_filename_CFSR_daily_ww3(Input_dir,vname,Y,M,D,T,index_xi,index_eta)
% 获取如下文件
% 'E:\2.NCEP\data\2005\flxf09.gdas.200501\flxf09.gdas.2005010100.grb2'
% 从指定文件中读取变量
stryear=num2str(Y);
strmonth=num2str(M,'%02d');
strday=num2str(D,'%02d');
strT=num2str(T,'%02d');
date=[stryear,strmonth,strday,strT];
fname=[Input_dir,'flxf09.gdas.',date,'.grb2'];
nc=ncgeodataset(fname);
var0=squeeze(nc.data(vname));
var1=var0(index_eta,index_xi);
var1=double(var1);
close(nc);
var=flipud(var1);


return
