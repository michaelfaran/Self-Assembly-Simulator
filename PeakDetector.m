
xxxx=array2table(Total_energy(1:end)');
yyy=table2array(groupcounts(xxxx,'Var1'));

rr=zeros(length(Total_energy),length(yyy(:,1)));
rr2=rr;
reak=rr;
morty=zeros(1,length(yyy(:,1)));
xxxx=array2table(Total_energy');
yyy=table2array(groupcounts(xxxx,'Var1'));
beginn=yyy(1);
endd=yyy(2);
% figure;plot(yy(:,1),yy(:,3));
for ii=3:1:length(Total_energy)
xxxx=array2table(Total_energy(1:ii)');
yy=table2array(groupcounts(xxxx,'Var1'));
mmm=yyy(:,1);
nnn=zeros(size(yyy,1),size(yyy,2));
nnn(:,1)=mmm;
lll=yy(:,1);
for kk=1:1:length(lll)
[INDEXx,mm]=find(mmm==lll(kk));
nnn(INDEXx,2)=yy(kk,2);
end
% [pks,locs]=findpeaks(yy(:,3));
% if ~isempty(locs)
%     for jj=1:1:length(locs)
%     I=find(yyy(:,1)==yy(locs(jj),1));
%     rr(ii,I)=yy(locs(jj),2);
%     end
% end
pp=nnn(:,2);
counter_peak_change_vec=zeros();
[pks,locs]=findpeaks(nnn(:,2));
if ~isempty(locs)
    for jj=1:1:length(locs)
    rr(ii,locs(jj))=pp(locs(jj));
    rr2(ii,locs(jj))=1;
    
    if (pp(locs(jj))~=0 && reak(ii-1,locs(jj))==0)
    reak(ii,locs(jj))=1;
    morty(locs(jj))=pp(locs(jj));
    elseif  ( pp(locs(jj))>morty(locs(jj)))
    morty(locs(jj))=morty(locs(jj))+1;
    reak(ii,locs(jj))=reak(ii-1,locs(jj))+1;
    elseif  (pp(locs(jj))<morty(locs(jj)))
    reak(ii,locs(jj))=0;
    morty(locs(jj))=0;
    elseif  (pp(locs(jj))==morty(locs(jj)))
    reak(ii,locs(jj))=reak(ii-1,locs(jj))  ; 
    end


    end
end
end

[X,Y] = meshgrid(1:1:size(rr,1),yyy(:,1));
figure;surf(X,Y,reak');
xlabel('Time (steps)','FontSize',36)
ylabel('Energy Values (KbT)','FontSize',36)
zlabel('Peak Appearance and Size','FontSize',36);
title('Histogram Peak With Time','FontSize',36);
set(gca,'FontSize',36);

figure;plot(yyy(:,1),reak(500,:));

xlabel('Time (steps)','FontSize',36)
ylabel('Energy Values (KbT)','FontSize',36)
title('Histogram Last Time Section','FontSize',36);
set(gca,'FontSize',36);

figure;plot(Total_energy);
xlabel('Time (steps)','FontSize',36)
ylabel('Energy Values (KbT)','FontSize',36)
title('Total energy','FontSize',36);
set(gca,'FontSize',36);
