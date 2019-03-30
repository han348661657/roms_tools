function [var_rho]=u2rho_3d(var_v)


[M,Lp,N]=size(var_v);
Mp=M+1;
Mm=M-1;
var_rho=zeros(Mp,Lp,N);
var_rho(2:M,:,:)=0.5*(var_v(1:Mm,:,:)+var_v(2:M,:,:));
var_rho(1,:,:)=var_rho(2,:,:);
var_rho(Mp,:,:)=var_rho(M,:,:);

return

