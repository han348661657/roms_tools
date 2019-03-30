clear;clc;
Ymin=2015;
Ymax=2015;
Mmin=1;
Mmax=1;
Input_dir='J:\NCEP/';
Output_dir='./Out/';
Yorig=2000;


nc = netcdf('E:\work\ģʽѧϰ\study\Roms_tools\Run\ROMS_FILES\Pacific/roms_grd.nc', 'nowrite');
lon_rho=nc{'lon_rho'}(:);
lat_rho=nc{'lat_rho'}(:);
close(nc)
xi=lon_rho(1,:);
eta=lat_rho(:,1);

setup_nctoolbox
nc1 = ncgeodataset('J:\NCEP\201501\cfs_2015-01-01T00.grib2');
glat=nc1.data('lat');
glon=nc1.data('lon');
close(nc1)
% nc = netcdf('cfs_2015-01-01T00.grib2', 'nowrite');
% glat=nc{'lat'}(:);
% glon=nc{'lon'}(:);
% close(nc)

index_xi=find(glon>min(xi)-1 & glon<max(xi)+1 );
index_eta=find(glat>min(eta)-1 & glat<max(eta)+1);


%   vnames={'Temperature_height_above_ground' ...      % 2 m temp. [k]
%          'Downward_Long-Wave_Rad_Flux' ...   % surface downward long wave flux [w/m^2]
%          'Upward_Long-Wave_Rad_Flux'   ...   % surface upward long wave flux [w/m^2]
%          'Downward_Short-Wave_Rad_Flux' ...   % surface downward solar radiation flux [w/m^2]
%          'Upward_Short-Wave_Rad_Flux' ...   % surface upward solar radiation flux [w/m^2]
%          'Precipitation_rate' ...   % surface precipitation rate [kg/m^2/s]
%          'U-component_of_wind' ...    % 10 m u wind [m/s]
%          'V-component_of_wind' ...    % 10 m v wind [m/s]
%          'Specific_humidity'};       % 2 m specific humidity [kg/kg]

% ================================================================
  vnames={'Land_cover_0__sea_1__land_surface' ...    % surface land-sea mask [1=land; 0=sea]
      'Temperature_height_above_ground' ...      % 2 m temp. [k]
      'Downward_Long-Wave_Radp_Flux_surface' ...   % surface downward long wave flux [w/m^2]
      'Upward_Long-Wave_Radp_Flux_surface'   ...   % surface upward long wave flux [w/m^2]
      'Temperature_surface' ...     % surface temp. [k]
      'Downward_Short-Wave_Radiation_Flux_surface' ...   % surface downward solar radiation flux [w/m^2]
      'Upward_Short-Wave_Radiation_Flux_surface' ...   % surface upward solar radiation flux [w/m^2]
      'Precipitation_rate_surface_0_Hour_Average' ...   % surface precipitation rate [kg/m^2/s]
      'u-component_of_wind_height_above_ground' ...    % 10 m u wind [m/s]
      'v-component_of_wind_height_above_ground' ...    % 10 m v wind [m/s]
      'Specific_humidity_height_above_ground'};       % 2 m specific humidity [kg/kg]
%
% Global loop on variable names
%
for k=1:length(vnames)
% Loop on the years
%   
    vname=vnames{k};
    
     disp(['Proccssing :',vname])
    
    for Y=Ymin:Ymax
      disp(['=========================='])
      disp(['Processing year: ',num2str(Y)])
      disp(['=========================='])
%
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
        disp(['  Processing month: ',num2str(M)])
        
% Get the number of days in the month
%      
   nmax=daysinmonth(Y,M); 
   var=[];
   time=[];
   
     for D=1:1:nmax        
             t1ndx=1+(D-1)*4;
             t2ndx=4+(D-1)*4; 
             [var0,lon,lat]=get_filename_CFSR_daily(Input_dir,Y,M,D,k,index_xi,index_eta);
             var(t1ndx:t2ndx,:,:)=var0;
             time(t1ndx:t2ndx)=datenum(Y,M,D,0:6:18,0,0)-datenum(Yorig,1,1,0,0,0); 
      end
%
%
% Write it in a file
%
      write_NCEP([Output_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc'],...
	        vname,lon,lat,time,var,Yorig)
      end % end loop month
    end % end loop year
end % loop k
%
return
