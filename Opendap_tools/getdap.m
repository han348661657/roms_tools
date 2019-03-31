function var=getdap(path,fname,vname,trange,krange,jrange,...
                    i1min,i1max,i2min,i2max,i3min,i3max)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  var=getdap(path,fname,vname,trange,krange,jrange,...
%             i1min,i1max,i2min,i2max,i3min,i3max)
%
%  Download a data subsets from a OPENDAP server.
%
%  Take care of the greenwitch meridian
%  (i.e. get 3 subgrids defined by i1min,i1max,i2min,i2max,i3min,i3max
%  and concatenate them).
%
%  In case of network failure, the program resend the OPENDAP 
%  query until it works (no more than 100 times though...)
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
%  Copyright (c) 2006 by Pierrick Penven 
%  e-mail:Pierrick.Penven@ird.fr  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
url=[path,fname];
%
var=[];
%
if ~isempty(i2min)
  irange=['[',num2str(i2min),':',num2str(i2max),']'];
  N1=find(irange==':');
  N2=find(jrange==':');
  
  jstr=str2double(jrange(2:N2-1));
  jend=str2double(jrange(N2+1:end-1));
  istr=str2double(irange(2:N1-1));
  iend=str2double(irange(N1+1:end-1));

  step1=iend-istr+1;
  step2=jend-jstr+1;

  tstr=str2double(trange(2:end-1));
  if isempty(krange)
     var=ncread(url,vname,[istr jstr tstr],...
       [step1 step2 1],[1 1 1]);
  else
      N3=find(krange==':');
      kstr=str2double(krange(2:N3-1));
      kend=str2double(krange(N3+1:end-1));
      step3=kend-kstr+1;
      var=ncread(url,vname,[istr jstr kstr tstr],...
       [step1 step2 step3 1],[1 1 1 1]);
  end

end
%
if ~isempty(i1min)
    irange=['[',num2str(i1min),':',num2str(i1max),']'];
  N1=find(irange==':');
  N2=find(jrange==':');
  
  jstr=str2double(jrange(2:N2-1));
  jend=str2double(jrange(N2+1:end-1));
  istr=str2double(irange(2:N1-1));
  iend=str2double(irange(N1+1:end-1));

  step1=iend-istr+1;
  step2=jend-jstr+1;

  tstr=str2double(trange(2:end-1));
  if isempty(krange)
     var0=ncread(url,vname,[istr jstr tstr],...
       [step1 step2 1],[1 1 1]);
  else
      N3=find(krange==':');
      kstr=str2double(krange(2:N3-1));
      kend=str2double(krange(N3+1:end-1));
      step3=kend-kstr+1;
      var0=ncread(url,vname,[istr jstr kstr tstr],...
       [step1 step2 step3 1],[1 1 1 1]);
  end
  var=cat(1,var0,var);
end
%
if ~isempty(i3min)
  irange=['[',num2str(i3min),':',num2str(i3max),']'];
  var0=readdap(url,vname,[trange,krange,jrange,irange]);
  var=cat(1,var,var0);
end
%
return
