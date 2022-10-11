%9/10/22- Michael Chnges name here, it is important for the future


%Michael plots Figure 2 left side in Gili's important paper
% 'C:\Users\admin\Documents\GitHub\GradProject\Results\new'
% mainFolder ='C:\Users\admin\Documents\GitHub\GradProject\Results\new'; % Select your Main folder


clear
close all
mainFolder ='C:\Users\admin\Documents\GitHub\GradProject\Results\03_08_2022_18_33_12-free_market\2';

nameN=' Free Market';
[~,message,~] = fileattrib([mainFolder,'\*']);
fprintf('\n There are %i total files & folders.\n',numel(message));
allExts = cellfun(@(s) s(end-2:end),{message.Name},'uni',0);% Get file ext
TXTidx = ismember(allExts,'txt');% Search extensions for "CSV" at the end 
TXT_filepaths = {message(TXTidx).Name};  % Use idx of TXTs to list paths.
fprintf('There are %i files with *.txt file ext.\n',numel(TXT_filepaths));



N = {S.name};
X = ~cellfun('isempty',strfind(N,num2str(9129)));
I = imread(fullfile(P,N{X}))

% megaman='copy';
max_distance=1; %I think 172 is max
max_time =5*10^7 -1;
%  for ii = 1:numel(TXT_filepaths)
%     % Do import here
%  megaman=horzcat(megaman,'+', TXT_filepaths{1,ii});
%  end



%target_num=1:1:4;
 target_num=2;
targetnumvec=2;
formatSpec = '%.1f';


megaman='copy';
for ppo=1:1:length(target_num)
 po= targetnumvec(ppo);
 megaman='copy  ';  
 counter=0;
 
 for ii = 1:numel(TXT_filepaths)
    % Do import here
 pivot=regexp(TXT_filepaths{1,ii},'\d*','Match');
 try
 if (str2double(pivot{1,7})==po )   
 megaman=horzcat(megaman, TXT_filepaths{1,ii},'+');
 counter=counter+1;
 end
 catch
 continue
 end
 end
 cd(mainFolder)
 system(megaman);
 newname=num2str(po);
x = dir ('*.txt');
adrr=struct2cell(x);
for ip=1:1:size(adrr,2)
if contains(adrr{1,ip},'output')
movefile(adrr{1,ip},horzcat(newname,'.txt'))
end
end
end

for po=1:1:length(target_num)
str2=num2str(target_num(po));
cd(mainFolder);
mu=0:1:2;
J=-6:0.5:-3;
J=flip(J,2);

asaas=horzcat(str2,'.txt');
% txt=importdata(asaas);
 text = readtable(asaas);%was tihout the format and auto
aa = fileread( asaas );
% bb=txt.textdata;
% aa=table2cell(text(:,1));
C = strsplit(aa,'\n');

INDEX2=zeros(1,length(J),length(mu));
for kk=1:1:length(mu)
for ii=1:1:length(J) 
tar_num=0;
pivot=0;
gg=horzcat('beginning run with mu =',num2str(mu(kk)),' and with interaction =',num2str(J(ii),formatSpec),'------');

for mm=1:1:length(C)
tf = strcmp(C{1,mm},gg);
if tf==1    
    pivot=pivot+1;
    INDEX2(1,ii,kk)=pivot;
end
end
end
end

sizej=max(max(INDEX2));
INDEX=zeros(sizej,length(J)+1,length(mu)+1);
for kk=1:1:length(mu)
for ii=1:1:length(J)
jj=1;
for mm=1:1:length(C)
gg=horzcat('beginning run with mu =',num2str(mu(kk)),' and with interaction =',num2str(J(ii),formatSpec),'------');
tf = strcmp(C{1,mm},gg);
if tf==1
INDEX(jj,ii,kk)=mm;
jj=jj+1;
else
tf=0;
end

end
end
end
%INDEX(:,end)=[INDEX(2:end,1)-1; size(text,1)];
%Michael ass 22/2/22 GG for good
offset=INDEX(1,2,1)- INDEX(1,1,1);
for ki=1:1:size(INDEX,1)
INDEX(ki,end,1:end)=INDEX(ki,end-1,1:end)+offset;
end

for ki=1:1:size(INDEX,1)
for kil=1:1:(size(INDEX,2)-1)

INDEX(ki,kil,size(INDEX,3))=INDEX(ki,kil+1,1)-2;
end
end

sizej=sizej-1;
%assuming alll is one, and one is equal
%ll=length(cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(1,1,1)):6:(INDEX(1,1,1+1)-2),2)),'\d*','Match')));
ll= length(table2array(text ((INDEX(1,1,1)):7:(INDEX(1,1,1+1)-2),2)));
% ll=length(cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(ii,mm)+1):4:(INDEX(ii,mm+1)-2),1)),'\d*','Match')));

ZZ=zeros(length(J),length(mu),sizej,ll);
DD=zeros(length(J),length(mu),sizej,ll);
DD2=DD;
DD3=DD;
for mm=1:1:sizej
for kk=1:1:length(mu)
for  ii=1:1:length(J)

% for yy=1:1:ll

% INDEX(jj,mm)=length(C);
% ttt= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(mm,jj)):3:(INDEX(mm,jj+1)-3),1)),'\d*','Match'));
%ttt= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(mm,ii,kk)):6:(INDEX(mm,ii,kk+1)-2),1)),'\d*','Match'));
ttt= table2array(text ((INDEX(mm,ii,kk)):7:(INDEX(mm,ii,kk+1)-2),2));
ZZ(ii,kk,mm,1:ll)=ttt;
%ppp= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(mm,ii,kk)+1):6:(INDEX(mm,ii,kk+1)-1),1)),'\d.*','Match'));
ppp= table2array(text ((INDEX(mm,ii,kk)+2):7:(INDEX(mm,ii,kk+1)),2));
DD(ii,kk,mm,1:ll)=ppp;

%ppp2= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(mm,ii,kk)+1):6:(INDEX(mm,ii,kk+1)-1),1)),'\d.*','Match'));
ppp2= table2array(text ((INDEX(mm,ii,kk)+3):7:(INDEX(mm,ii,kk+1)+1),2));
DD2(ii,kk,mm,1:ll)=ppp2;

%ppp2= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(mm,ii,kk)+1):6:(INDEX(mm,ii,kk+1)-1),1)),'\d.*','Match'));
ppp3= table2array(text ((INDEX(mm,ii,kk)+4):7:(INDEX(mm,ii,kk+1)+1),2));
DD3(ii,kk,mm,1:ll)=ppp3;
% jj=jj+1;
end
end
end
ZZZ=reshape(ZZ,[size(ZZ,1) size(ZZ,2) size(ZZ,3)*size(ZZ,4)]);
DDD=reshape(DD,[size(DD,1) size(DD,2) size(DD,3)*size(DD,4)]);
DDD2=reshape(DD2,[size(DD2,1) size(DD2,2) size(DD2,3)*size(DD2,4)]);
DDD3=reshape(DD3,[size(DD3,1) size(DD3,2) size(DD3,3)*size(DD3,4)]);

Indexd=find (DDD2==1);
DDD2(Indexd)= max_time;
pop=median(ZZZ,3);
poper=std(ZZZ,0,3);
rock= median(DDD,3)/max_distance; 
rocker=std(DDD,0,3);
metali= median(DDD2,3);
metaleri=std(DDD2,0,3);
metaleri(metaleri==0)=1;
electronici =median(DDD3,3);
electroniceri =std(DDD3,0,3);
electroniceri(electroniceri==0)=1;


%log10 of the electronic

metal=log10(metali);
metaler=log10 (metaleri);
metalt= metali;
metalert=metaleri;

%log10 of the metal
electronic=log10(electronici);
electronicer=log10 (electroniceri);
electronict= electronici;
electronicert=electroniceri;

%plot the tfas
FigH = figure('Position', get(0, 'Screensize'));
subplot(4,1,1);
 errorbar(flip(J(1:(end)),2),flip(pop(:,1),1),flip(poper(:,1),1),'Color',[0 0.4470 0.7410]);
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,2),1));
 errorbar(flip(J(1:(end)),2),flip(pop(:,2),1),flip(poper(:,2),2),'Color',[0.8500 0.3250 0.0980]);
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,3),1));
 errorbar(flip(J(1:(end)),2),flip(pop(:,3),1),flip(poper(:,3),2),'Color',[0.9290 0.6940 0.1250]);


lgt=legend('\mu=0','\mu=1','\mu=2');
title(horzcat('Seed Median Tfas for Drives and Energies of',' ',nameN))
ylh=ylabel('tfas [steps]');
xlabel('Energy [KT]')
set(gca,'FontSize',20)
limsy=get(gca,'YLim');
limsy(2)=5*10^7;
set(gca,'Ylim',[0 limsy(2)]);
N=5;% number of ticks
veccc=floor((0:1:N)*(limsy(2)+1)/N);
yticks([veccc])
dy=0;
 % adding ylabelto figure

ylh.Position(1)=ylh.Position(1)-dy;
pivoting=ylh.Position(1);

%plot the average distance
subplot(4,1,2);

 errorbar(flip(J(1:(end)),2),flip(rock(:,1),1),flip(rocker(:,1),1));
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,2),1));
 errorbar(flip(J(1:(end)),2),flip(rock(:,2),1),flip(rocker(:,2),2));
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,3),1));
 errorbar(flip(J(1:(end)),2),flip(rock(:,3),1),flip(rocker(:,3),2));

lgt=legend('\mu=0','\mu=1','\mu=2');
title(horzcat('Seed Average Distance  for Drives and Energies of',' ',nameN))
ylh=ylabel('Distance');
xlabel('Energy [KT]')

set(gca,'FontSize',20)
limsy=get(gca,'YLim');
set(gca,'Ylim',[0 limsy(2)]);
%ylh.Position(1)=pivoting;
%plot the dissassemble time

subplot(4,1,3);
yyaxis left
 errorbar(flip(J(1:(end)),2),flip(metal(:,1),1),flip(metaler(:,1),1),'LineStyle', '-','Color',[0 0.4470 0.7410]);
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,2),1));
 errorbar(flip(J(1:(end)),2),flip(metal(:,2),1),flip(metaler(:,2),2),'LineStyle', '-','Color',[0.8500 0.3250 0.0980]);
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,3),1));
 errorbar(flip(J(1:(end)),2),flip(metal(:,3),1),flip(metaler(:,3),2),'LineStyle', '-','Color',[0.9290 0.6940 0.1250]);

% 
%  plot(flip(J(1:(end)),2),flip(metal(:,1),1));
% hold on
% plot(flip(J(1:(end)),2),flip(metal(:,2),1));
% hold on
% plot(flip(J(1:(end)),2),flip(metal(:,3),1));
lgt=legend('\mu=0','\mu=1','\mu=2');
title(horzcat('Seed Log Dissamasemble Time for Drives and Energies of',' ',nameN))
ylh=ylabel({'Log Diassemble';'Time [steps]'} );
ylim([3 8])
yticks([3:1:8])
xlabel('Energy [KT]')
set(gca,'FontSize',20)
%ylh.Position(1)=pivoting;

 yyaxis right
% % set( get(subplot(2,1,i),'YLabel'), 'String', 'left Y label' );
% plot(flip(J(1:(end)),2),flip(pop(1:(end)),1));
% set( get(subplot(4,1,po),'YLabel'), 'String', 'Time in Target' );

lgt=legend('\mu=0','\mu=1','\mu=2');
title(horzcat('Seed Dissamasemble Time for Drives and Energies of',' ',nameN))
ylh=ylabel({'Diassemble';'Time [steps]'} );
xlabel('Energy [KT]')
limsy=get(gca,'YLim');
gg=5*10^7;
set(gca,'Ylim',[0 gg]);
% ylh.Position(1)=pivoting;
set(gca,'FontSize',20)

% yyaxis left
% % set( get(subplot(2,1,i),'YLabel'), 'String', 'left Y label' );
% plot(flip(J(1:(end)),2),flip(pop(1:(end)),1));
% set( get(subplot(4,1,po),'YLabel'), 'String', 'Time in Target' );



yyaxis right
% plot(flip(J(1:(end)),2),flip(rock(1:(end)),1));
% set( get(subplot(4,1,po),'YLabel'), 'String', 'Average Distance');


 errorbar(flip(J(1:(end)),2),flip(metalt(:,1),1),flip(metalert(:,1),1),'LineStyle', '--','Color',[0 0.4470 0.7410]);
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,2),1));
 errorbar(flip(J(1:(end)),2),flip(metalt(:,2),1),flip(metalert(:,2),2),'LineStyle', '--','Color',[0.8500 0.3250 0.0980]);
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,3),1));
 errorbar(flip(J(1:(end)),2),flip(metalt(:,3),1),flip(metalert(:,3),2),'LineStyle', '--','Color',[0.9290 0.6940 0.1250]);

% 
%  plot(flip(J(1:(end)),2),flip(metal(:,1),1));
% hold on
% plot(flip(J(1:(end)),2),flip(metal(:,2),1));
% hold on
% plot(flip(J(1:(end)),2),flip(metal(:,3),1));
lgt=legend('\mu=0','\mu=1','\mu=2');
title(horzcat('Seed Dissamasemble Time for Drives and Energies of',' ',nameN))
ylh=ylabel({'Diassemble';'Time [steps]'} );
xlabel('Energy [KT]')
limsy=get(gca,'YLim');
gg=5*10^7;
set(gca,'Ylim',[0 gg]);
% ylh.Position(1)=pivoting;
set(gca,'FontSize',20)

% yyaxis left
% % set( get(subplot(2,1,i),'YLabel'), 'String', 'left Y label' );

% set( get(subplot(4,1,po),'YLabel'), 'String', 'Time in Target' );
% 
% 
% yyaxis right
% plot(flip(J(1:(end)),2),flip(rock(1:(end)),1));
% set( get(subplot(4,1,po),'YLabel'), 'String', 'Average Distance');
% 
% 
% % ylabel('Time In Target');
% xlabel('Js');
% title(horzcat('Time In Target(Js) and Avg Distance ,Number of Targets',str2));

subplot(4,1,4);
yyaxis left
% plot(flip(J(1:(end)),2),flip(rock(1:(end)),1));
% set( get(subplot(4,1,po),'YLabel'), 'String', 'Average Distance');


 errorbar(flip(J(1:(end)),2),flip(electronic(:,1),1),flip(electronicer(:,1),1),'LineStyle', '-','Color',[0 0.4470 0.7410]);
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,2),1));
 errorbar(flip(J(1:(end)),2),flip(electronic(:,2),1),flip(electronicer(:,2),2),'LineStyle', '-','Color',[0.8500 0.3250 0.0980]);
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,3),1));
 errorbar(flip(J(1:(end)),2),flip(electronic(:,3),1),flip(electronicer(:,3),2),'LineStyle', '-','Color',[0.9290 0.6940 0.1250]);
lgt=legend('\mu=0','\mu=1','\mu=2');
title(horzcat('Seed Log Dissamasemble Time for Drives and Energies of',' ',nameN))
ylh=ylabel({'Log Diassemble';'Time [steps]'} );
ylim([3 8])
yticks([3:1:8])
xlabel('Energy [KT]')
set(gca,'FontSize',20)

yyaxis right
 errorbar(flip(J(1:(end)),2),flip(electronict(:,1),1),flip(electronicert(:,1),1),'LineStyle', '--','Color',[0 0.4470 0.7410]);
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,2),1));
 errorbar(flip(J(1:(end)),2),flip(electronict(:,2),1),flip(electronicert(:,2),2),'LineStyle', '--','Color',[0.8500 0.3250 0.0980]);
hold on
%plot(flip(J(1:(end)),2),flip(pop(:,3),1));
 errorbar(flip(J(1:(end)),2),flip(electronict(:,3),1),flip(electronicert(:,3),2),'LineStyle', '--','Color',[0.9290 0.6940 0.1250]);


lgt=legend('\mu=0','\mu=1','\mu=2');
title(horzcat(' "Wrong" Seed Dissamasemble Time for Drives and Energies of',' ',nameN))
ylh=ylabel({'Diassemble';'Time [steps]'} );
xlabel('Energy [KT]')
limsy=get(gca,'YLim');
 gg=max(max(electronict));
 set(gca,'Ylim',[0 gg]);
% ylh.Position(1)=pivoting;
set(gca,'FontSize',20)
cd('C:\Users\admin\Documents\GitHub\GradProject\figures')
saveas(FigH, nameN,'png');
savefig(FigH,nameN)

end
% sgtitle('All the Time In Targets and Distances') 

