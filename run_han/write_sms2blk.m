function write_sms2blk(sms_time,sustr,svstr,blk_name,grd_name)
% **********************************************
% ��ww3�еķ�Ӧ��д��blk.nc�ļ�
%
% д��ͷ�ļ�
% 1.�޸ķ�Ӧ��ͷ�ļ� 
sustr_info=ncinfo(blk_name,'Uwind');
svstr_info=ncinfo(blk_name,'Vwind');

% �޸ı�������
sustr_info.Name='sustr';
svstr_info.Name='svstr';

% ������ά�ȸ�Ϊsms_time
sustr_info.Dimensions(3).Name='sms_time';
sustr_info.Dimensions(3).Length=length(sms_time);
svstr_info.Dimensions(3).Name='sms_time';
svstr_info.Dimensions(3).Length=length(sms_time);

% size ʱ��ά
sustr_info.Size(3)=length(sms_time);
svstr_info.Size(3)=length(sms_time);

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
sms_info=ncinfo(blk_name,'wind_time');
sms_info.Name='sms_time';
sms_info.Attributes(1).Value='wind stress time';
sms_info.Attributes(3).Value='sustr_time, scalar, series';
sms_info.Size=length(sms_time);
sms_info.Dimensions.Length=length(sms_time);
sms_info.Dimensions.Name='sms_time';

sms_info.Attributes(3).Name='field';
sms_info.Attributes(3).Value='sustr_time, scalar, series';
sms_info.Format='netcdf4_classic';

% 3. ����������д��blk�ļ�
disp(['writing sustr info into ', blk_name])
ncwriteschema(blk_name,sms_info);
ncwriteschema(blk_name,sustr_info);
ncwriteschema(blk_name,svstr_info);

% ��ȡ����
disp(['writing sustr data into ', blk_name])
lon=ncread(grd_name,'lon_rho');
lat=ncread(grd_name,'lat_rho');


% д��nc�ļ�
ncwrite(blk_name,'sms_time',sms_time)
ncwrite(blk_name,'sustr',sustr)
ncwrite(blk_name,'svstr',svstr)
ncwrite(blk_name,'lon',lon)
ncwrite(blk_name,'lat',lat)