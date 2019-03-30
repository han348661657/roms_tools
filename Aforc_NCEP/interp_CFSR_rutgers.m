function interp_CFSR_rutgers(NCEP_dir,Y,M,Roa,interp_method,...
                     lon1,lat1,lon2,lat2,mask1,tin,nc_blk,lon,lat,angle,tout)

%
% Read the local NCEP files and perform the interpolations
%
%
% 1: Air temperature: Convert from Kelvin to Celsius
%
vname='Temperature_height_above_ground';
nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
tair=squeeze(nc{vname}(tin,:,:));
close(nc);
tair=get_missing_val(lon1,lat1,mask1.*tair,nan,Roa,nan);
tair=tair-273.15;
tair=interp2(lon1,lat1,tair,lon,lat,interp_method);
%
% 2: Relative humidity: Convert from % to fraction
%
% Get Specific Humidity [Kg/Kg]
%
vname='Specific_humidity_height_above_ground';
nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
shum=squeeze(nc{vname}(tin,:,:));
close(nc);
shum=get_missing_val(lon1,lat1,mask1.*shum,nan,Roa,nan);
shum=interp2(lon1,lat1,shum,lon,lat,interp_method);
%
% computes specific humidity at saturation (Tetens  formula)
% (see air_sea tools, fonction qsat)
%
% rhum=shum./qsat(tari);     Agrif input :kg/kg (0-1)
rhum=shum./qsat(tair)*100;   % Rutgers input: percentage (0-100)
%
% 3: Precipitation rate:    kg/m^2/s
% Rutgers [kg/m^2/s] 
% Agrif   [ cm/day ]
%
vname='Precipitation_rate_surface_3_Hour_Average';
try
    nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
catch
    vname='Precipitation_rate_surface_0_Hour_Average';
    nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
end
prate=squeeze(nc{vname}(tin,:,:));
close(nc);
prate=get_missing_val(lon1,lat1,mask1.*prate,nan,Roa,nan);
%prate=prate*0.1*(24.*60.*60.0);
prate=interp2(lon1,lat1,prate,lon,lat,interp_method);
prate(abs(prate)<1.e-4)=0;
%
% 4: Net shortwave flux: [W/m^2]
%      ROMS convention: downward = positive
%
% Downward solar shortwave
%
vname='Downward_Short-Wave_Radiation_Flux_surface';
nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
dswrf=squeeze(nc{vname}(tin,:,:));
close(nc);
dswrf=get_missing_val(lon1,lat1,mask1.*dswrf,nan,Roa,nan);
%  
% Upward solar shortwave
% 
vname='Upward_Short-Wave_Radiation_Flux_surface';
nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
uswrf=squeeze(nc{vname}(tin,:,:));
close(nc);
uswrf=get_missing_val(lon1,lat1,mask1.*uswrf,nan,Roa,nan);
%  
%  Net solar shortwave radiation  
%
radsw=dswrf - uswrf;
%----------------------------------------------------  
% GC le 31 03 2009
%  radsw is NET solar shortwave radiation
%  no more downward only solar radiation
% GC  bug fix by F. Marin IRD/LEGOS
%-----------------------------------------------------
radsw=interp2(lon1,lat1,radsw,lon,lat,interp_method);
radsw(radsw<1.e-10)=0;
%
% 5: Net outgoing Longwave flux:  [W/m^2]
%      ROMS convention: positive upward (opposite to nswrf !!!!)
%
% Get the net longwave flux [W/m^2]
%
%  5.1 get the downward longwave flux [W/m^2]
%
vname='Downward_Long-Wave_Radp_Flux_surface';
nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
dlwrf=squeeze(nc{vname}(tin,:,:));
close(nc);
dlwrf=get_missing_val(lon1,lat1,mask1.*dlwrf,nan,Roa,nan);
%
%  5.2 get the upward longwave flux [W/m^2]
%
vname='Upward_Long-Wave_Radp_Flux_surface';
nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
ulwrf=squeeze(nc{vname}(tin,:,:));
close(nc);
ulwrf=get_missing_val(lon1,lat1,mask1.*ulwrf,nan,Roa,nan);
%  
%  Net longwave flux 
%
radlw=interp2(lon1,lat1,dlwrf-ulwrf,lon,lat,interp_method);
%  longwave radiation : Agirf upwards is positive
%                       Rutgers Downwards is positive
%
%
% 6: Wind & Wind stress [m/s]
%
vname='u-component_of_wind_height_above_ground';   
nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
uwnd=squeeze(nc{vname}(tin,:,:));
close(nc)
uwnd=get_missing_val(lon1,lat1,mask1.*uwnd,nan,Roa,nan);
uwnd=interp2(lon1,lat1,uwnd,lon,lat,interp_method);
%
vname='v-component_of_wind_height_above_ground';
nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
vwnd=squeeze(nc{vname}(tin,:,:));
close(nc)
vwnd=get_missing_val(lon1,lat1,mask1.*vwnd,nan,Roa,nan);
vwnd=interp2(lon1,lat1,vwnd,lon,lat,interp_method);
%
% Rotations on the ROMS grid
%
cosa=cos(angle);
sina=sin(angle);
%
% uwnd and vwnd at points 'rho'   (rutgers version)
%
%u10=rho2u_2d(uwnd.*cosa+vwnd.*sina);
%v10=rho2v_2d(vwnd.*cosa-uwnd.*sina);
u10=uwnd.*cosa+vwnd.*sina;
v10=vwnd.*cosa-uwnd.*sina;
%

%  7 get the sea air pressure: Convert from pa to millibar
%  the pressue's resolution is lower ,use lon2,lat2 to interp.
vname='Pressure_surface';
nc=netcdf([NCEP_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc']);
press=squeeze(nc{vname}(tin,:,:));
close(nc);
press=get_missing_val(lon2,lat2,press,nan,Roa,nan);
press=interp2(lon2,lat2,press,lon,lat,interp_method);
press=press/100;   %  Convert from pa to millibar


% Fill the ROMS files
%  
  nc_blk{'Uwind'}(tout,:,:)=u10;
  nc_blk{'Vwind'}(tout,:,:)=v10;
  nc_blk{'Pair'}(tout,:,:)=press;
  nc_blk{'Tair'}(tout,:,:)=tair;
  nc_blk{'Qair'}(tout,:,:)=rhum;
  nc_blk{'rain'}(tout,:,:)=prate;
  nc_blk{'lwrad'}(tout,:,:)=radlw;
  nc_blk{'swrad'}(tout,:,:)=radsw;



