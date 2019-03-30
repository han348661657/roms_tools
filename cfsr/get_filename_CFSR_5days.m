function [var,lon,lat,time]=get_filename_CFSR_5days(Input_dir,Y,M,k,index_eta,index_xi,n)

stryear=num2str(Y);
if M<10
  strmonth=['0',num2str(M)];
else
  strmonth=[num2str(M)];
end

sten{1}='01';
sten{2}='06';
sten{3}='11';
sten{4}='16';
sten{5}='21';
sten{6}='26';

stem{1}='05';
stem{2}='10';
stem{3}='15';
stem{4}='20';
stem{5}='25';
if M==1 | M==3 | M==5 | M==7 | M==8 | M==10 | M==12
stem{6}='31';
elseif M==4 | M==6 | M==9 | M==11 
stem{6}='30';
end

if mod(Y,4)==0 & M==2
    stem{6}='29';
elseif mod(Y,4)~=0 & M==2
    stem{6}='28';
end




if k==1  
   fname=[Input_dir,'tmp2m.gdas.',stryear,strmonth,sten{n},'-',stryear,strmonth,stem{n},'.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'TMP_L103'}(:,index_eta,index_xi);
   %var0=nc{'TMP_L103'};
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
   
elseif k==2
   fname=[Input_dir,'radiation.gdas.',stryear,strmonth,sten{n},'-',stryear,strmonth,stem{n},'.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'DLWRF_L1'}(:,index_eta,index_xi);
  %  var0=nc{'DLWRF_L1'};

   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
 
elseif k==3
   fname=[Input_dir,'radiation.gdas.',stryear,strmonth,sten{n},'-',stryear,strmonth,stem{n},'.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'ULWRF_L1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);

elseif k==4
   fname=[Input_dir,'radiation.gdas.',stryear,strmonth,sten{n},'-',stryear,strmonth,stem{n},'.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'DSWRF_L1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
        
elseif k==5
   fname=[Input_dir,'radiation.gdas.',stryear,strmonth,sten{n},'-',stryear,strmonth,stem{n},'.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'USWRF_L1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
    
elseif k==6    % preticipation
     fname=[Input_dir,'prmsl.gdas.',stryear,strmonth,sten{n},'-',stryear,strmonth,stem{n},'.grb2.nc'];
     nc=netcdf(fname,'nowrite');
     var0=nc{'PRMSL_L101'}(:,index_eta,index_xi); 
     lon=nc{'lon'}(index_xi);
     lat=nc{'lat'}(index_eta);
    
elseif k==7
    fname=[Input_dir,'wnd10m.gdas.',stryear,strmonth,sten{n},'-',stryear,strmonth,stem{n},'.grb2.nc'];
    nc=netcdf(fname,'nowrite');
    var0=nc{'U_GRD_L103'}(:,index_eta,index_xi);
    lon=nc{'lon'}(index_xi);
    lat=nc{'lat'}(index_eta);
      
elseif k==8
    fname=[Input_dir,'wnd10m.gdas.',stryear,strmonth,sten{n},'-',stryear,strmonth,stem{n},'.grb2.nc'];
    nc=netcdf(fname,'nowrite');
    var0=nc{'V_GRD_L103'}(:,index_eta,index_xi);
    lon=nc{'lon'}(index_xi);
    lat=nc{'lat'}(index_eta);
    
elseif k==9    
    fname=[Input_dir,'q2m.gdas.',stryear,strmonth,sten{n},'-',stryear,strmonth,stem{n},'.grb2.nc'];
    nc=netcdf(fname,'nowrite');
    var0=nc{'SPF_H_L103'}(:,index_eta,index_xi);
    lon=nc{'lon'}(index_xi);
    lat=nc{'lat'}(index_eta);
  
elseif k==10   
    fname=[Input_dir,'prate.gdas.',stryear,strmonth,sten{n},'-',stryear,strmonth,stem{n},'.grb2.nc'];
    nc=netcdf(fname,'nowrite');   
    var0=nc{'PRATE_L1_Avg_1'}(:,index_eta,index_xi);
    lon=nc{'lon'}(index_xi);
    lat=nc{'lat'}(index_eta);
    
else
    disp([' the end of variation inupt '])
    
end    









    time=nc{'time'}(:);
close(nc)
             lat=flipud(lat);
             var=0.*var0;
             for i=1:length(time)
                 tvar=squeeze(var0(i,:,:));
                 var(i,:,:)=flipud(tvar);                
             end

return
