%Plot all the histogram etc
function [pop,linear_scale_std_minus]=Plot_Histograms_KLD_mu_sigma(mimi,mu,energy)


pop=median(mimi);
%assuming that for a guassian it is abour 34% of the data far away to the
%std in each side
mimi_sorted=sort(mimi);
pop_minus=mimi_sorted(floor(0.16*length(mimi)));
pop_plus=mimi_sorted(floor(0.84*length(mimi)));
aa=figure;
close(aa)
%  upp=histogram(mimi,length(mimi));
% upp=histogram(mimi);
%  if max(upp.BinEdges)<5*10^7
%     edges=[upp.BinEdges 5*10^7];
%     edges=linspace(0,edges(end),length(edges));
%     upp=histogram(mimi,edges);
%  else   
%  edges=[upp.BinEdges(1:(end-1)) 5*10^7];
%  edges=linspace(0,edges(end),length(edges));
%  upp=histogram(mimi,edges);
%  hold on;
%   bar(upp.BinEdges(2:end)-(upp.BinEdges(2)-upp.BinEdges(1))/2,[zeros(length(edges)-2,1);upp.Values(end)],1,'FaceColor','g'	)
%      
%  end

%Use unequal binning method, reference from 
%lognormal values binning 
timecap=5*10^7;
mimi_normal=log(mimi);
mean_n=mean(mimi_normal);
mimi_normal=log(mimi(mimi<timecap));
upp=histogram(mimi_normal);
binning=upp.BinEdges;
edgy=exp(binning);
edgy(1)=0;
edgy(end)=5*10^7;
a11=[edgy(edgy<pop)];
a1= [a11 edgy(length(a11)+1)];


upp2=histogram(mimi(mimi<timecap));
binning2=upp2.BinEdges;
edgy2=binning2;
rrr=sort(a1);
a2=edgy2(edgy2>rrr(end));
edgy=[rrr a2(2:end)];

if edgy(end)<5*10^7
edgy=[edgy 5*10^7-1 5*10^7+10^6];
else
edgy=[edgy(1:(end-1)) 5*10^7-1  5*10^7+10^6];
end

figure; 
upp=histogram(mimi,edgy);

 fullscreen();
% figure; scatter(mu,mimi(:),60,'filled');
ylabel('Count','FontSize',36);
xlabel('T_{FAS}','FontSize',36);
%title(horzcat('Tfas Distribution of mu ' , num2str(mu),' Strong Energy ',num2str(energy), ' Number of Targets ',str2),'FontSize',36);
set(gca,'FontSize',36)
normal_diturb_std_low=log(pop/pop_minus);
normal_diturb_std_high=log(pop_plus/pop);
hold on;
% scatter(pop,1,90,'d','k','filled');
[MM,iiii]=min(abs(upp.BinEdges-pop));
% try
% x= upp.BinEdges(iiii)+upp.BinWidth/2;
%  [M,II]=min(abs(upp.BinEdges-pop));
%  y=upp.Values(II);
% % bar(x,y,upp.BinWidth,'r');
c1=xline(pop,'--r','LineWidth',6);
c21=xline(pop_plus,'--m','LineWidth',6);
c21=xline(pop_minus,'--m','LineWidth',6);
linear_scale_std_minus=exp(mean_n)-exp(mean_n-normal_diturb_std_low);
% title(horzcat('Med_{N}=',num2str(log(pop),'%0.2e'),', \mu_{N}=',num2str(mean_n,'%0.2e'),' , \sigma_{N+}=',num2str(normal_diturb_std_high,'%0.2e'),' , \sigma_{N-}= ',num2str(normal_diturb_std_low,'%0.2e'),' , \sigma_{N-,l}= ',num2str(linear_scale_std_minus,'%0.2e')));
% catch
x= upp.BinEdges(end)-0.5*(upp.BinEdges(end)-upp.BinEdges(end-1));
y=length(find(mimi==5*10^7));
%  [M,II]=min(abs(upp.BinEdges-pop));
%  y=upp.Values(II-1);
hold on;
 bar(x,y,upp.BinEdges(end)-upp.BinEdges(end-1),'g');
% c1=xline(pop,'--r','LineWidth',6);
% end
%legend('Histogram Data','Median')
saveas(gcf,horzcat('Tfas_Histogram_of_mu_' , num2str(mu,'%.1f'),'_Strong_Energy_',num2str(energy,'%.1f'),'.png'));
close(gcf);

gh=figure;
mimi_2=mimi(mimi<5*10^7);
mimi_2=mimi_2/10000;
%cancel the idea of taking out the late samples, can we think of a rule of
%thumb when this is relveant? should we conider for example showing results
%only when the total counts inside the extraordinary bin is less then half o
% mimi_2=mimi;
[f,xi] = ksdensity(mimi/10000,'support','positive');
pd = fitdist(mimi_2','lognormal');
plot(xi,f,'LineWidth',6);
hold on;
% x_values = 0:10^5:1000*10^5;
 y = pdf(pd,xi);
 plot(xi,y,'LineWidth',6)
 fullscreen();
% figure; scatter(mu,mimi(:),60,'filled');
% ylabel('P','FontSize',36);
set(gca,'FontSize',36)
kde= horzcat('KDE (',' \mu = ' ,num2str(mean(pd),2),' , ','\sigma = ', num2str(std(pd),2),' ) ');
lognormal= horzcat('Lognormal Fit (',' \mu = ' ,num2str(mean(f.*xi*(xi(2)-xi(1)))*length(xi),2),' , ','\sigma = ', num2str(std(f.*xi*(xi(2)-xi(1)))*length(xi),2),' ) ');
 legend(kde,lognormal)
xlabel('T_{FAS} [Macro-Steps]','FontSize',36);
xlim([0 5*10^3])
% title(horzcat('Tfas Distribution of mu ' , num2str(mu),' Strong Energy ',num2str(energy), ' Number of Targets ',str2),'FontSize',36);
set(gca,'FontSize',36);
saveas(gcf,horzcat('Tfas_Distribution_of_mu_' , num2str(mu,'%.1f'),'_Strong_Energy_',num2str(energy,'%.1f'),'.png'));
a=regexprep(horzcat('Results_of_Tfas_Distribution_of_mu_' , num2str(mu,'%.1f'),'_Strong_Energy_',num2str(energy,'%.1f')),'\.','_'); 
A=convertStringsToChars(horzcat(a,'.mat'));
close(gh)
save(A,'mimi');

 

