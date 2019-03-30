function [sms_time,sustr,svstr]=get_ww3_sms(ww3_dir,grdname,Y,M,varname,...
    lonmin,lonmax,latmin,latmax,interp_method,Roa,Yorig,ito)

%***************************************************************
% 获取rho点处ww3_windstress
% ww3_dir 包含taw、two和ust三个文件的目录
% grdname 地形网格
% varname 'ta' or 'toc'
% ito 0 表示整月，-2此月最后两天，2此月前两天
%***************************************************************
% Process time (here in days)
%
%WW3 文件分为三部分
% taw two ust

yymm=[num2str(Y),num2str(M,'%02d')];
yy=num2str(Y);
taw_name=fullfile(ww3_dir,yy,'taw',['ww3.',yymm,'_taw.nc']);
two_name=fullfile(ww3_dir,yy,'two',['ww3.',yymm,'_two.nc']);
ust_name=fullfile(ww3_dir,yy,'ust',['ww3.',yymm,'_ust.nc']);

nc=netcdf(taw_name);
sms_time=nc{'time'}(:);% since 1990 01 01
sms_time=sms_time+datenum('1990','yyyy')-datenum(num2str(Yorig),'yyyy');
disp(['Use this land file :',char(taw_name)]);
lon=nc{'longitude'}(:);
lat=nc{'latitude'}(:);
close(nc);
% 获取ww3区域
[Nlon,Nlat,lon1,lat1]=cutarea(lon,lat,lonmin,lonmax,latmin,latmax);
[lon1,lat1]=meshgrid(lon1,lat1);

% Get the model grid
disp(' ')
nc=netcdf(grdname);
Lp=length(nc('xi_rho'));
Mp=length(nc('eta_rho'));
lon=nc{'lon_rho'}(:);
lat=nc{'lat_rho'}(:);
angle=nc{'angle'}(:);
close(nc);

Nx1=Nlon(1);
Ny1=Nlat(1);
Nstepx=length(Nlon);
Nstepy=length(Nlat);
% 判断读取那些数据
if ito ==0
    ax=1;
    dx=Inf;
elseif ito <0
    ax=length(sms_time)+ito*8+1;%一天有8条数据
    dx=-ito*8;
    sms_time=sms_time(ax:end);
elseif ito >0
    ax=1;
    dx=ito*8;
    sms_time=sms_time(1:dx);
end
        
switch varname
    case 'toc'
        utaw=ncread(taw_name,'utaw',[Nx1,Ny1,ax],[Nstepx Nstepy dx]);
        vtaw=ncread(taw_name,'vtaw',[Nx1,Ny1,ax],[Nstepx Nstepy dx]);
        utwo=ncread(two_name,'utwo',[Nx1,Ny1,ax],[Nstepx Nstepy dx]);
        vtwo=ncread(two_name,'vtwo',[Nx1,Ny1,ax],[Nstepx Nstepy dx]);
        uust=ncread(ust_name,'uust',[Nx1,Ny1,ax],[Nstepx Nstepy dx]);
        vust=ncread(ust_name,'vust',[Nx1,Ny1,ax],[Nstepx Nstepy dx]);
        rho_air = 1.22;     % air density (when required as constant) [kg/m^3]
        rho_sea=1.025e3;
        uta=uust.*abs(uust)*rho_air;
        vta=vust.*abs(vust)*rho_air;
        utoc=uta-utaw*rho_sea+utwo*rho_sea;
        vtoc=vta-vtaw*rho_sea+vtwo*rho_sea;        
        uwnd=utoc;
        vwnd=vtoc;
    case 'tar'
        uust=ncread(ust_name,'uust',[Nx1,Ny1,ax],[Nstepx Nstepy dx]);
        vust=ncread(ust_name,'vust',[Nx1,Ny1,ax],[Nstepx Nstepy dx]);
        rho_air = 1.22;     % air density (when required as constant) [kg/m^3]
        uta=uust.*abs(uust)*rho_air;
        vta=vust.*abs(vust)*rho_air;
        uwnd=uta;
        vwnd=vta;
end
mask=double(uust(:,:,1)~=-32767);
mask(mask==0)=NaN;
time_step=size(uust,3);
uwnd1=[];vwnd1=[];sustr=[];svstr=[];
uwnd0=[];vwnd0=[];
for i=1:time_step
    uwnd0(:,:,i)=get_missing_val(lon1,lat1,mask'.*uwnd(:,:,i)',nan,Roa,nan);
    uwnd1(:,:,i)=interp2(lon1,lat1,uwnd0(:,:,i),lon,lat,interp_method);
    
    vwnd0(:,:,i)=get_missing_val(lon1,lat1,mask'.*vwnd(:,:,i)',nan,Roa,nan);
    vwnd1(:,:,i)=interp2(lon1,lat1,vwnd0(:,:,i),lon,lat,interp_method);
    % Compute the stress
    sustr(:,:,i)=uwnd1(:,:,i);
    svstr(:,:,i)=vwnd1(:,:,i);
    %    
end
sustr=permute(sustr,[2 1 3]);
svstr=permute(svstr,[2 1 3]);
