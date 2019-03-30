function  create_bulk_rutgers(frcname,grdname,title,bulkt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 	Create an empty netcdf heat flux bulk forcing file
%       frcname: name of the forcing file
%       grdname: name of the grid file
%       title: title in the netcdf file  
% 
%  Yu Liu   yliu@nuist.edu.cn   2015-8-13
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nc=netcdf(grdname);
L=length(nc('xi_psi'));
M=length(nc('eta_psi'));
result=close(nc);
Lp=L+1;
Mp=M+1;
if exist(frcname,'file')
    disp('deleting the old frcing file')
    delete(frcname)
    %eval('!rm frcname')
end
nccreate(frcname,'64bit');
nw = netcdf(frcname, 'write');
result = redef(nw);


%
%  Create dimensions
%
tn=length(bulkt);

nw('xrho') = Lp;
nw('yrho') = Mp;
nw('time') = tn;
nw('wind_time') = tn;
nw('Pair_time') = tn;
nw('Tair_time') = tn;
nw('Qair_time') = tn;
nw('rain_time') = tn;
nw('swrad_time') = tn;
nw('lwrad_time') = tn;

%
%  Create variables and attributes
 
nw{'time'} = ncdouble('time'); 
nw{'time'}.long_name = ncchar('atmospheric forcing time');
nw{'time'}.units = ncchar('days');
nw{'time'}.field = ncchar('time, scalar, series');
nw{'time'}.long_name = 'atmospheric forcing time';
nw{'time'}.units = 'days';
nw{'time'}.field = 'time, scalar, series';

nw{'lon'} = ncdouble('yrho', 'xrho'); 
nw{'lon'}.long_name = ncchar('longitude');
nw{'lon'}.units = ncchar('degrees_east');
nw{'lon'}.field = ncchar('xp, scalar, series');
nw{'lon'}.long_name = 'longitude';
nw{'lon'}.units = 'degrees_east';
nw{'lon'}.field = 'xp, scalar, series';

 
nw{'lat'} = ncdouble('yrho', 'xrho');
nw{'lat'}.long_name = ncchar('latitude');
nw{'lat'}.units = ncchar('degrees_north');
nw{'lat'}.field = ncchar('yp, scalar, series');
nw{'lat'}.long_name = 'latitude';
nw{'lat'}.units = 'degrees_north';
nw{'lat'}.field = 'yp, scalar, series';
 
nw{'wind_time'} = ncdouble('wind_time'); 
nw{'wind_time'}.long_name = ncchar('wind_time');
nw{'wind_time'}.units = ncchar('days');
nw{'wind_time'}.field = ncchar('Uwind_time, scalar, series');
nw{'wind_time'}.long_name = 'wind_time';
nw{'wind_time'}.units = 'days';
nw{'wind_time'}.field = 'Uwind_time, scalar, series';
 
nw{'Uwind'} = ncdouble('wind_time', 'yrho', 'xrho'); 
nw{'Uwind'}.long_name = ncchar('surface u-wind component');
nw{'Uwind'}.units = ncchar('meter second-1');
nw{'Uwind'}.field = ncchar('Uwind, scalar, series');
nw{'Uwind'}.coordinates = ncchar('lon lat');
nw{'Uwind'}.time = ncchar('wind_time');
nw{'Uwind'}.long_name = 'surface u-wind component';
nw{'Uwind'}.units = 'meter second-1';
nw{'Uwind'}.field = 'Uwind, scalar, series';
nw{'Uwind'}.coordinates = 'lon lat';
nw{'Uwind'}.time = 'wind_time';
 
nw{'Vwind'} = ncdouble('wind_time', 'yrho', 'xrho'); 
nw{'Vwind'}.long_name = ncchar('surface v-wind component');
nw{'Vwind'}.units = ncchar('meter second-1');
nw{'Vwind'}.field = ncchar('Vwind, scalar, series');
nw{'Vwind'}.coordinates = ncchar('lon lat');
nw{'Vwind'}.time = ncchar('wind_time');
nw{'Vwind'}.long_name = 'surface v-wind component';
nw{'Vwind'}.units = 'meter second-1';
nw{'Vwind'}.field = 'Vwind, scalar, series';
nw{'Vwind'}.coordinates = 'lon lat';
nw{'Vwind'}.time = 'wind_time';
 
nw{'Pair_time'} = ncdouble('Pair_time'); 
nw{'Pair_time'}.long_name = ncchar('Pair_time');
nw{'Pair_time'}.units = ncchar('days');
nw{'Pair_time'}.field = ncchar('Pair_time, scalar, series');
nw{'Pair_time'}.long_name = 'Pair_time';
nw{'Pair_time'}.units = 'days';
nw{'Pair_time'}.field = 'Pair_time, scalar, series';
 
nw{'Pair'} = ncdouble('Pair_time', 'yrho', 'xrho'); 
nw{'Pair'}.long_name = ncchar('surface air pressure');
nw{'Pair'}.units = ncchar('millibar');
nw{'Pair'}.field = ncchar('Pair, scalar, series');
nw{'Pair'}.coordinates = ncchar('lon lat');
nw{'Pair'}.time = ncchar('Pair_time');
nw{'Pair'}.long_name = 'surface air pressure';
nw{'Pair'}.units = 'millibar';
nw{'Pair'}.field = 'Pair, scalar, series';
nw{'Pair'}.coordinates = 'lon lat';
nw{'Pair'}.time = 'Pair_time';
 
nw{'Tair_time'} = ncdouble('Tair_time');
nw{'Tair_time'}.long_name = ncchar('Tair_time');
nw{'Tair_time'}.units = ncchar('days');
nw{'Tair_time'}.field = ncchar('Tair_time, scalar, series');
nw{'Tair_time'}.long_name = 'Tair_time';
nw{'Tair_time'}.units = 'days';
nw{'Tair_time'}.field = 'Tair_time, scalar, series';

 
nw{'Tair'} = ncdouble('Tair_time', 'yrho', 'xrho'); 
nw{'Tair'}.long_name = ncchar('surface air temperature');
nw{'Tair'}.units = ncchar('Celsius');
nw{'Tair'}.field = ncchar('Tair, scalar, series');
nw{'Tair'}.coordinates = ncchar('lon lat');
nw{'Tair'}.time = ncchar('Tair_time');
nw{'Tair'}.long_name = 'surface air temperature';
nw{'Tair'}.units = 'Celsius';
nw{'Tair'}.field = 'Tair, scalar, series';
nw{'Tair'}.coordinates = 'lon lat';
nw{'Tair'}.time = 'Tair_time';
 
nw{'Qair_time'} = ncdouble('Qair_time'); 
nw{'Qair_time'}.long_name = ncchar('Qair_time');
nw{'Qair_time'}.units = ncchar('days');
nw{'Qair_time'}.field = ncchar('Qair_time, scalar, series');
nw{'Qair_time'}.long_name = 'Qair_time';
nw{'Qair_time'}.units = 'days';
nw{'Qair_time'}.field = 'Qair_time, scalar, series';
 
nw{'Qair'} = ncdouble('Qair_time', 'yrho', 'xrho');
nw{'Qair'}.long_name = ncchar('surface air relative humidity');
nw{'Qair'}.units = ncchar('percentage');
nw{'Qair'}.field = ncchar('Qair, scalar, series');
nw{'Qair'}.coordinates = ncchar('lon lat');
nw{'Qair'}.time = ncchar('Qair_time');
nw{'Qair'}.long_name = 'surface air relative humidity';
nw{'Qair'}.units = 'percentage';
nw{'Qair'}.field = 'Qair, scalar, series';
nw{'Qair'}.coordinates = 'lon lat';
nw{'Qair'}.time = 'Qair_time';
 
nw{'rain_time'} = ncdouble('rain_time'); 
nw{'rain_time'}.long_name = ncchar('rain_time');
nw{'rain_time'}.units = ncchar('days');
nw{'rain_time'}.field = ncchar('rain_time, scalar, series');
nw{'rain_time'}.long_name = 'rain_time';
nw{'rain_time'}.units = 'days';
nw{'rain_time'}.field = 'rain_time, scalar, series';
 
nw{'rain'} = ncdouble('rain_time', 'yrho', 'xrho'); 
nw{'rain'}.long_name = ncchar('rain fall rate');
nw{'rain'}.units = ncchar('kilogram meter-2 second-1');
nw{'rain'}.field = ncchar('Qair, scalar, series');
nw{'rain'}.coordinates = ncchar('lon lat');
nw{'rain'}.time = ncchar('rain_time');
nw{'rain'}.long_name = 'rain fall rate';
nw{'rain'}.units = 'kilogram meter-2 second-1';
nw{'rain'}.field = 'Qair, scalar, series';
nw{'rain'}.coordinates = 'lon lat';
nw{'rain'}.time = 'rain_time';
 
nw{'swrad_time'} = ncdouble('swrad_time'); 
nw{'swrad_time'}.long_name = ncchar('swrad_time');
nw{'swrad_time'}.units = ncchar('days');
nw{'swrad_time'}.field = ncchar('swrad_time, scalar, series');
nw{'swrad_time'}.long_name = 'swrad_time';
nw{'swrad_time'}.units = 'days';
nw{'swrad_time'}.field = 'swrad_time, scalar, series';
 
nw{'swrad'} = ncdouble('swrad_time', 'yrho', 'xrho'); 
nw{'swrad'}.long_name = ncchar('solar shortwave radiation');
nw{'swrad'}.units = ncchar('Watts meter-2');
nw{'swrad'}.positive_value = ncchar('downward flux, heating');
nw{'swrad'}.negative_value = ncchar('upward flux, cooling');
nw{'swrad'}.field = ncchar('swrad, scalar, series');
nw{'swrad'}.coordinates = ncchar('lon lat');
nw{'swrad'}.time = ncchar('swrad_time');
nw{'swrad'}.long_name = 'solar shortwave radiation';
nw{'swrad'}.units = 'Watts meter-2';
nw{'swrad'}.positive_value = 'downward flux, heating';
nw{'swrad'}.negative_value = 'upward flux, cooling';
nw{'swrad'}.field = 'swrad, scalar, series';
nw{'swrad'}.coordinates = 'lon lat';
nw{'swrad'}.time = 'swrad_time';
 
nw{'lwrad_time'} = ncdouble('lwrad_time');
nw{'lwrad_time'}.long_name = ncchar('lwrad_time');
nw{'lwrad_time'}.units = ncchar('days');
nw{'lwrad_time'}.field = ncchar('lwrad_time, scalar, series');
nw{'lwrad_time'}.long_name = 'lwrad_time';
nw{'lwrad_time'}.units = 'days';
nw{'lwrad_time'}.field = 'lwrad_time, scalar, series';
 
nw{'lwrad'} = ncdouble('lwrad_time', 'yrho', 'xrho'); 
nw{'lwrad'}.long_name = ncchar('solar longwave radiation');
nw{'lwrad'}.units = ncchar('Watts meter-2');
nw{'lwrad'}.positive_value = ncchar('downward flux, heating');
nw{'lwrad'}.negative_value = ncchar('upward flux, cooling');
nw{'lwrad'}.field = ncchar('lwrad, scalar, series');
nw{'lwrad'}.coordinates = ncchar('lon lat');
nw{'lwrad'}.time = ncchar('lwrad_time');
nw{'lwrad'}.long_name = 'solar longwave radiation';
nw{'lwrad'}.units = 'Watts meter-2';
nw{'lwrad'}.positive_value = 'downward flux, heating';
nw{'lwrad'}.negative_value = 'upward flux, cooling';
nw{'lwrad'}.field = 'lwrad, scalar, series';
nw{'lwrad'}.coordinates = 'lon lat';
nw{'lwrad'}.time = 'lwrad_time';

result = endef(nw);

%
% Create global attributes
%
nw.title = ncchar(title);
nw.title = title;
nw.date = ncchar(date);
nw.date = date;
nw.grd_file = ncchar(grdname);
nw.grd_file = grdname;
nw.type = ncchar('ROMS heat flux bulk forcing file');
nw.type = 'ROMS heat flux bulk forcing file';

%
% Write time variables
%
for tndx=1:length(bulkt)
   if mod(tndx,20)==0
     disp(['Time Step Bulk: ',num2str(tndx),' of ',num2str(length(bulkt))])
   end
  nw{'bulk_time'}(tndx) = bulkt(tndx);
  nw{'time'}(tndx) = bulkt(tndx);
  nw{'wind_time'}(tndx) = bulkt(tndx);
  nw{'Pair_time'} (tndx) = bulkt(tndx);
  nw{'Tair_time'} (tndx) = bulkt(tndx);
  nw{'Qair_time'} (tndx) = bulkt(tndx);
  nw{'rain_time'} (tndx) = bulkt(tndx);
  nw{'swrad_time'} (tndx) = bulkt(tndx);
  nw{'lwrad_time'}(tndx) = bulkt(tndx);
  
end
close(nw);
