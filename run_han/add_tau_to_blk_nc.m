% nc�ļ�λ��
clearvars -global
close all
romstools_param

% file_his='roms_his_Y2004M3.nc';
file_tar='H:\ww3\roms_in\roms_frc_WW3_ta_Y2005M1.nc';
file_blk='ROMS_FILES/roms_blk_CFSR_Y2005M1.nc';
file_grd='ROMS_FILES/roms_grd.nc';
file_new='roms_ww3.nc';
% disp(['copying ', file_blk,' to ',file_new])
% copyfile(file_blk,file_new);
%% **********************************************
% д��ͷ�ļ�
% 1.�޸ķ�Ӧ��ͷ�ļ� 
tau_info=ncinfo(file_tar,'sustr'); 
sustr_info=ncinfo(file_new,'Uwind');
svstr_info=ncinfo(file_new,'Vwind');

% �޸ı�������
sustr_info.Name='sustr';
svstr_info.Name='svstr';

% ������ά�ȸ�Ϊsms_time
sustr_info.Dimensions(3).Name='sms_time';
sustr_info.Dimensions(3).Length=tau_info.Dimensions(3).Length;
svstr_info.Dimensions(3).Name='sms_time';
svstr_info.Dimensions(3).Length=tau_info.Dimensions(3).Length;

% size ʱ��ά
sustr_info.Size(3)=tau_info.Size(3);
svstr_info.Size(3)=tau_info.Size(3);

% Attributes
sustr_info.Attributes(1).Value='surface u-momentum stress';
sustr_info.Attributes(2).Value='newton meter-2';
sustr_info.Attributes(3).Value='surface u-momentum stress, scalar, series';
sustr_info.Attributes(5).Value='sms_time';

svstr_info.Attributes(1).Value='surface v-momentum stress';
svstr_info.Attributes(2).Value='newton meter-2';
svstr_info.Attributes(3).Value='surface v-momentum stress, scalar, series';
svstr_info.Attributes(5).Value='sms_time';

% 2. �޸�sms_timeͷ�ļ�
sms_info=ncinfo(file_tar,'sms_time'); 
wnd_info=ncinfo(file_new,'wind_time');

%�޸� sms_time ά��
% sms_info.Size=wnd_info.Size;
% sms_info.Dimensions.Length=wnd_info.Dimensions.Length;

sms_info.Attributes(3).Name='field';
sms_info.Attributes(3).Value='sustr_time, scalar, series';
sms_info.Format='netcdf4_classic';

% 3. ����������д��blk�ļ�
disp(['writing sustr info into ', file_new])
ncwriteschema(file_new,sms_info);
ncwriteschema(file_new,sustr_info);
ncwriteschema(file_new,svstr_info);

%% ��ȡ����
disp(['writing sustr into ', file_new])
sustr=ncread(file_tar,'sustr');
svstr=ncread(file_tar,'svstr');
sustr=u2rho_3d(sustr);
svstr=v2rho_3d(svstr);
sms_time=ncread(file_tar,'sms_time');
lon=ncread(file_grd,'lon_rho');
lat=ncread(file_grd,'lat_rho');

% д��nc�ļ�

ncwrite(file_new,'sms_time',sms_time)
ncwrite(file_new,'sustr',sustr)
ncwrite(file_new,'svstr',svstr)
ncwrite(file_new,'lon',lon)
ncwrite(file_new,'lat',lat)

