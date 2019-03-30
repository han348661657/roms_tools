clear;clc;
Ymin=2011;
Ymax=2011;
Mmin=1;
Mmax=3;
Input_dir='../Orig/';
Output_dir='../Out/';
Yorig=2000;

nc = netcdf('../ECS_grd.nc', 'nowrite');
lon_rho=nc{'lon_rho'}(:);
lat_rho=nc{'lat_rho'}(:);
close(nc)
xi=lon_rho(1,:);
eta=lat_rho(:,1);

nc = netcdf('../Orig/tmp2m.gdas.20060101-20060105.grb2.nc', 'nowrite');
glat=nc{'lat'}(:);
glon=nc{'lon'}(:);
close(nc)
index_xi=find(glon>min(xi)-2 & glon<max(xi)+2 );
index_eta=find(glat>min(eta)-2 & glat<max(eta)+2);

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
         'Pressure_mean_seal_level' ...   % surface precipitation rate [kg/m^2/s]
         'U-component_of_wind' ...    % 10 m u wind [m/s]
         'V-component_of_wind' ...    % 10 m v wind [m/s]
         'Specific_humidity'  ...    % 2 m specific humidity [kg/kg]
         'Precipitation_rate'};     % surface air pressure [bar]
%
 %        'Precipitation_rate' ...   % surface precipitation rate [kg/m^2/s]
% Global loop on variable names
%
% k=4
for k=1:length(vnames)
% Loop on the years
%
    vname=vnames{k};
    
    if k==10  
       nc = netcdf('../Orig/prate.gdas.20110101-20110105.grb2.nc', 'nowrite');
       glat=nc{'lat'}(:);
       glon=nc{'lon'}(:);
       close(nc)
       index_xi=find(glon>min(xi)-2 & glon<max(xi)+2 );
       index_eta=find(glat>min(eta)-2 & glat<max(eta)+2); 
    end
    
     if k==2 | k==3 | k==4 | k==5   
       nc = netcdf('../Orig/radiation.gdas.20060101-20060105.grb2.nc', 'nowrite');
       glat=nc{'lat'}(:);
       glon=nc{'lon'}(:);
      close(nc)
      index_xi=find(glon>min(xi)-2 & glon<max(xi)+2 );
      index_eta=find(glat>min(eta)-2 & glat<max(eta)+2); 
    end
    if k==6 
       nc = netcdf('../Orig/prmsl.gdas.20060101-20060105.grb2.nc', 'nowrite');
       glat=nc{'lat'}(:);
       glon=nc{'lon'}(:);
      close(nc)
      index_xi=find(glon>min(xi)-2 & glon<max(xi)+2 );
      index_eta=find(glat>min(eta)-2 & glat<max(eta)+2); 
    end  
    
        if k==7 | k==8
       nc = netcdf('../Orig/wnd10m.gdas.20060101-20060105.grb2.nc', 'nowrite');
       glat=nc{'lat'}(:);
       glon=nc{'lon'}(:);
      close(nc)
      index_xi=find(glon>min(xi)-2 & glon<max(xi)+2 );
      index_eta=find(glat>min(eta)-2 & glat<max(eta)+2); 
        end  
    
            if k==9 
       nc = netcdf('../Orig/q2m.gdas.20060101-20060105.grb2.nc', 'nowrite');
       glat=nc{'lat'}(:);
       glon=nc{'lon'}(:);
      close(nc)
      index_xi=find(glon>min(xi)-2 & glon<max(xi)+2 );
      index_eta=find(glat>min(eta)-2 & glat<max(eta)+2); 
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
   nmax=daysinmonth(Y,M); 
   var=[];
   time=[];
   
for n=1:6
             t1ndx=1+(n-1)*20;
             t2ndx=20+(n-1)*20;
             t3ndx=nmax*4;
                [var0,lon,lat,dtime]=get_filename_CFSR_5days(Input_dir,Y,M,k,index_eta,index_xi,n);

             if n<6
                 var(t1ndx:t2ndx,:,:)=var0;
             else
                 var(t1ndx:t3ndx,:,:)=var0;
             end

end
               time1=[datenum(Y,M,1,0,0,0)-1:1/4:datenum(Y,M,nmax,0,0,0)]-datenum(Yorig,1,1,0,0,0); 
               time=time1(2:end);
%
% Write it in a file

%
clear vvar0 svar nlat nlon 

     if k==2 | k==3 | k==4 | k==5   
%   for nt=1:length(time)
%      vvar0(nt,:,:)=griddata(lat,lon,squeeze(var(nt,:,:))',gla,glo,'nearest');
%   end         
        
         
         
        nl=lat(2)-lat(1);
        nr=lat(1);
        nlat(1:8)=[nr-8*nl,nr-7*nl,nr-6*nl,nr-5*nl,nr-4*nl,nr-3*nl,nr-2*nl,nr-1*nl];
        nlat(9:67)=lat;
        svar(:,1:8,:)=var(:,8:-1:1,:);
        svar(:,9:67,:)=var;
for nt=1:length(time)
     vvar0(nt,:,:)=interp2(nlat,lon,squeeze(svar(nt,:,:))',gla,glo,'nearest');
end
     elseif k==6
             nlat(1:5)=[22.5:0.5:24.5];
             nlat(6:42)=lat;
        svar(:,1:5,:)=var(:,5:-1:1,:);
        svar(:,6:42,:)=var;
  for nt=1:length(time)
     vvar0(nt,:,:)=interp2(nlat,lon,squeeze(svar(nt,:,:))',gla,glo,'nearest');
end             
     else
         
for nt=1:length(time)
    vvar0(nt,:,:)=interp2(lat,lon,squeeze(var(nt,:,:))',gla,glo);
end
     end


write_NCEP([Output_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc'],...
	        vname,gglo,ggla,time,vvar0,Yorig)
      end % end loop month
    end % end loop year
end % loop k
%
return
