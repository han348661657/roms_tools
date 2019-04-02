% check_input.m
% check roms input files
%% grd
grd="H:\roms-liu\run_han\ROMS_FILES\roms_grd.nc";
h=ncread(grd,'h');
figure;
pcolor(h');shading flat


%% bry
bry='H:\roms-liu\run_han\ROMS_FILES\roms_bry_SODA_Y2005M1.nc';
grd='H:\roms-liu\run_han\ROMS_FILES\roms_grd.nc';
lat_rho=ncread(grd,'lat_rho');
lon_rho=ncread(grd,'lon_rho');

%% clm
clm="H:\roms-liu\run_han\ROMS_FILES\roms_clm_SODA_Y2005M1.nc";
SSH=ncread(clm,'SSH',[1 1 1],[Inf Inf 1]);
figure;
pcolor(SSH');shading flat

h=1;
Temp=ncread(clm,'temp',[1 1 h 1],[Inf Inf 1 1]);
Temp=squeeze(Temp);
figure
pcolor(Temp');shading flat
%% blk
blk='H:\roms-liu\run_han\ROMS_FILES\ww3_toc\roms_blk_CFSR_Y2005M1.nc';
ntimes=1;
Uwind=ncread(blk,'Uwind',[1 1 ntimes],[Inf Inf 1]);
sustr=ncread(blk,'sustr',[1 1 ntimes],[Inf Inf 1]);
Tair=ncread(blk,'Tair',[1 1 ntimes],[Inf Inf 1]);% 'surface air temperature'
Uwind=squeeze(Uwind);
sustr=squeeze(sustr);
Tair=squeeze(Tair);
% pcolor(Uwind');shading flat
figure
pcolor(sustr');shading flat
figure
pcolor(Tair');shading flat

%% CFSR
Temp='H:\roms-liu\run_han\ROMS_FILES\CFSR_Equator\Temperature_height_above_ground_Y2005M1.nc';
ntimes=1;
lonx=ncread(Temp,'lon');
temp_CFSR=ncread(Temp,'Temperature_height_above_ground',[1 1 ntimes],[Inf Inf 1]);
temp_CFSR=squeeze(temp_CFSR);
figure
pcolor(temp_CFSR');shading flat

%% SODA
soda="H:\roms-liu\run_han\ROMS_FILES\SODA_Equator\SODA_Y2005M1.cdf";
ssh=double(ncread(soda,'ssh'));
h=1;
temp=ncread(soda,'temp',[1 1 h 1],[Inf Inf 1 1]);
temp=squeeze(temp);
pcolor(temp');shading flat
figure
pcolor(ssh');shading flat


%% ini 
ini='H:\roms-liu\run_han\ROMS_FILES\roms_ini_SODA_Y2005M1.nc';
h=1;
temp=ncread(ini,'temp',[1 1 h 1],[Inf Inf 1 1]);
temp=squeeze(temp);
pcolor(temp');shading flat
