%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  make_CFSR_rutgers.m
%  make bulk files for rutgers version
%  Create and fill frc and bulk files with CFSR data.
%  (The Climate Forecast System Reanalysis [1979 - 2010])
%
%  Yu Liu     yliu@nuist.edu.cn
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%start
clearvars
close all
%%%%%%%%%%%%%%%%%%%%% USERS DEFINED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%
%
% Common parameters
%
romstools_param
%
if NCEP_version==3
  blk_prefix=[blk_prefix,'_CFSR_'];
else
  error('MAKE_CFSR: wrong NCEP version')
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end of user input  parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if level==0
  nc_suffix='.nc';
else
  nc_suffix=['.nc.',num2str(level)];
  grdname=[grdname,'.',num2str(level)];
end
%
% Get the model grid
%
disp(' ')
disp([' Read in the grid ',grdname])
nc=netcdf(grdname);
Lp=length(nc('xi_rho'));
Mp=length(nc('eta_rho'));
lon=nc{'lon_rho'}(:);
lat=nc{'lat_rho'}(:);
angle=nc{'angle'}(:);
close(nc);
  %
  % Get the NCEP horizontal grids (it should be the same for every month)
  %
  nc=netcdf([NCEP_dir,'Land_cover_1land_2sea.nc']);
  %nc=netcdf([NCEP_dir,'Pressure_mean_seal_level_Y',num2str(Ymin),'M',num2str(Mmin),'.nc']);
  disp(['Use this land file :',char([NCEP_dir,'Land_cover_1land_2sea.nc'])])
  lon1=nc{'lon'}(:);
  lat1=nc{'lat'}(:);
  [lon1,lat1]=meshgrid(lon1,lat1);

  mask=1-squeeze(nc{'Land_cover_1land_2sea'}(1,:,:));
  mask(mask==0)=NaN;
  close(nc);

  nc=netcdf([NCEP_dir,'Pressure_surface_Y',num2str(Ymin),'M',num2str(Mmin),'.nc']);
  disp(['Use this pressures grid file :',char([NCEP_dir,'Pressure_surface_Y',num2str(Ymin),'M',num2str(Mmin),'.nc'])])
  lon2=nc{'lon'}(:);
  lat2=nc{'lat'}(:);
  [lon2,lat2]=meshgrid(lon2,lat2);
  lon1=lon2;
  lat1=lat2;
  close(nc);
  
  %
  %Loop on the years and the months
  %
  disp(['====================='])
  disp(['INTERPOLATION STEP'])
  disp(['====================='])
  disp(['Loop on the years and the months'])

  %
  for Y=Ymin:Ymax
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
      disp(' ')
      disp(['Processing  year ',num2str(Y),...
	    ' - month ',num2str(M)])
      disp(' ')
      %
      % Process time (here in days)
      %
      nc=netcdf([NCEP_dir,'Temperature_height_above_ground_Y',num2str(Y),'M',num2str(M),'.nc']);
      
      NCEP_time=nc{'time'}(:);
      close(nc);
      dt=mean(gradient(NCEP_time));
      disp(['dt=',num2str(dt)])
      %-----------------------------------------------------------
      %Variable overlapping timeesteps : 2 at the beginning and 2 at the end
      %------------------------------------------------------------
      tlen0=length(NCEP_time);
      disp(['tlen0=',num2str(tlen0)])
      tlen=tlen0+2*itolap_ncep;
      disp(['tlen=',num2str(tlen)])
      disp(['Overlap is ',num2str(itolap_ncep),' it of 6 hours'])
      disp(['Overlap is ',num2str(itolap_ncep/4),' days before and after'])
      time=0*(1:tlen);
      time(itolap_ncep+1:tlen0+itolap_ncep)=NCEP_time;
      disp(['====================='])
      disp('Compute time for roms file')
      disp(['====================='])
      for aa=1:itolap_ncep
	time(aa)=time(itolap_ncep+1)-(itolap_ncep+1-aa)*dt;
      end

      for aa=1:itolap_ncep
	time(tlen0+itolap_ncep+aa)=time(tlen0+itolap_ncep)+aa*dt;
      end

      disp(['====================='])
      disp('Create the frc/blk netcdf file')
      disp(['====================='])
      % Create the ROMS forcing files
      blkname=[blk_prefix,'Y',num2str(Y),...
	       'M',num2str(M),nc_suffix];
        
	disp(['Create a new bulk file: ' blkname])
	create_bulk_rutgers(blkname,grdname,ROMS_title,time);
	disp([' ']) 
      %
      % Open the ROMS forcing files
	  nc_blk=netcdf(blkname,'write');
      %
      % Check if there are NCEP files for the previous Month
      Mm=M-1;
      Ym=Y;
      if Mm==0
	     Mm=12;
	     Ym=Y-1;
      end

      fname = [NCEP_dir,'Temperature_height_above_ground_Y',num2str(Ym),'M',num2str(Mm),'.nc'];      
      nc=netcdf(fname);

      %
      disp(' ')
      disp('======================================================')
      disp('Perform interpolations for the previous month')
      disp('======================================================')
      disp(' ')
   if exist(fname)==0
	disp(['No data for the previous month: using current month'])
	tndx=1;
	Mm=M;
	Ym=Y;
   else
	nc=netcdf(fname);
	tndx=length(nc('time'));
	 for aa=1:itolap_ncep
	    nc_blk{'bulk_time'}(aa)=nc{'time'}(tndx-(itolap_ncep-aa));
     end 
	close(nc)
   end
      %
      % Perform interpolations for the previous month or repeat the first one
      %
      for aa=1:itolap_ncep
	   aa0=itolap_ncep-aa;
	   interp_CFSR_rutgers(NCEP_dir,Ym,Mm,Roa,interp_method,lon1,lat1,lon2,lat2,...
                    mask,tndx-aa0,nc_blk,lon,lat,angle,aa)
      end
      %######################################################################
      %
      disp(' ')
      disp('======================================================')
      disp('Perform interpolations for the current month')
      disp('======================================================')
      disp(' ')

      % Perform interpolations for the current month
      %

    for tndx=1:tlen0
	  if mod(tndx,20)==0
	    disp(['Step: ',num2str(tndx),' of ',num2str(tlen0)])
      end
	   interp_CFSR_rutgers(NCEP_dir,Y,M,Roa,interp_method,lon1,lat1,lon2,lat2,...
                    mask,tndx,nc_blk,lon,lat,angle,tndx+itolap_ncep)
    end

      disp(' ')
      disp('======================================================')
      disp('Perform interpolations for next month')
      disp('======================================================')
      disp(' ')
      %######################################################################
      % Read NCEP file for the next month
      %
      Mp=M+1;
      Yp=Y;
      %
      % Perform the interpolations for the next month
      %
      disp('Last steps')
      if Mp==13
	Mp=1;
	Yp=Y+1;
      end

      fname=[NCEP_dir,'Temperature_height_above_ground_Y',num2str(Yp),'M',num2str(Mp),'.nc'];

      if exist(fname,'file')==0
	disp(['No data for the next month: using current month'])
	tndx=tlen0;
	Mp=M;
	Yp=Y;
      else
	nc=netcdf(fname);
	%
	  disp('bulk_time')
	  for tndx=tlen0+itolap_ncep+1:tlen
	    nc_blk{'bulk_time'}(tndx)=nc{'time'}(tndx-tlen0-itolap_ncep);
      end
	close(nc)
      end
      %
      for tndx=tlen0+itolap_ncep+1:tlen
	disp(['tndx= ',num2str(tndx)])
	tout=tndx;
	disp(['tout=tndx ',num2str(tndx)])
	if Mp==M
	  tin=tlen0; % persistency if current month is used
	  disp(['tin=',num2str(tin)])
	else
	  tin=tndx-tlen0-itolap_ncep;
	  disp(['tin=',num2str(tin)])
	end
	interp_CFSR_rutgers(NCEP_dir,Yp,Mp,Roa,interp_method,lon1,lat1,lon2,lat2,...
                    mask,tin,nc_blk,lon,lat,angle,tout)
      end
      %
      % Close the ROMS forcing files
      %
	close(nc_blk);
    
    end
  end
  
  
  
if SPIN_Long>0
  M=Mmin-1;
  Y=Ymin-SPIN_Long;
  for month=1:12*SPIN_Long
    M=M+1;
    if M==13
      M=1; 
      Y=Y+1;
    end
    %
    % Frocing files
    %
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

%---------------------------------------------------------------
% Make a few plots
%---------------------------------------------------------------
if makeplot==1
  disp(' ')
  disp('======================================================')
  disp(' Make a few plots...')
  slides=[1 25 50 75];
  if makeblk
    figure
    test_forcing_rutgers(blkname,grdname,'Pair',slides,3,coastfileplot)
    figure
    test_forcing_rutgers(blkname,grdname,'Tair',slides,3,coastfileplot)
    figure
    test_forcing_rutgers(blkname,grdname,'Qair',slides,3,coastfileplot)
    figure
    test_forcing_rutgers(blkname,grdname,'Uwind',slides,3,coastfileplot)
    figure
    test_forcing_rutgers(blkname,grdname,'Vwind',slides,3,coastfileplot)
    figure
    test_forcing_rutgers(blkname,grdname,'lwrad',slides,3,coastfileplot)
    figure
    test_forcing_rutgers(blkname,grdname,'swrad',slides,3,coastfileplot)
  end
end