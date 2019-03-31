function download_SODA(Ymin,Ymax,Mmin,Mmax,lonmin,lonmax,latmin,latmax,OGCM_dir,OGCM_prefix,url,Yorig)


% Ymin          = 2009;          % first forcing year
% Ymax          = 2009;          % last  forcing year
% Mmin          = 1;             % first forcing month
% Mmax          = 12;             % last  forcing month
% Yorig         =2000;
% 
% lonmin =   310;   % Minimum longitude [degree east]
% lonmax =  350;   % Maximum longitude [degree east]
% latmin = 45;   % Minimum latitudeF  [degree north]
% latmax = 65;   % Maximum latitude  [degree north]
% 
% % SODA_2.2.4/ [ C20R-2 1871-2008 / POP2.1 ]
% url='http://apdrc.soest.hawaii.edu:80/dods/public_data/SODA/soda_pop2.2.4' ;
%   
% OGCM_prefix=   'SODA';
% OGCM_dir      = 'H:\roms-rutgers\toolbox\ww3\ROMS_FILES\SODA_N Atl\';
%   
                   
disp([' '])
disp(['Get data from Y',num2str(Ymin),'M',num2str(Mmin),...
      ' to Y',num2str(Ymax),'M',num2str(Mmax)])
disp(['Minimum Longitude: ',num2str(lonmin)])
disp(['Maximum Longitude: ',num2str(lonmax)])
disp(['Minimum Latitude: ',num2str(latmin)])
disp(['Maximum Latitude: ',num2str(latmax)])
disp([' '])
%
% Define the original date of the SODA data
% 
if strcmp(url,'http://apdrc.soest.hawaii.edu:80/dods/public_data/SODA/soda_pop2.1.6')
%if strcmp(url,'http://iridl.ldeo.columbia.edu/SOURCES/.CARTON-GIESE/.SODA/.v2p1p6')
    year_orig_SODA=1958;
elseif strcmp(url,'http://apdrc.soest.hawaii.edu:80/dods/public_data/SODA/soda_pop2.2.4')
%elseif strcmp(url,'http://iridl.ldeo.columbia.edu/SOURCES/.CARTON-GIESE/.SODA/.v2p2p4')
    year_orig_SODA=1871;
%elseif strcmp(url,'http://apdrc.soest.hawaii.edu:80/dods/public_data/SODA/soda_pop2.2.6')
%      year_orig_SODA=1866;  
end


%
% Create the directory
%
disp(['Making output data directory ',OGCM_dir])
eval(['mkdir ',OGCM_dir])
%
% Start 
%
disp(['Process the dataset: ',url])
%
% Find a subset of the SODA grid
%
[i1min,i1max,i2min,i2max,i3min,i3max,jrange,krange,lon,lat,depth]=...
 get_SODA_subgrid(url,lonmin,lonmax,latmin,latmax);
%
% Get SODA time 
%
%  Months since 1960-01-01 
%       --> http://iridl.ldeo.columbia.edu/SOURCES/.CARTON-GIESE/.SODA/.v2p1p6/
%
% Transform it into Yorig time (i.e days since Yorig-01-01)
%year=floor(1960+SODA_time/12);
%month=1+rem(1960*12+SODA_time-0.5,12);
%SODA_time=datenum(year,month,15)-datenum(Yorig,1,1);

%  Days since 01-01-01 on apdrc.soest.hawaii.edu:80 dods server
%
SODA_time=ncread(url,'time');
%
% Get the months and the years
%
days = SODA_time - datenum(year_orig_SODA -1 ,1,15);
month = 1 + rem([1:length(days)],12);
year = year_orig_SODA + fix([0:length(days)-1]./12) ;

% Transform it into Yorig time (i.e days since Yorig-01-01)
SODA_time=datenum(year,month,15)-datenum(Yorig,1,1);
%
% Loop on the years
%
for Y=Ymin:Ymax
  disp(['Processing year: ',num2str(Y)])
%
% Loop on the months


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
%
% Get the time indice for this year and month
%
    tndx=find(month==M & year==Y);
    trange=['[',num2str(tndx(1)-1),']'];
%
% Extract SODA data
%
    extract_SODA(OGCM_dir,OGCM_prefix,[url],Y,M,...
                 lon,lat,depth,SODA_time(tndx),...
                 trange,krange,jrange,...
                 i1min,i1max,i2min,i2max,i3min,i3max,...
                 Yorig)
  end
end
return
