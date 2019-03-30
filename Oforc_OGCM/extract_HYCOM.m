function extract_HYCOM(HYCOM_dir,HYCOM_prefix,url,year,month,...
                      lon,lat,depth,time,...
                      trange,krange,jrange,...
                      i1min,i1max,i2min,i2max,i3min,i3max,...
                      Yorig)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract a subset from HYCOM using OPENDAP
% Write it in a local file 
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
%  Copyright (c) 2005-2006 by Pierrick Penven 
%  e-mail:Pierrick.Penven@ird.fr  
%
%  Updated   6-Sep-2006 by Pierrick Penven
%  Updated : 23-Oct-2009 by Gildas Cambon Adapatation for the special tratment 
%            for the bry file
%  Updated   21-Apr-2010 by Yu Liu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
disp(['    Download HYCOM for ',num2str(year),...
      ' - ',num2str(month)])
%
% Get the dataset attributes
%
disp('Get the dataset attributes')
x=readattribute(url);		
%
% Get SSH
%
disp('    ...SSH')
ssh=getdap(url,'',...
	       'ssh',trange,'',jrange,...
	       i1min,i1max,i2min,i2max,i3min,i3max);
ssh=shiftdim(ssh,2);
missval=x.ssh.ml__FillValue;
ssh(ssh>=missval)=NaN;
%
% Get U
%
disp('    ...U')
u=getdap(url,'',...
	     'u',trange,krange,jrange,...
	     i1min,i1max,i2min,i2max,i3min,i3max);
u=shiftdim(u,2);                  %%  u v temp saln (depth,time,lat,lon) atfter loaddap and shift
missval=x.u.ml__FillValue;
u(u>=missval)=NaN;
%
% Get V
%
disp('    ...V')
v=getdap(url,'',...
	     'v',trange,krange,jrange,...
	     i1min,i1max,i2min,i2max,i3min,i3max);
v=shiftdim(v,2);
missval=x.v.ml__FillValue;
v(v>=missval)=NaN;
%
% Get TEMP
%
disp('    ...TEMP')
temp=getdap(url,'',...
		'temperature',trange,krange,jrange,...
		i1min,i1max,i2min,i2max,i3min,i3max);
temp=shiftdim(temp,2);
missval=x.temperature.ml__FillValue;
temp(temp>=missval)=NaN;
%
% Get SALT
%
disp('    ...SALT')
salt=getdap(url,'',...
		'salinity',trange,krange,jrange,...
		i1min,i1max,i2min,i2max,i3min,i3max);
salt=shiftdim(salt,2);
missval=x.salinity.ml__FillValue;
salt(salt>=missval)=NaN;
%
create_HYCOM([HYCOM_dir,HYCOM_prefix,'Y',num2str(year),'M',num2str(month),'.cdf'],...
            lon,lat,lon,lat,lon,lat,depth,time,...
            temp,salt,u,v,ssh,Yorig)
%
return
