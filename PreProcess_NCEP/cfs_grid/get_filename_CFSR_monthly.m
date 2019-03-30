function [var,lon,lat,time]=get_filename_CFSR_monthly(Input_dir,Y,M,k,index_eta,index_xi)

stryear=num2str(Y);
if M<10
  strmonth=['0',num2str(M)];
else
  strmonth=[num2str(M)];
end


if k==1  
   fname=[Input_dir,'tmp2m.cdas1.',stryear,strmonth,'.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'TMP_L103'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
   
elseif k==2
   fname=[Input_dir,'dlwsfc.cdas1.',stryear,strmonth,'.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'DLWRF_L1_Avg_1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
 
elseif k==3
   fname=[Input_dir,'ulwsfc.cdas1.',stryear,strmonth,'.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'ULWRF_L1_Avg_1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);

elseif k==4
   fname=[Input_dir,'dswsfc.cdas1.',stryear,strmonth,'.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'DSWRF_L1_Avg_1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
        
elseif k==5
   fname=[Input_dir,'uswsfc.cdas1.',stryear,strmonth,'.grb2.nc'];
   nc=netcdf(fname,'nowrite');
   var0=nc{'USWRF_L1_Avg_1'}(:,index_eta,index_xi);
   lon=nc{'lon'}(index_xi);
   lat=nc{'lat'}(index_eta);
    
elseif k==6    % preticipation
     fname=[Input_dir,'prate.cdas1.',stryear,strmonth,'.grb2.nc'];
     nc=netcdf(fname,'nowrite');
     var0=nc{'PRATE_L1_Avg_1'}(:,index_eta,index_xi); 
     lon=nc{'lon'}(index_xi);
     lat=nc{'lat'}(index_eta);
    
elseif k==7
    fname=[Input_dir,'wnd10m.cdas1.',stryear,strmonth,'.grb2.nc'];
    nc=netcdf(fname,'nowrite');
    var0=nc{'U_GRD_L103'}(:,index_eta,index_xi);
    lon=nc{'lon'}(index_xi);
    lat=nc{'lat'}(index_eta);
      
elseif k==8
    fname=[Input_dir,'wnd10m.cdas1.',stryear,strmonth,'.grb2.nc'];
    nc=netcdf(fname,'nowrite');
    var0=nc{'V_GRD_L103'}(:,index_eta,index_xi);
    lon=nc{'lon'}(index_xi);
    lat=nc{'lat'}(index_eta);
    
elseif k==9    
    fname=[Input_dir,'q2m.cdas1.',stryear,strmonth,'.grb2.nc'];
    nc=netcdf(fname,'nowrite');
    var0=nc{'SPF_H_L103'}(:,index_eta,index_xi);
    lon=nc{'lon'}(index_xi);
    lat=nc{'lat'}(index_eta);
  
elseif k==10   
    fname=[Input_dir,'prmsl.cdas1.',stryear,strmonth,'.grb2.nc'];
    nc=netcdf(fname,'nowrite');   
    var0=nc{'PRMSL_L101'}(:,index_eta,index_xi);
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
