function [Xr,Yr]=dueD_rotazione(X,Y,Xc,Yc,alpha)
%function [Xr,Yr]=2d_rotazione(X,Y,Xc,Yc,alpha)
%questa funzione ruota una serie di punti che costituiscono una curva 2D
%intorno un punto centrale di un certo angolo 
%
%INPUT
%X= vettore contenente le ascisse dei punti da ruoteare
%Y=vettore contenente le ordinate dei punti da ruotare
%Xc=ascissa centro di rotazione
%Yc=ordinata centro di rotazione
%alpaha=angolo di rotazione
%
%OUTPUT
%Xr=vettore contenente le ascisse dei punti ruotati
%Yr=vettore contenente le ordinate dei punti ruotati

for k=1:length(X)
   Xr(k) =  (X(k)-Xc)*cos(alpha) + (Y(k)-Yc)*sin(alpha) + Xc;
   Yr(k) = -(X(k)-Xc)*sin(alpha) + (Y(k)-Yc)*cos(alpha) + Yc;
end

figure,
plot(X,Y,'r*'), hold on, plot(Xr,Yr,'bo'), hold on, plot(Xc,Yc,'g.','markersize',20), hold off

end