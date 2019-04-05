clear;clc;
%生成ww3 case 中制作forc.nc所需的CFSR中间文件
%===========================================
%用户定义参数
Ymin=2005;
Ymax=2005;
Mmin=2;
Mmax=6 ;
NCEP_dir='E:\2.NCEP\data\';% 该目录下还有两级子文件夹，YYYY/month/
Output_dir='H:\roms-liu\run_han\ROMS_FILES\CFSR_Equator\';
Yorig=2000;
%最好设置的比make_grid大1度
lonmin =   -180;   % Minimum longitude [degree east]
lonmax =  180;   % Maximum longitude [degree east]
latmin = -66;   % Minimum latitudeF  [degree north]
latmax = -34;   % Maximum latitude  [degree north]
%==================================================================
%获取关注区域

try
    nc1 = ncdataset('flxf00.gdas.2005010100.grb2');
catch
    setup_nctoolbox %将NCTOOLbox添加到matlab路径
    nc1 = ncdataset('flxf00.gdas.2005010100.grb2');
end
glat=nc1.data('lat');
glon=nc1.data('lon');
% index_xi=find(glon>lonmin-1 & glon<lonmax+1 );
% index_eta=find(glat>latmin-1 & glat<latmax+1);
% lon=glon(index_xi);
% lon=double(lon);
% lat=glat(index_eta);
% lat=double(lat);
% lat=flipud(lat);


dl=1;
lonmin=lonmin-dl;
if lonmin<-180
    lonmin=lonmin+dl;
end
lonmax=lonmax+dl;
if lonmax>180
    lonmax=lonmax-dl;
end
latmin=latmin-dl;
latmax=latmax+dl;
%
% Extract a data subgrid
%
Y=glat;
X=glon;
index_eta=find(Y>=latmin & Y<=latmax);
i1=find(X-360>=lonmin & X-360<=lonmax);
i2=find(X>=lonmin & X<=lonmax);
i3=find(X+360>=lonmin & X+360<=lonmax);
if ~isempty(i2)
  x=X(i2);
  index_xi=i2;
else
  x=[];
  index_xi=[];
end
if ~isempty(i1)
  x=cat(1,X(i1)-360,x);
  index_xi=cat(1,i1,index_xi);
end
if ~isempty(i3)
  x=cat(1,x,X(i3)+360);
  index_xi=cat(1,index_xi,i3);
end
y=Y(index_eta);
lat=flipud(double(y));
lon=double(x);









% ======================================================
% make_mask
mask=squeeze(nc1.data('Land_cover_0__sea_1__land_surface'));
time=datenum(Ymin,Mmin,1,0,0,0)-datenum(Yorig,1,1);
var=mask(index_eta,index_xi);
var=double(var);
var=flipud(var);
vname='Land_cover_1land_2sea';
if ~exist(Output_dir,'dir')
    mkdir(Output_dir)
end
write_NCEP([Output_dir,vname,'.nc'],...
	      vname,lon,lat,time,var,Yorig)

% ================================================================
  vnames={'Land_cover_0__sea_1__land_surface' ...    % surface land-sea mask [1=land; 0=sea]
      'Pressure_surface'...
      'Temperature_height_above_ground' ...      % 2 m temp. [k]
      'Downward_Long-Wave_Radp_Flux_surface' ...   % surface downward long wave flux [w/m^2]
      'Upward_Long-Wave_Radp_Flux_surface'   ...   % surface upward long wave flux [w/m^2]
      'Temperature_surface' ...     % surface temp. [k]
      'Downward_Short-Wave_Radiation_Flux_surface' ...   % surface downward solar radiation flux [w/m^2]
      'Upward_Short-Wave_Radiation_Flux_surface' ...   % surface upward solar radiation flux [w/m^2]
      'Precipitation_rate_surface_3_Hour_Average' ...   % surface precipitation rate [kg/m^2/s]
      'u-component_of_wind_height_above_ground' ...    % 10 m u wind [m/s]
      'v-component_of_wind_height_above_ground' ...    % 10 m v wind [m/s]
      'Specific_humidity_height_above_ground'};       % 2 m specific humidity [kg/kg]
%
% Global loop on variable names
%
for k=2:length(vnames)

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
        NCEP_dir1=[NCEP_dir,num2str(Y),'\'];
      for M=mo_min:mo_max
        disp(['  Processing month: ',num2str(M)])
        
% Get the number of days in the month
%      
   nmax=daysinmonth(Y,M); 
   var=[];
   time=[];
   stryear=num2str(Y);
   strmon=num2str(M,'%02d');
   Input_dir=[NCEP_dir1,'flxf09.gdas.',stryear,strmon,'\'];
   t1ndx=0;
     for D=1:1:nmax      
         for T=0:6:18
             str_date=[stryear,strmon,num2str(D,'%02d'),'T',num2str(T,'%02d')];
             disp(['Processing varname:',vname]);
             disp(['Processing time:====',str_date,'===='])
             t1ndx=1+t1ndx;
             var0=get_filename_CFSR_daily_ww3(Input_dir,vname,Y,M,D,T,index_xi,index_eta);
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
