function add_ini_o2(ininame,grdname,oaname,cycle,O2min);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  function [longrd,latgrd,o2]=add_ini_o2(ininame,grdname,...
%                                           month_datafile,ann_datafile,...
%                                           cycle);
%
%  Add oxygen (mMol O2 m-3) in a ROMS initial file.
%  take monthly data for the upper levels and annual data for the
%  lower levels.
%  do a temporal interpolation to have values at initial
%  time.
%
%  input:
%    
%    ininame       : roms initial file to process (netcdf)
%    grdname      : roms grid file (netcdf)
%    month_datafile : regular longitude - latitude - z monthly data 
%                    file used for the upper levels  (netcdf)
%    ann_datafile  : regular longitude - latitude - z annual data 
%                    file used for the lower levels  (netcdf)
%    cycle         : time length (days) of climatology cycle (ex:360 for
%                    annual cycle) - 0 if no cycle.
%
%   output:
%
%    [longrd,latgrd,o2] : surface field to plot (as an illustration)
% 
%  Further Information:  
%  http://www.brest.ird.fr/Roms_tools/
%  
%  This file is part of ROMSTOOLS
%
%  ROMSTOOLS is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published
%  by the Free Software Foundation; either version 2 of the License,
%  or (at your option) any later version.
%
%  ROMSTOOLS is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program; if not, write to the Free Software
%  Foundation, Inc., 59 Temple Place, Suite 330, Boston,
%  MA  02111-1307  USA
%
%  Copyright (c) 2001-2006 by Pierrick Penven 
%  e-mail:Pierrick.Penven@ird.fr  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
disp('Add_ini_o2: creating variable and attribute')
%
% open the grid file  
% 
nc=netcdf(grdname);
h=nc{'h'}(:);
close(nc);
%
% open the initial file  
%
nc=netcdf(ininame,'write');
theta_s = nc{'theta_s'}(:);
if isempty(theta_s)
    disp('Restart file')
    theta_s=nc.theta_s(:);
    theta_b=nc.theta_b(:);
    hc=nc.hc(:);
else
    theta_b =  nc{'theta_b'}(:);
    hc  =  nc{'hc'}(:);
    vtransform = nc{'Vtransform'}(:);
    if  ~exist('vtransform')
        vtransform=1; %Old Vtransform
        disp([' NO VTRANSFORM parameter found'])
        disp([' USE TRANSFORM default value vtransform = 1'])
    end
end
N =  length(nc('s_rho'));
%
% open the oa file  
% 
noa=netcdf(oaname);
z=-noa{'Zo2'}(:);
oatime=noa{'o2_time'}(:);
tlen=length(oatime);
%
% Get the sigma depths
%
zroms=zlevs(h,0.*h,theta_s,theta_b,hc,N,'r',vtransform);
zmin=min(min(min(zroms)));
zmax=max(max(max(zroms)));
%
% Check if the min z level is below the min sigma level 
%    (if not add a deep layer)
%
%addsurf=max(z)<zmax;
addsurf=1;
addbot=min(z)>zmin;
if addsurf
 z=[100;z];
end
if addbot
 z=[z;-100000];
end
Nz=min(find(z<zmin));
z=z(1:Nz);
%
% read in the initial file  
% 
scrum_time = nc{'scrum_time'}(:);
scrum_time = scrum_time / (24*3600);
tinilen = length(scrum_time);
redef(nc);
nc{'O2'} = ncdouble('time','s_rho','eta_rho','xi_rho');
nc{'O2'}.long_name = ncchar('Oxygen');
nc{'O2'}.long_name = 'Oxygen';
nc{'O2'}.units = ncchar('mMol O m-3');
nc{'O2'}.units = 'mMol O m-3';
nc{'O2'}.fields = ncchar('O2, scalar, series');
nc{'O2'}.fields = 'O2, scalar, series';
endef(nc);
%
%  loop on initial time
%
for l=1:tinilen
  disp(['time index: ',num2str(l),' of total: ',num2str(tinilen)])
%
%  get data time indices and weights for temporal interpolation
%
  if cycle~=0
    modeltime=mod(scrum_time(l),cycle);
  else
    modeltime=scrum_time;
  end
  l1=find(modeltime==oatime);
  if isempty(l1)
    disp('temporal interpolation')
    l1=max(find(oatime<modeltime));
    time1=oatime(l1);
    if isempty(l1)
      if cycle~=0
        l1=tlen;
        time1=oatime(l1)-cycle;
      else
        error('No previous time in the dataset')
      end
    end
    l2=min(find(oatime>modeltime));
    time2=oatime(l2);
    if isempty(l2)
      if cycle~=0
        l2=1;
        time2=oatime(l2)+cycle;
      else
        error('No posterious time in the dataset')
      end
    end
    disp(['Initialisation time: ',num2str(modeltime),...
          ' - Time 1: ',num2str(time1),...
          ' - Time 2: ',num2str(time2)])	 
    cff1=(modeltime-time2)/(time1-time2);
    cff2=(time1-modeltime)/(time1-time2);
  else
    cff1=1;
    l2=l1;
    cff2=0;
  end
%
% interpole the monthly dataset on the horizontal roms grid
%
  disp(['Add_ini_o2: vertical interpolation'])
  var=squeeze(noa{'O2'}(l1,:,:,:));
  
  if addsurf
    var=cat(1,var(1,:,:),var);
  end
  if addbot
    var=cat(1,var,var(end,:,:));
  end
  var2=squeeze(noa{'O2'}(l2,:,:,:));
  if addsurf
    var2=cat(1,var2(1,:,:),var2);
  end
  if addbot
    var2=cat(1,var2,var2(end,:,:));
  end
  var=cff1*var + cff2*var2;
  zeta = squeeze(nc{'zeta'}(l,:,:));
  zroms=zlevs(h,zeta,theta_s,theta_b,hc,N,'r',vtransform);
  nc{'O2'}(l,:,:,:)=ztosigma(flipdim(var,1),zroms,flipud(z));
end
close(noa);
%
% Remove low values for oligotrophic areas
%
for l=1:tinilen
  O2=nc{'O2'}(l,:,:,:);
  O2(O2<O2min)=O2min;
  nc{'O2'}(l,:,:,:)=O2;
end
close(nc);
return
