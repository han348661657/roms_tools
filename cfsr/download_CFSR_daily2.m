clear;clc;
Ymin=2014;
Ymax=2015;
Mmin=1;
Mmax=12;
Input_dir='../Orig/';
Output_dir='../Out/';
Yorig=2000;


nc = netcdf('../ECS_grd.nc', 'nowrite');
lon_rho=nc{'lon_rho'}(:);
lat_rho=nc{'lat_rho'}(:);
close(nc)
xi=lon_rho(1,:);
eta=lat_rho(:,1);

nc = netcdf('../Orig/tmp2m.20140901.sfluxgrbf.grb2.nc', 'nowrite');
glat=nc{'lat'}(:);
glon=nc{'lon'}(:);
close(nc)
index_xi=find(glon>min(xi)-1 & glon<max(xi)+1 );
index_eta=find(glat>min(eta)-1 & glat<max(eta)+1);

nc2 = netcdf('../Orig/tmp2m.cdas1.201304.grb2.nc', 'nowrite');
glat2=nc2{'lat'}(:);
glon2=nc2{'lon'}(:);
close(nc2)
index_xi2=find(glon2>min(xi)-1 & glon2<max(xi)+1 );
index_eta2=find(glat2>min(eta)-1 & glat2<max(eta)+1);
gglo=glon2(index_xi2);
ggla=glat2(index_eta2);

[glo,gla]=meshgrid(gglo,ggla);

  vnames={'Temperature_height_above_ground' ...      % 2 m temp. [k]
         'Downward_Long-Wave_Rad_Flux' ...   % surface downward long wave flux [w/m^2]
         'Upward_Long-Wave_Rad_Flux'   ...   % surface upward long wave flux [w/m^2]
         'Downward_Short-Wave_Rad_Flux' ...   % surface downward solar radiation flux [w/m^2]
         'Upward_Short-Wave_Rad_Flux' ...   % surface upward solar radiation flux [w/m^2]
         'Precipitation_rate' ...   % surface precipitation rate [kg/m^2/s]
         'U-component_of_wind' ...    % 10 m u wind [m/s]
         'V-component_of_wind' ...    % 10 m v wind [m/s]
         'Specific_humidity'...
          'Pressure_mean_seal_level'};       % 2 m specific humidity [kg/kg]
%
% Global loop on variable names
%  k=10
for k=1:length(vnames)
% Loop on the years
%  
  if k==10  
       nc = netcdf('../Orig/prmsl.20110401.pgrbh.grb2.nc', 'nowrite');
       glat=nc{'lat'}(:);
       glon=nc{'lon'}(:);
       close(nc)
       index_xi=find(glon>min(xi)-2 & glon<max(xi)+2 );
       index_eta=find(glat>min(eta)-2 & glat<max(eta)+2); 
    end
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
   clear vvar0 svar nlat nlon 

     for D=1:1:nmax        
             t1ndx=1+(D-1)*4;
             t2ndx=4+(D-1)*4; 
             [var0,lon,lat]=get_filename_CFSR_daily2(Input_dir,Y,M,D,k,index_xi,index_eta);
             var(t1ndx:t2ndx,:,:)=var0;
             time(t1ndx:t2ndx)=datenum(Y,M,D,0:6:18,0,0)-datenum(Yorig,1,1,0,0,0); 
      end
%
%

if k==10
                nlat(1:5)=[22.5:0.5:24.5];
             nlat(6:42)=lat;
        svar(:,1:5,:)=var(:,5:-1:1,:);
        svar(:,6:42,:)=var;
  for nt=1:length(time)
     vvar0(nt,:,:)=interp2(nlat,lon,squeeze(svar(nt,:,:))',gla,glo,'nearest');
  end             
else
        nl=lat(2)-lat(1);
        nr=lat(1);
        nlat(1:15)=[nr-15*nl,nr-14*nl,nr-13*nl,nr-12*nl,nr-11*nl,nr-10*nl,nr-9*nl,nr-8*nl,nr-7*nl,nr-6*nl,nr-5*nl,nr-4*nl,nr-3*nl,nr-2*nl,nr-1*nl];
        nlat(16:100)=lat;
        svar(:,1:15,:)=var(:,15:-1:1,:);
        svar(:,16:100,:)=var;
for nt=1:length(time)
     vvar0(nt,:,:)=interp2(nlat,lon,squeeze(svar(nt,:,:))',gla,glo,'nearest');
end
end



% Write it in a file
%
      write_NCEP([Output_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc'],...
	        vname,gglo,ggla,time,vvar0,Yorig)
      end % end loop month
    end % end loop year
end % loop k
%
return
