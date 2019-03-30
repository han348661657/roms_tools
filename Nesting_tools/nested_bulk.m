function nested_bulk(child_grd,parent_blk,child_blk)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  compute the bulk file of the embedded grid
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
%  Copyright (c) 2004-2006 by Pierrick Penven 
%  e-mail:Pierrick.Penven@ird.fr  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
extrapmask=0;
%
% Title
%
title=['bulk file for the embedded grid :',child_blk,...
' using parent bulk file: ',parent_blk];
disp(' ')
disp(title)
%
% Read in the embedded grid
%
disp(' ')
disp(' Read in the embedded grid...')
nc=netcdf(child_grd);
parent_grd=nc.parent_grid(:);
imin=nc{'grd_pos'}(1);
imax=nc{'grd_pos'}(2);
jmin=nc{'grd_pos'}(3);
jmax=nc{'grd_pos'}(4);
refinecoeff=nc{'refine_coef'}(:);
result=close(nc);
nc=netcdf(parent_grd);
Lp=length(nc('xi_rho'));
Mp=length(nc('eta_rho'));
if extrapmask==1
  mask=nc{'mask_rho'}(:);
else
  mask=[];
end
result=close(nc);
%
% Read in the parent bulk file
%
disp(' ')
disp(' Read in the parent bulk file...')
nc = netcdf(parent_blk);
bulkt = nc{'bulk_time'}(:);
bulkc = nc{'bulk_time'}.cycle_length(:);
result=close(nc);
%
% Create the bulk file
%
disp(' ')
disp(' Create the bulk file...')
create_nestedbulk(child_blk,parent_blk,child_grd,title,...
                   bulkt,bulkc)
%
% parent indices
%
[igrd_r,jgrd_r]=meshgrid((1:1:Lp),(1:1:Mp));
[igrd_p,jgrd_p]=meshgrid((1:1:Lp-1),(1:1:Mp-1));
[igrd_u,jgrd_u]=meshgrid((1:1:Lp-1),(1:1:Mp));
[igrd_v,jgrd_v]=meshgrid((1:1:Lp),(1:1:Mp-1));
%
% the children indices
%
ipchild=(imin:1/refinecoeff:imax);
jpchild=(jmin:1/refinecoeff:jmax);
irchild=(imin+0.5-0.5/refinecoeff:1/refinecoeff:imax+0.5+0.5/refinecoeff);
jrchild=(jmin+0.5-0.5/refinecoeff:1/refinecoeff:jmax+0.5+0.5/refinecoeff);
[ichildgrd_p,jchildgrd_p]=meshgrid(ipchild,jpchild);
[ichildgrd_r,jchildgrd_r]=meshgrid(irchild,jrchild);
[ichildgrd_u,jchildgrd_u]=meshgrid(ipchild,jrchild);
[ichildgrd_v,jchildgrd_v]=meshgrid(irchild,jpchild);
%
% interpolations
% 
disp(' ')
disp(' Do the interpolations...')                 
np=netcdf(parent_blk);
nc=netcdf(child_blk,'write');
disp('tair...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_r,jgrd_r,ichildgrd_r,jchildgrd_r,'tair',mask,tindex)
end
disp('rhum...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_r,jgrd_r,ichildgrd_r,jchildgrd_r,'rhum',mask,tindex)
end
disp('prate...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_r,jgrd_r,ichildgrd_r,jchildgrd_r,'prate',mask,tindex)
end
disp('wspd...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_r,jgrd_r,ichildgrd_r,jchildgrd_r,'wspd',mask,tindex)
end
disp('radlw...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_r,jgrd_r,ichildgrd_r,jchildgrd_r,'radlw',mask,tindex)
end
disp('radlw_in...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_r,jgrd_r,ichildgrd_r,jchildgrd_r,'radlw_in',mask,tindex)
end
disp('radsw...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_r,jgrd_r,ichildgrd_r,jchildgrd_r,'radsw',mask,tindex)
end
disp('uwnd...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_u,jgrd_u,ichildgrd_u,jchildgrd_u,'uwnd',mask,tindex)
end
disp('vwnd...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_v,jgrd_v,ichildgrd_v,jchildgrd_v,'vwnd',mask,tindex)
end
disp('sustr...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_u,jgrd_u,ichildgrd_u,jchildgrd_u,'sustr',mask,tindex)
end
disp('svstr...')
for tindex=1:length(bulkt)
  interpvar3d(np,nc,igrd_v,jgrd_v,ichildgrd_v,jchildgrd_v,'svstr',mask,tindex)
end
result=close(np);
result=close(nc);
disp(' ')
disp(' Done ')
%
% Make a plot
%
disp(' ')
disp(' Make a plot...')
figure(1)
plot_nestbulk(child_blk,'tair',[1 6],1)
figure(2)
plot_nestbulk(child_blk,'wspd',[1 6],1)
