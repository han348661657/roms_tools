function [Nlon,Nlat,lon,lat]=cutarea(lon,lat,lonmin,lonmax,latmin,latmax)

j=find(lat>=(latmin-1) & lat<=(latmax+1));
%
i1=find(lon-360>=lonmin & lon-360<=lonmax);
i2=find(lon>=(lonmin) & lon<=(lonmax));
i3=find(lon+360>=(lonmin) & lon+360<=(lonmax));
%
lon=cat(1,lon(i1)-360,lon(i2),lon(i3)+360);
lat=lat(j);
Nlon=cat(1,i1,i2,i3);
Nlat=j;