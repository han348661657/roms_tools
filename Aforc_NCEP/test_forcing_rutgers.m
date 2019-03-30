function test_forcing_rutgers(frcname,grdname,thefield,thetime,skip,coastfileplot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot a variable from the forcing file 
% 
% Yu Liu  yliu@nuist.edu.cn   2018-8-14
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
niceplot=1;
i=0;
for time=thetime
  i=i+1;
  
  subplot(2,length(thetime)/2,i)

  nc=netcdf(frcname);
  stime=nc{'time'}(time);
 
    if isempty(stime)
      error('TEST_FORCING: Is it a forcing or a bulk file ?')
    end
    u=nc{'Uwind'}(time,:,:);
    v=nc{'Vwind'}(time,:,:);
    if thefield(1:3)=='spd'
      field=sqrt((u2rho_2d(u)).^2+(v2rho_2d(v)).^2);
      fieldname='wind speed';
    else
      field=nc{thefield}(time,:,:);
      fieldname=nc{thefield}.long_name(:);
    end
  close(nc);
%
% Read the grid
%
  nc=netcdf(grdname);
    lon=nc{'lon_rho'}(:);
    lat=nc{'lat_rho'}(:);
    mask=nc{'mask_rho'}(:);
    angle=nc{'angle'}(:);
    result=close(nc);
    mask(mask==0)=NaN;
%
% compute the vectors
% 
  [ured,vred,lonred,latred,speed]=uv_vec2rho(u,v,lon,lat,angle,...
                                             mask,skip,[0 0 0 0]);
%
% Make the plot
%  
  if niceplot==1
    domaxis=[min(min(lon)) max(max(lon)) min(min(lat)) max(max(lat))];
    m_proj('mercator',...
       'lon',[domaxis(1) domaxis(2)],...
       'lat',[domaxis(3) domaxis(4)]);

    m_pcolor(lon,lat,mask.*field);
    shading flat
    drawnow
    colorbar
    hold on
    m_quiver(lonred,latred,ured,vred,'k');
    if ~isempty(coastfileplot)
      m_usercoast(coastfileplot,'patch',[.9 .9 .9]);
    end
    hold off
    title([fieldname,' - day: ',num2str(stime)])
    m_grid('box','fancy',...
           'xtick',5,'ytick',5,'tickdir','out',...
           'fontsize',7);
  else
    imagesc(mask.*field)
    title([fieldname,' - day: ',num2str(stime)])
  end
end