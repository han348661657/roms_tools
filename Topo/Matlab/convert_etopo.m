nc=netcdf('etopo2.nc');
lon=nc{'lon'}(:);
lat=nc{'lat'}(:);
topo=nc{'topo'}(:);
close(nc)

nc=netcdf('etopo2bis.nc','clobber');
redef(nc);
%
%  Create dimensions
%
nc('lon')=length(lon);
nc('lat')=length(lat);
%
%  Create variables and attributes
%
nc{'lon'}=ncfloat('lon');
nc{'lat'}=ncfloat('lat');
nc{'topo'}=ncfloat('lat','lon');
endef(nc);
nc{'lon'}(:)=lon;
nc{'lat'}(:)=lat;
nc{'topo'}(:)=topo;
close(nc)
