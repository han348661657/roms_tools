clear;clc;
Ymin=2012;
Ymax=2014;
Mmin=12;
Mmax=1;
Input_dir='../Orig/';
Output_dir='../Out/';
Yorig=2000;
vname='Land_cover_1land_2sea';

nc = netcdf('../ECS_grd.nc', 'nowrite');
lon_rho=nc{'lon_rho'}(:);
lat_rho=nc{'lat_rho'}(:);
close(nc)
xi=lon_rho(1,:);
eta=lat_rho(:,1);

nc = netcdf([Input_dir,'LandCover.nc'], 'nowrite');
glat=nc{'lat'}(:);
glon=nc{'lon'}(:);
index_xi=find(glon>min(xi)-1 & glon<max(xi)+1 );
index_eta=find(glat>min(eta)-1 & glat<max(eta)+1);

mask=nc{'LAND_L1'}(1,index_eta,index_xi);
close(nc)
lon=glon(index_xi);
lat=glat(index_eta);
lat=flipud(lat);

time=datenum(Ymin,Mmin,1,0,0,0)-datenum(Yorig,1,1);
var=squeeze(mask);
var=flipud(var);

write_NCEP([Output_dir,vname,'.nc'],...
	      vname,lon,lat,time,var,Yorig)
