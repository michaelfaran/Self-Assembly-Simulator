%create Recurrance Rate function
epslion_vec=1:1:100;
Total_energy2=Total_energy-mean(Total_energy);
Total_energy2=Total_energy2/max(Total_energy2);

ENTR_vec=zeros(size(epslion_vec,1),length(delays));
RR_vec=zeros(size(epslion_vec,1),length(delays));

for ii=10:1:length(delays)
    for jj=1:1:length(epslion_vec)
        y=embed(Total_energy,dime_vec(ii),floor(delays(ii))-1);
        [R,D]=rp(y,epslion_vec(jj),'fix','max');
        R=R-diag(diag(R));
        z=rqa(R,1,0);
        ENTR_vec(jj,ii)=z(5);
        RR_vec(jj,ii)=z(1);
        
    end
end


delay=200;
d=2;
drive=1;
Js=-5;
Total_energy2=Total_energy-mean(Total_energy);
Total_energy2=Total_energy2/max(Total_energy2);
N = length(Total_energy2); % length of time series
y = embed(Total_energy2,d,delay); % embed into 2 dimensions using delay 17
index_y=embed(1:1:length(Total_energy2),d,delay);

figure;
% epsilon_vec=0.1:0.1:10;
% epsilon_vec=10;
% recurrurence_vec=zeros(size(epsilon_vec));
% entropy_vec=zeros(size(epsilon_vec));
[R,D]=rp(y,0,'fix','max');
h= histogram(D);
gcf;

vec_val=sort(h.BinEdges);
%lek=length(h.BinEdges);
%high_per=floor(0.95*lek);
%low_per=floor( 0.5*lek);
high_per=95;
low_per=5;
cdf= 100*cumsum(h.Values)/sum(h.Values);
%mega_eps_vec=linspace(vec_val(low_per),vec_val(high_per),num_of_eps_val);
num_of_eps_val=50;
mega_eps_vec=linspace(vec_val(find(cdf>low_per,1)),vec_val(find(cdf>high_per,1)),num_of_eps_val);






labelss=zeros(size(y,1),num_of_eps_val);
close(gcf);
for ii=1:1:num_of_eps_val
[R,D]=rp(y,mega_eps_vec(ii),'fix');
R=R-diag(diag(R));
%recurrurence_vec(ii) = sum(sum(R))/(length(recurrurence_vec).*length(recurrurence_vec)); % calculate RP using maximum norm and fixed threshold
%z=rqa(R,1,0);

G = graph(R);

%labels = dbscan(R,30,1);
yyy=figure;
a = axes;
hh=plot(a,G);
X=zeros(length(hh.XData),2);
X(:,1)=hh.XData;
X(:,2)=hh.YData;
close(yyy)
%the value here  in minpts should just be bigger than the dimension of plus 1 the size
%of X according to matlab suggestion
minpts =3;
kD = pdist2(X,X,'euc','Smallest',minpts);
% figure;
% plot(sort(kD(end,:)));
% title('k-distance graph')
% xlabel('Points sorted with 4th nearest distances')
% ylabel('50th nearest distances')
sortedkD=sort(kD(end,:));  
[res_x, idx_of_result] = knee_pt(sortedkD,1:1:length(kD),0);
epsilon=sortedkD(idx_of_result);
%grid
% epsilon=1;
%labels = dbscan(X,epsilon,minpts);
labelss(:,ii)= dbscan(X,epsilon,minpts); 
end

unik=sort(unique(labelss));
allisNaN=NaN(length(unik),size(labelss,2));
allisJaN=allisNaN;
for jj=1:1:size(labelss,2)
for ii=1:1:length(unik)
unkir =unique(labelss(:,jj));
try
allisNaN(ii,jj)=unik(find(unkir==unik(ii)));
[GC,GR] = groupcounts(labelss(:,jj));
allisJaN(find(unik==GR(ii)) ,jj)=GC(find(GR==unik(ii)));
catch
continue    
end
end
end

allisNaN_index=sum(isnan(allisNaN),1);
Surviving_similar_modules=ones(1,size(allisNaN,2));
Surviving_similar_modules(1)=0;
Surviving_similar_modules(end)=0;
%add the threedom of Module sizes as in the paper "Identifiying metastables
%states in non linear timeseries, 2014"

for ii=2:1:(size(allisJaN,2)-1)
    if (allisNaN_index(ii-1)~= allisNaN_index(ii)) ||  (allisNaN_index(ii)~= allisNaN_index(ii+1))
    Surviving_similar_modules(ii)=0;
    end

end


allisOne=allisJaN(:,find(Surviving_similar_modules==1));
%tribute to orphaned land though a dad joke is the name of variable above
%Now doing the number of modes selection according to the paper
Tolerance_vec=floor((0.01:0.01:0.1)*size(y,1));
IWillSurvive=zeros(size(allisOne,1),size(allisOne,2),length(Tolerance_vec));
IWillSurvive2live=[zeros(size(allisOne,1),1) abs(allisOne(:,2:end)-allisOne(:,1:(end-1)))];
IND=find(Surviving_similar_modules==1);
mega_eps_vec2=repmat(mega_eps_vec(IND),length(Tolerance_vec),1);
mega_eps_vec2=mega_eps_vec2';
for jj=1:1:length(Tolerance_vec)
    for ii=1:1:size(allisJaN,1)
    PivotMan=zeros(size(IWillSurvive2live(ii,:)));
    I=find(IWillSurvive2live(ii,:)<Tolerance_vec(jj));
    %I2=find(~(IWillSurvive2live(ii,:)<Tolerance_vec(jj)));
    PivotMan(I)=1;    
    IWillSurvive(ii,:,jj)=PivotMan;
    end
end

%finding gthe appropriate epsilon now
Final_eps=mega_eps_vec2(find (squeeze(sum(IWillSurvive,1))'~=0,1));

%Now back to calculate the new R;
[R,D]=rp(y,Final_eps,'fix','max');
R=R-diag(diag(R));


% 
% figure;
% imagesc(R);
% colorbar
% title(horzcat('Recurrence Plot, Euclidean Distance is ',num2str(epsilon_vec(ii)),' Delay in Big Steps and Dimension are ',num2str(delay),' & ',num2str(d)),'FontSize',42)
% ylabel('Vec Number','FontSize',42)
% xlabel('Vec Number','FontSize',42)

%Now paint the figure

G = graph(R);

%labels = dbscan(R,30,1);
yyy=figure;
a = axes;
hh=plot(a,G);
X=zeros(length(hh.XData),2);
X(:,1)=hh.XData;
X(:,2)=hh.YData;
close(yyy)
%the value here  in minpts should just be bigger than the dimension of plus 1 the size
%of X according to matlab suggestion
minpts = 50;
kD = pdist2(X,X,'euc','Smallest',minpts);
% figure;
% plot(sort(kD(end,:)));
% title('k-distance graph')
% xlabel('Points sorted with 4th nearest distances')
% ylabel('50th nearest distances')
sortedkD=sort(kD(end,:));  
[res_x, idx_of_result] = knee_pt(sortedkD,1:1:length(kD),0);
epsilon=sortedkD(idx_of_result);
%grid
% epsilon=1;
%labels = dbscan(X,epsilon,minpts);
labelss= dbscan(X,epsilon,minpts); 




figure; 
 gscatter( X(:,1), X(:,2),labelss);
 new_labels=zeros(1,length(Total_energy2));
 for ii=1:1:length(Total_energy2)
    [r,c]=find(index_y==ii);
    state= max(labelss(r));
    new_labels(ii) =state;
 end

vec_val2=unique(new_labels);

for ii=1:1:length(vec_val2)
find(new_labels==vec_val2(ii));

end
rooster= figure;
plot(Total_energy);
hold on
for ii=1:1:length(vec_val2)
scatter(find(new_labels==vec_val2(ii)),Total_energy(find(new_labels==vec_val2(ii))),200,'filled')

end
title(horzcat('Clustered Total Energy, Js is ',num2str(Js),' mu is ',num2str(drive)),'FontSize',42)
xlabel('Step','FontSize',42)
ylabel('Total Energy(k_{B}T)','FontSize',42);
saveas(rooster,horzcat('Clustered Total Energy, Js is ',num2str(Js),' mu is ',num2str(drive),'.png'))
