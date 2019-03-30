%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 03/2010 by Briac Le Vu
% 10/2012 updated by E. Gutknecht
% build seasonal and monthly climatology for T, S, NO3, O2 PO4 and Si
% and extract annual mean, standard deviation and sample number
% from CARS 2009 in a Xmin-Xmax/Ymin-Ymax domain (lon/lat)
% see http://www.marine.csiro.au/~dunn/cars2009/
% for reference and further information
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
clear all
close all
%
CARSDIR = '/data/CARS2009_new/';
%
varnm = {'temperature','salinity','oxygen','nitrate','silicate','phosphate'};
units = {'degre C','PSU','microM','microM','microM','microM'};
filenm = {'temperature_cars2009a','salinity_cars2009a','oxygen_cars2009','nitrate_cars2009','silicate_cars2009','phosphate_cars2009'};
period={'annual','seasonal','month'};
%
% domain (XminW-XmaxE / YminS-YmaxN)
%
name = 'global'; % name of the domain (global, ...)
Xmin = -180;
Xmax = 180;
Ymin = -90;
Ymax = 90;
display(['X = ',num2str(Xmin),' ',num2str(Xmax),' / Y = ',num2str(Ymin),' ',num2str(Ymax)]);
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CARS2009 monthly dataset for the domain
%
for j=1:length(filenm)
    
    if j==1 | j==2
     fieldnm = {'mean','nq','an_cos','an_sin','sa_cos','sa_sin','std_dev'};
    else
     fieldnm = {'mean','nq','an_cos','an_sin','sa_cos','sa_sin'};        
    end    
    
    CARSname=[CARSDIR,char(filenm(j)),'.nc'];
    display (['Open netcdfile ',CARSname])
    nc=netcdf(CARSname);
    CARS_depth=nc{'depth'}(:);
    depth_ann=nc{'depth_ann'}(:);
    depth_semiann=nc{'depth_semiann'}(:);
    lon=nc{'lon'}(:);
    CARS_lon=Xmin:0.5:Xmax;
    Yn=max(Ymin,nanmin(nc{'lat'}(:)));
    Yx=min(Ymax,nanmax(nc{'lat'}(:)));
    lat=nc{'lat'}(:);
    CARS_lat=Yn:0.5:Yx;
    id_lon=vertcat(find(lon>=360+Xmin & lon<360),find(lon>=0 & lon<=Xmax));
    id_lat=find(lat>=Ymin & lat<=Ymax);
    for i=1:length(fieldnm)
        eval([char(fieldnm(i)),'=nc{''',char(fieldnm(i)),'''}(:);']); % get the field varnm(i)
        % get the field varnm(i) in the domain
        eval([char(fieldnm(i)),'=',char(fieldnm(i)),'(:,id_lat,id_lon);']);
        eval(['fill=nc{''',char(fieldnm(i)),'''}.FillValue_(:);']); % get missing value of the field
        eval([char(fieldnm(i)),'(',char(fieldnm(i)),'==fill)=NaN;']); % replace missing value by NaN
        eval(['scfa=nc{''',char(fieldnm(i)),'''}.scale_factor(:);']); % get the scale factor
        if isempty(scfa), scfa=1; end
        eval(['adof=nc{''',char(fieldnm(i)),'''}.add_offset(:);']); % get the offset
        if isempty(adof), adof=0; end
        eval([char(fieldnm(i)),'=(',char(fieldnm(i)),'*scfa) + adof;']); % calculate the true value
    end
    close(nc)
%
% Get the annual clim and stats value nq, std_dev
%
    display ('Get the annual clim')
    eval('CARS_ann=mean;');
    CARS_N=nq;
    
    if j==1 | j==2
     CARS_SD=std_dev;
    end 
    

%
% Get the different clim from CARS time function
% field(t)= mean
% + an_cosxcos(t) + an_sinxsin(t) + sa_cosxcos(2t) + sa_sinxsin(2t)
%
% Set the cos and sin factor to 0 at deep level
    an_cos=vertcat(an_cos,zeros(length(CARS_depth)-length(depth_ann),length(CARS_lat),length(CARS_lon)));
    an_sin=vertcat(an_sin,zeros(length(CARS_depth)-length(depth_ann),length(CARS_lat),length(CARS_lon)));
    sa_cos=vertcat(sa_cos,zeros(length(CARS_depth)-length(depth_semiann),length(CARS_lat),length(CARS_lon)));
    sa_sin=vertcat(sa_sin,zeros(length(CARS_depth)-length(depth_semiann),length(CARS_lat),length(CARS_lon)));
%
% Get the seasonal clim 
%
    t=4;
    angle=2*pi*(0:t)'/t; % matrice season
% Integral calculation from season i to i+1
    display ('Get the seasonal clim')
    for i=1:t
        CARS_seas(i,:,:,:) = CARS_ann + 2/pi*...
            (an_cos*(sin(angle(i+1))-sin(angle(i)))...
            - an_sin*(cos(angle(i+1))-cos(angle(i)))...
            + sa_cos/2*(2*sin(angle(i+1))-sin(2*angle(i)))...
            - sa_sin/2*(2*cos(angle(i+1))-cos(2*angle(i))));
    end
%
% Get the monthly clim 
%
    t=12; 
    angle=2*pi*(0:t)'/t; % matrice month
% Integral calculation from month i to month i+1
    display ('Get the monthly clim')
    for i=1:t
        CARS_month(i,:,:,:) = CARS_ann + 6/pi*...
            (an_cos*(sin(angle(i+1))-sin(angle(i)))...
            - an_sin*(cos(angle(i+1))-cos(angle(i)))...
            + sa_cos/2*(2*sin(angle(i+1))-sin(2*angle(i)))...
            - sa_sin/2*(2*cos(angle(i+1))-cos(2*angle(i))));
    end
%
% Conversion O2 ml/L en micromol/L
%
    if j==3
        CARS_ann(~isnan(CARS_ann))=max(CARS_ann(~isnan(CARS_ann))*44.64,0);
        CARS_seas(~isnan(CARS_seas))=max(CARS_seas(~isnan(CARS_seas))*44.64,0);
        CARS_month(~isnan(CARS_month))=max(CARS_month(~isnan(CARS_month))*44.64,0);
    end
%
% Nutrients >0
%
    if j>3
        CARS_ann(~isnan(CARS_ann))=max(CARS_ann(~isnan(CARS_ann)),0);
        CARS_seas(~isnan(CARS_seas))=max(CARS_seas(~isnan(CARS_seas)),0);
        CARS_month(~isnan(CARS_month))=max(CARS_month(~isnan(CARS_month)),0);
    end
%
% Create the netcdf file
%
%
      for i=1:3

        ininame=[CARSDIR,'CARS_',char(varnm(j)),'_2009_',name,'_',char(period(i)),'.cdf'];
        type = [char(varnm(j)),' ',char(period(i)),'ly CARS2009 file']; 
%
        nc = netcdf(ininame,'clobber');
        display (['Create netcdfile ',ininame])
	result = redef(nc);

%
%  Create dimensions
%
        nc('X') = length(CARS_lon);
        nc('Y') = length(CARS_lat);
        nc('Z') = length(CARS_depth);
%
%  Create variables
%
        nc{'X'} = ncdouble('X') ;
        nc{'Y'} = ncdouble('Y') ;
        nc{'Z'} = ncdouble('Z') ;
%
%  Create attributes
%
        nc{'X'}.long_name = ncchar('longitude');
        nc{'X'}.long_name = 'longitude';
        nc{'X'}.units = ncchar('degree_east');
        nc{'X'}.units = 'degree_east';
%
        nc{'Y'}.long_name = ncchar('latitude');
        nc{'Y'}.long_name = 'latitude';
        nc{'Y'}.units = ncchar('degree_north');
        nc{'Y'}.units = 'degree_north';
%
        nc{'Z'}.long_name = ncchar('depth');
        nc{'Z'}.long_name = 'depth';
        nc{'Z'}.units = ncchar('meter');
        nc{'Z'}.units = 'meter';
%
        if i>1
            if i==2
                nc('T') = 4;
            elseif i==3
                nc('T') = 12;
            end
            nc{'T'} = ncdouble('T') ;
            nc{char(varnm(j))} = ncdouble('T','Z','Y','X') ;
            nc{'T'}.long_name = ncchar('time');
            nc{'T'}.long_name = 'time';
            nc{'T'}.units = ncchar(char(period(i)));
            nc{'T'}.units = char(period(i));
        else
            nc{char(varnm(j))} = ncdouble('Z','Y','X') ;
        end
%
        nc{char(varnm(j))}.long_name = ncchar(char(varnm(j)));
        nc{char(varnm(j))}.long_name = char(varnm(j));
        nc{char(varnm(j))}.units = ncchar(char(units(j)));
        nc{char(varnm(j))}.units = char(units(j));
        nc{char(varnm(j))}.missing_value = NaN;
%
% Create global attributes
%
% Leave define mode
%
        result = endef(nc);
%
% Write variables
%
        nc{'X'}(:,:) =  CARS_lon';  
        nc{'Y'}(:,:) =  CARS_lat'; 
        nc{'Z'}(:,:) =  CARS_depth; 
%
        if i==2
            nc{'T'}(:,:) = ((0:3:9)+1.5)'; % matrice saison
            nc{char(varnm(j))}(:,:,:,:) =  CARS_seas; 
        elseif i==3
            nc{'T'}(:,:) = ((0:11)+0.5)'; % matrice mois
            nc{char(varnm(j))}(:,:,:,:) =  CARS_month; 
        else
            nc{char(varnm(j))}(:,:,:) =  CARS_ann; 
        end
%
% Synchronize on disk
%
close(nc);

      end	%i=1:3

%    clear CARS_ann CARS_seas CARS_month
    
end







    
    
    
