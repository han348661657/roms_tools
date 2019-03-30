function [var,lon,lat]=get_filename_CFSR_daily(Input_dir,Y,M,D,k,index_xi,index_eta)

stryear=num2str(Y);
if M<10
  strmonth=['0',num2str(M)];
else
  strmonth=[num2str(M)];
end

if D<10
  strday=['0',num2str(D)];
else
  strday=[num2str(D)];
end

if k==1  
   fname=[Input_dir,'twometers.',stryear,strmonth,strday,'.sfluxgrbf.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'TMP_L103'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
   
elseif k==2
   fname=[Input_dir,'radiation.',stryear,strmonth,strday,'.sfluxgrbf.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'DLWRF_L1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
 
elseif k==3
   fname=[Input_dir,'radiation.',stryear,strmonth,strday,'.sfluxgrbf.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'ULWRF_L1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);

elseif k==4
   fname=[Input_dir,'radiation.',stryear,strmonth,strday,'.sfluxgrbf.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'DSWRF_L1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
   
           
elseif k==5
   fname=[Input_dir,'radiation.',stryear,strmonth,strday,'.sfluxgrbf.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'USWRF_L1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
    
elseif k==6    % preticipation
     fname=[Input_dir,'precipitation.',stryear,strmonth,strday,'.sfluxgrbf.grb2.nc'];
     nc=netcdf(fname,'nowrite');
     var0=nc{'PRATE_L1_Avg_1'}(:,index_eta,index_xi); 
     lon=nc{'lon'}(index_xi);
     lat=nc{'lat'}(index_eta);
    
elseif k==7
    fname=[Input_dir,'windspeed.',stryear,strmonth,strday,'.sfluxgrbf.grb2.nc'];
    nc=netcdf(fname,'nowrite');
    var0=nc{'U_GRD_L103'}(:,index_eta,index_xi);
    lon=nc{'lon'}(index_xi);
    lat=nc{'lat'}(index_eta);
    
    
elseif k==8
    fname=[Input_dir,'windspeed.',stryear,strmonth,strday,'.sfluxgrbf.grb2.nc'];
    nc=netcdf(fname,'nowrite');
    var0=nc{'V_GRD_L103'}(:,index_eta,index_xi);
    lon=nc{'lon'}(index_xi);
    lat=nc{'lat'}(index_eta);
    
elseif k==9    
    fname=[Input_dir,'twometers.',stryear,strmonth,strday,'.sfluxgrbf.grb2.nc'];
    nc=netcdf(fname,'nowrite');
    var0=nc{'SPF_H_L103'}(:,index_eta,index_xi);
    lon=nc{'lon'}(index_xi);
    lat=nc{'lat'}(index_eta);
   
else
    disp([' the end of variation inupt '])
    
end    

close(nc)
             lat=flipud(lat);
             var=0.*var0;
             for i=1:4
                 tvar=squeeze(var0(i,:,:));
                 var(i,:,:)=flipud(tvar);                
             end

return
