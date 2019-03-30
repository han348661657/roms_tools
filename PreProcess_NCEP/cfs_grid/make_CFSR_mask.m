function make_CFSR_mask(fname,Out_dir,Ymin,Mmin,index_xi,index_eta,Yorig)
% 生成Land_cover_1land_2sea.nc文件

vname='Land_cover_1land_2sea';


nc =ncgeodataset(fname);
glat=nc.data('lat');
glon=nc.data('lon');

mask=squeeze(nc.data('Land_cover_1land_2sea'));
close(nc)
lon=glon(index_xi);
lat=glat(index_eta);
lat=flipud(lat);

time=datenum(Ymin,Mmin,1,0,0,0)-datenum(Yorig,1,1);
var=squeeze(mask);
var=var(index_eta,index_xi);
var=double(var);
var=flipud(var);

write_NCEP([Out_dir,vname,'.nc'],...
	      vname,lon,lat,time,var,Yorig)
