%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spin-up
% 更改时间，进行spin-up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%start % to be used in batch mode %
clearvars
close all
%%%%%%%%%%%%%%%%%%%%% USERS DEFINED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%
%
% Common parameters
%
romstools_param
%

disp(['==================='])
disp([' Compute time axis '])
disp(['==================='])
if level==0
  nc_suffix='.nc';
else
  nc_suffix=['.nc.',num2str(level)];
  grdname=[grdname,'.',num2str(level)];
end
%
blk_prefix=[blk_prefix,'_CFSR_'];
% Spin-up: (reproduce the first year 'SPIN_Long' times)
% just copy the files for the first year and change the time
%
if SPIN_Long>0
  %
  % Initial file
  %
%   if makeini==1
%     %
%     % Copy the file
%     %
%     ininame=[ini_prefix,'Y',num2str(Ymin),'M',num2str(Mmin),nc_suffix];
%     ininame2=[ini_prefix,'Y',num2str(Ymin-SPIN_Long),'M',num2str(Mmin),nc_suffix];
%     disp(['Create ',ininame2]) 
%     eval(['copyfile ',ininame,' ',ininame2])
%     %
%     % Change the time
%     %
%     nc=netcdf(ininame2,'write');
%     time=nc{'scrum_time'}(:);
%     time=time/(24*3600)+datenum(Yorig,1,1);
%     [y,m,d,h,mi,s]=datevec(time);
%     time=datenum(y-SPIN_Long,m,d,h,mi,s)-datenum(Yorig,1,1);
%     disp(datestr(time+datenum(Yorig,1,1)))
%     nc{'scrum_time'}(:)=time*(24*3600);
%     nc{'ocean_time'}(:)=time*(24*3600);
%     close(nc)
%   end
  %
  M=Mmin-1;
  Y=Ymin-SPIN_Long;
  for month=1:12*SPIN_Long
    M=M+1;
    if M==13
      M=1; 
      Y=Y+1;
    end
    %
    % Climatology files
    %
    if makeclim==1
      %
      % Copy the file
      %
      clmname=[clm_prefix,'Y',num2str(Ymin),'M',num2str(M),nc_suffix];
      clmname2=[clm_prefix,'Y',num2str(Y),'M',num2str(M),nc_suffix];
      disp(['Create ',clmname2]) 
      eval(['copyfile ',clmname,' ',clmname2]) 
      %
      % Change the time
      %
      nc=netcdf(clmname2,'write');
      time=nc{'tclm_time'}(:)+datenum(Yorig,1,1);
      [y,m,d,h,mi,s]=datevec(time);
      dy=Ymin-Y;
      y=y-dy;
      time=datenum(y,m,d,h,mi,s)-datenum(Yorig,1,1);
      disp(datestr(time+datenum(Yorig,1,1)))
      nc{'tclm_time'}(:)=time;
      nc{'temp_time'}(:)=time;
      nc{'sclm_time'}(:)=time;
      nc{'salt_time'}(:)=time;
      nc{'uclm_time'}(:)=time;
      nc{'vclm_time'}(:)=time;
      nc{'v2d_time'}(:)=time;
      nc{'v3d_time'}(:)=time;
      nc{'ssh_time'}(:)=time;
      nc{'zeta_time'}(:)=time;
      close(nc)
    end
    %
    % Boundary files
    %
    if makebry==1
      %
      % Copy the file
      %
      bryname=[bry_prefix,'Y',num2str(Ymin),'M',num2str(M),nc_suffix];
      bryname2=[bry_prefix,'Y',num2str(Y),'M',num2str(M),nc_suffix];
      disp(['Create ',bryname2]) 
      eval(['copyfile ',bryname,' ',bryname2]) 
      %
      % Change the time
      %
      nc=netcdf(bryname2,'write');
      time=nc{'bry_time'}(:)+datenum(Yorig,1,1);
      [y,m,d,h,mi,s]=datevec(time);
      dy=Ymin-Y;
      y=y-dy;
      time=datenum(y,m,d,h,mi,s)-datenum(Yorig,1,1);
      disp(datestr(time+datenum(Yorig,1,1)))
       nc{'bry_time'}(:)=time;
       nc{'tclm_time'}(:)=time;
       nc{'temp_time'}(:)=time;
       nc{'sclm_time'}(:)=time;
       nc{'salt_time'}(:)=time;
       nc{'uclm_time'}(:)=time;
       nc{'vclm_time'}(:)=time;
       nc{'v2d_time'}(:)=time;
       nc{'v3d_time'}(:)=time;
       nc{'ssh_time'}(:)=time;
       nc{'zeta_time'}(:)=time;
      close(nc)
      
      if makefrc==1
      %
      % Copy the file
      %
      blkname=[blk_prefix,'Y',num2str(Ymin),'M',num2str(M),nc_suffix];
      blkname2=[blk_prefix,'Y',num2str(Y),'M',num2str(M),nc_suffix];
      disp(['Create ',blkname2]) 
      eval(['copyfile ',blkname,' ',blkname2]) 
      %
      % Change the time
      %
      nc=netcdf(blkname2,'write');
      time=nc{'time'}(:)+datenum(Yorig,1,1);
      [y,m,d,h,mi,s]=datevec(time);
      dy=Ymin-Y;
      y=y-dy;
      time=datenum(y,m,d,h,mi,s)-datenum(Yorig,1,1);
      disp(datestr(time+datenum(Yorig,1,1)))
      nc{'time'}(:)=time;
      nc{'wind_time'}(:)=time;
      nc{'Pair_time'}(:)=time;
      nc{'Tair_time'}(:)=time;
      nc{'Qair_time'}(:)=time;
      nc{'rain_time'}(:)=time;
      nc{'swrad_time'}(:)=time;
      nc{'lwrad_time'}(:)=time;

      close(nc)
      end
    end
  end
end

