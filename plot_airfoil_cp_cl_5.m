% ATTENZIONE!! i file del cp devono essere salvati in una sola ed unica
% cartella con nome "data_cp". questa dovrà essere salvata nella stessa
% cartella dello script (file xxxxx.m)
%i file provenienti da xflr5 devono essere salvati come:
%nacaxxxx_cp_axx.txt !!!!! NO CARATTERE IN PIU, NE CARATTERE MENO!



filename       = 'dati_cp/NACA 0012.dat';
delimiterIn    = ' ';
headerlinesIn  = 1;
format long;

airfoil_struct = importdata(filename,delimiterIn,headerlinesIn);

fields = fieldnames(airfoil_struct);
coord  = char(fields(1));

airfoil_coord = airfoil_struct.(coord);

figure(1);
plot(airfoil_coord(:,1),airfoil_coord(:,2),'.','MarkerSize',20);
title('profilo alpha=0')

axis equal;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%mi creo la lista dei file nella directoy data

[~,cmdout] = system('dir /A:D /B');
if contains(cmdout, 'dati_cp') == 0
    error (' Directory data non presente...');
end

listafile = dir ('dati_cp/*.txt');
[n_file,b] = size(listafile);


%inizializzo parametri della rotazione
X=airfoil_coord(:,1);
Y=airfoil_coord(:,2);
Xc=0.5; 
Yc=0;
alpha=0;


for i = 1:n_file
    
    %-----------------cp-------------------------%
    
    filename = strcat("dati_cp","/",listafile(i).name);    %%posso levare "data" e sostituirla con cmdout per renderla piu generale, ma nella cartella di lavoro dovrei avere solo la cartella data !!!%%
    delimiterIn    = ' ';
    headerlinesIn  = 6;
    format long;

    analysis_struct = importdata(filename,delimiterIn,headerlinesIn);

    fields = fieldnames(analysis_struct);
    analysis  = char(fields(1));

    airfoil_analysis = analysis_struct.(analysis);
    
    
    
    
    
    %-------rotazione profilo----------------------%
    
    %trovo angolo alpha di cui dovrò ruotare il profilo
    alpha_str=extractBetween(filename,22,23);
    alpha=(str2double(alpha_str)/10)*pi/180;
   
     [Xr,Yr]=dueD_rotazione(X,Y,Xc,Yc,alpha);
    
     
     
     
    %------determinazione di Cl-------------------%
    
     [n_punti,colonne]= size(airfoil_coord);
     
     for k= 1:n_punti-1
         delta_L(k)=sqrt((airfoil_coord(k+1,1)-airfoil_coord(k,1))^2 + (airfoil_coord(k+1,2)-airfoil_coord(k,2))^2);
         normale(k,:)= [(airfoil_coord(k,1)-airfoil_coord(k+1,1))/delta_L(k),(airfoil_coord(k+1,2)-airfoil_coord(k,2))/delta_L(k)];
         
         cl_pannello(k)= delta_L(k)*normale(k,1)*airfoil_analysis(k,2);
         
         cd_pannello(k)=delta_L(k)*normale(k,2)*airfoil_analysis(k,2);
         
     end
    
   
    cl(i)=(sum(cl_pannello))';
    
    cd(i)=(sum(cd_pannello))';
    
    
    
    %---------PLOT-----------------------------%
    figure(i+1);
    
    subplot(2,1,1)
     plot(Xr,Yr,'b.','markersize',20)
     axis equal
     title('profilo con alpha')
     txt=['alpha: ' num2str(alpha*180/pi)];
     text(0.1,-0.1,txt)
     
    subplot(2,1,2)
     plot(airfoil_analysis(:,1),airfoil_analysis(:,2),'r.','MarkerSize',10)
     title('distribuzione di Cp'), xlabel('ascissa'), ylabel('Cp')
     txt=['alpha: ' num2str(alpha*180/pi)];
     text(0.1,-0.1,txt)
    hold on
    set(gca, 'YDir','reverse');
    
    
    hold off
end

%polinomio interpolatore a retta
w=1:n_file;
P=polyfit(w,cl,1);
f=@(x) [P(1).*x+P(2)];
x=linspace(0,alpha*180/pi,n_file);
y=f(x);




figure(20), clf
plot(x,cl,'g','markersize',20), hold on, plot(x,cd,'k','markersize',20), hold on, plot(x,y,'r')
axis equal
title('cl e cd')



