clear;clc;
%===========================================
%用户定义参数
Ymin=2005;
Ymax=2005;
Mmin=1;
Mmax=1;
NCEP_dir='F:\2.NCEP\data\2005\';
Output_dir='..\..\Out\';
Yorig=2000;
%最好设置的比make_grid大1度
lonmin =   309;   % Minimum longitude [degree east]
lonmax =  351;   % Maximum longitude [degree east]
latmin = 44;   % Minimum latitudeF  [degree north]
latmax = 66;   % Maximum latitude  [degree north]
%==================================================================
%获取关注区域
% setup_nctoolbox %将NCTOOLbox添加到matlab路径

nc1 = ncdataset('flxf00.gdas.2005010100.grb2');
glat=nc1.data('lat');
glon=nc1.data('lon');

index_xi=find(glon>lonmin-1 & glon<lonmax+1 );
index_eta=find(glat>latmin-1 & glat<latmax+1);
lon=glon(index_xi);
lon=double(lon);
lat=glat(index_eta);
lat=double(lat);
lat=flipud(lat);
% ======================================================
% make_mask
mask=squeeze(nc1.data('Land_cover_0__sea_1__land_surface'));
time=datenum(Ymin,Mmin,1,0,0,0)-datenum(Yorig,1,1);
var=mask(index_eta,index_xi);
var=double(var);
var=flipud(var);
vname='Land_cover_1land_2sea';
write_NCEP([Output_dir,vname,'.nc'],...
	      vname,lon,lat,time,var,Yorig)

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
     disp(['=========================='])
     disp(['Proccssing :',vname])
    
    for Y=Ymin:Ymax
      disp(['Processing year: ',num2str(Y)])
      disp('==========================')
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
   stryear=num2str(Y);
   strmon=num2str(M,'%02d');
   Input_dir=[NCEP_dir,stryear,strmon,'\'];
   t1ndx=0;
     for D=1:1:nmax      
         for T=0:6:18
             str_date=[stryear,strmon,num2str(D,'%02d'),'T',num2str(T,'%02d')];
             disp(['Processing varname:',vname]);
             disp(['Processing time:====',str_date,'===='])
             t1ndx=1+t1ndx;
             var0=get_filename_CFSR_daily(Input_dir,vname,Y,M,D,T,index_xi,index_eta);
             var(t1ndx,:,:)=var0;
             time(t1ndx)=datenum(Y,M,D,T,0,0)-datenum(Yorig,1,1,0,0,0); 
         end %T
     end %D
%
%
% Write it in a file
%
     fname=[Output_dir,vname,'_Y',num2str(Y),'M',num2str(M),'.nc'];
      write_NCEP(fname,vname,lon,lat,time,var,Yorig)
      end % end loop month
    end % end loop year
end % loop k
%
return
