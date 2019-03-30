function [var_rho]=v2rho_3d(var_u)
% lat lon N


[Mp,L,N]=size(var_u);
Lp=L+1;
Lm=L-1;
var_rho=zeros(Mp,Lp,N);
var_rho(:,2:L,:)=0.5*(var_u(:,1:Lm,:)+var_u(:,2:L,:));
var_rho(:,1,:)=var_rho(:,2,:);
var_rho(:,Lp,:)=var_rho(:,L,:);

return

