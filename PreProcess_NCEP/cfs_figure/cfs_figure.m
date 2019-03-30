%画出CFSV2数据图像
vnames={'Land_cover_0__sea_1__land_surface' ...    %(1) surface land-sea mask [1=land; 0=sea]
      'Temperature_height_above_ground' ...      %(2) 2 m temp. [k]
      'Downward_Long-Wave_Radp_Flux_surface' ...   %(3) surface downward long wave flux [w/m^2]
      'Upward_Long-Wave_Radp_Flux_surface'   ...   %(4) surface upward long wave flux [w/m^2]
      'Temperature_surface' ...                      %(5)  surface temp. [k]
      'Downward_Short-Wave_Radiation_Flux_surface' ...   %(6) surface downward solar radiation flux [w/m^2]
      'Upward_Short-Wave_Radiation_Flux_surface' ...   %(7) surface upward solar radiation flux [w/m^2]
      'Precipitation_rate_surface_0_Hour_Average' ...   %(8) surface precipitation rate [kg/m^2/s]
      'u-component_of_wind_height_above_ground' ...    %(9) 10 m u wind [m/s]
      'v-component_of_wind_height_above_ground' ...    %(10) 10 m v wind [m/s]
      'Specific_humidity_height_above_ground'};       %(11) 2 m specific humidity [kg/kg]
%===================================
%用户自定义参数
varname=vnames{5};
root_dir='../';
Y=2014;
M=10;
D=9;
T=00;%0,6,12,18
north=30; %最大31;
south=10; %最小9;
west=125; %最小104
east=155; %最大156

  
%=======================================
%选择画图区域
% setup_nctoolbox %将NCTOOLbox添加到matlab路径
nc1 = ncgeodataset('F:\NCEP\201410\cfs_2014-10-01T06.grib2');
lat=nc1.data('lat');
lat=flip(lat);
lon=nc1.data('lon');
%获取陆地mask
land_ocean=squeeze(nc1.data('Land_cover_0__sea_1__land_surface'));
land_ocean=flipud(land_ocean);

[~,N.up]=min(abs(north-lat));
[~,N.down]=min(abs(south-lat));
[~,N.left]=min(abs(west-lon));
[~,N.right]=min(abs(east-lon));
num1=N.right-N.left+1;
num2=N.up-N.down+1;
lon1=double(lon(N.left:N.right));
lat1=double(lat(N.down:N.up));
land_ocean1=land_ocean(N.down:N.up,N.left:N.right);
mask_land=land_ocean1==1;
%========================================
%读取数据
file=(['cfs_',num2str(Y),'-',num2str(M,'%02d'),'-',...
    num2str(D,'%02d'),'T',num2str(T,'%02d'),'.grib2']);
filename=([root_dir,num2str(Y),num2str(M,'%02d'),'/',file]);
nc=ncgeodataset(filename);
var=squeeze(nc.data(varname));
var=flipud(var);
var1=var(N.down:N.up,N.left:N.right);%选取海表面值
var1(mask_land)=nan;%陆地像元设为nan
var1=double(var1);
if strcmpi(varname,'Temperature_surface');
    var1=var1-273.15;
end

%================================================================
% 画图
m_proj('Equidistant Cylindrical','lon',[west east],'lat',[south north]);
[Plg,Plt]=meshgrid(lon1,lat1);
figure
m_pcolor(Plg,Plt,var1),shading flat;
colorbar;
% set(gca, 'CLim', [-4 1]);
m_grid('linewi',1.2,'linest','none','tickdir','in','fontname','Times New Roman','Fontsize',12);
m_gshhs_l('save','gumby');% m_gshhs_h 高分辨率，但运行速度慢，i 中等分辨率，l低分辨率
m_usercoast('gumby','patch',[0.8 0.8 0.8]);
warning off
title(['\',varname,'-',num2str(Y),num2str(M,'%02d'),num2str(D,'%02d')]);


