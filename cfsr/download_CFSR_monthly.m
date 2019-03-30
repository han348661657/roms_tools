clear;clc;
Ymin=2006;
Ymax=2006;
Mmin=1;
Mmax=1;
Input_dir='../Orig/';
Output_dir='../Out/';
Yorig=2000;

nc = netcdf('../ECS_grd.nc', 'nowrite');
lon_rho=nc{'lon_rho'}(:);
lat_rho=nc{'lat_rho'}(:);
close(nc)
xi=lon_rho(1,:);
eta=lat_rho(:,1);

nc = netcdf('../Orig/tmp2m.cdas1.201304.grb2.nc', 'nowrite');
glat=nc{'lat'}(:);
glon=nc{'lon'}(:);
close(nc)
index_xi=find(glon>min(xi)-1 & glon<max(xi)+1 );
index_eta=find(glat>min(eta)-1 & glat<max(eta)+1);


  vnames={'Temperature_height_above_ground' ...      % 2 m temp. [k]
         'Downward_Long-Wave_Rad_Flux' ...   % surface downward long wave flux [w/m^2]
         'Upward_Long-Wave_Rad_Flux'   ...   % surface upward long wave flux [w/m^2]
         'Downward_Short-Wave_Rad_Flux' ...   % surface downward solar radiation flux [w/m^2]
         'Upward_Short-Wave_Rad_Flux' ...   % surface upward solar radiation flux [w/m^2]
         'Precipitation_rate' ...   % surface precipitation rate [kg/m^2/s]
         'U-component_of_wind' ...    % 10 m u wind [m/s]
         'V-component_of_wind' ...    % 10 m v wind [m/s]
         'Specific_humidity' ...      % 2 m specific humidity [kg/kg]
         'Pressure_mean_seal_level'};      % surface air pressure [bar]
%
% Global loop on variable names
%
for k=1:length(vnames)
% Loop on the years
%   
    vname=vnames{k};
    
    if k==10  
       nc = netcdf('../Orig/prmsl.cdas1.201304.grb2.nc', 'nowrite');
       glat=nc{'lat'}(:);
       glon=nc{'lon'}(:);
       close(nc)
       index_xi=find(glon>min(xi)-1 & glon<max(xi)+1 );
       index_eta=find(glat>min(eta)-1 & glat<max(eta)+1); 
    end
    
    
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
             [var,lon,lat,dtime]=get_filename_CFSR_monthly(Input_dir,Y,M,k,index_eta,index_xi);
             
             
             
             
             time=dtime/24+datenum(Y,M,1,0,0,0)-datenum(Yorig,1,1,0,0,0); 
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
