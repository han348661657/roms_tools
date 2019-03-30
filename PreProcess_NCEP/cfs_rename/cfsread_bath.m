% nctoolbox ��ȡgrib��ʽ������
file='F:\2.NCEP\date\cdas1.t00z.sfluxgrbf00.grib2';
nc=ncgeodataset(file);
% �г�����
nc.variables
lon=nc.data('lon');
lat=nc.data('lat');
%��Ҫ�ı���
vnames={'Land_cover_1land_2sea' ...    % surface land-sea mask [1=land; 0=sea]
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
  temp=squeeze(double(nc.data('Temperature_height_above_ground')));%ȥ����ά�ȣ���4ά��Ϊ2ά
  % �鿴�ļ�������
  time=nc.attribute('time','units');%Hour since 2014-01-01T00:00:00Z
  
  
  
  
  