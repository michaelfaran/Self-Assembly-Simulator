%Michael plots Figure 2 left side in Gili's important paper
cd('C:\Users\admin\Documents\GitHub\GradProject\Results\05_24_2022_19_05_42-Many_Drives_4_kbt\2')
target_num=2;
formatSpec = '%.1f';
mu=1;
J=-4;
mainFolder = cd;%make sure the main folder doesnt contain spaces
str1='\05_24_2022_19_05_42-Many_Drives_4_kbt\2';
num_of_runs_per_one=2;
number_of_rows_in_simulation_text=7;

%Meet the butcher
 [~,message,~] = fileattrib([mainFolder,'\*']);
 fprintf('\n There are %i total files & folders.\n',numel(message));
 allExts = cellfun(@(s) s(end-2:end),{message.Name},'uni',0);% Get file ext
 TXTidx = ismember(allExts,'txt');% Search extensions for "CSV" at the end 
 TXT_filepaths = {message(TXTidx).Name};  % Use idx of TXTs to list paths.
 fprintf('There are %i files with *.txt file ext.\n',numel(TXT_filepaths));


figure;

megaman='copy';
for po=1:1:length(target_num)
 megaman='copy  ';  
 counter=0;
 
 for ii = 1:numel(TXT_filepaths)
    % Do import here
 pivot=regexp(TXT_filepaths{1,ii},'\d*','Match');
 %if (str2double(pivot{1,19})==target_num(po) )   
 megaman=horzcat(megaman, TXT_filepaths{1,ii},'+');
 counter=counter+1;
 %end
 end
 cd(mainFolder)
 system(megaman);
 newname=num2str(target_num(po));
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
cd(horzcat('C:\Users\admin\Documents\GitHub\GradProject\Results',str1));
mu=0.8;
 INDEX=zeros(1,num_of_runs_per_one*numel(TXT_filepaths));
asaas=horzcat('2','.txt');
% txt=importdata(asaas);
 text = readtable(asaas);%was tihout the format and auto
aa = fileread( asaas );
% bb=txt.textdata;
% aa=table2cell(text(:,1));
C = strsplit(aa,'\n');
pivot_i=1;

gg=horzcat('beginning run with mu =',num2str(mu),' and with interaction =',num2str(J,formatSpec),'------');
for mm=1:1:length(C)
tf = contains(C{1,mm},'tfas');
if tf==1
INDEX(pivot_i)=mm;
pivot_i=pivot_i+1;
else
tf=0;
end


end

%check, assuming 2 is the sepereation in txt file rows, and 7 is the number
%rows
INDEX2=INDEX(INDEX~=0);
%if min(INDEX)==0
    %INDEX2=INDEX+2;
    length_NEW_INDEX=length(find (INDEX~=0));
%     new_indicate=number_of_rows_in_simulation_text;
%     for jj=1:1:(num_of_runs_per_one)
%     for ii=1:1:length_NEW_INDEX
%     INDEX2(num_of_runs_per_one*(ii-1)+jj)=INDEX(ii)+2+(jj-1)*new_indicate;
%     end
%     end
%end
% ll=length(cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(1)):15:(INDEX(1+1)-3),2)),'\d*','Match')));
ZZ=zeros(length(J),length(INDEX2));
%jj=1;
% INDEX=[INDEX length(aa)];
%INDEX(end)=length(C);
 INDEX2=INDEX2-2;
for jj=1:1:length(INDEX2)
for yy=1:1:(length(J))
celll=table2array(text(INDEX2(jj),2));
rock=celll{1,1};
Ii=find( celll{1,1}==':');
rockk=rock((Ii+2):end);
ttt=str2num(rockk);
% celll{1,1}
% ttt= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX2(jj)):1:(INDEX2(jj+1)),1)),'\d*','Match'));
ZZ(:,jj)=ttt;
%jj=jj+1;
% This is for many Js
% if jj == length(J)
% break
% end
end
end
pop=median(ZZ,2);
% subplot(2,2,po);
% plot(flip(J(1:(end-1)),2),flip(pop(1:(end-1)),1));
% ylabel('Tfas Mean');
% xlabel('Js');
% title(horzcat('Tfas Mean(Js),Number of Targets',str2));
figure; scatter(mu,ZZ(:),60,'filled');
ylabel('Tfas Distribution','FontSize',36);
xlabel('Drive Mu','FontSize',36);
title(horzcat('Tfas Distribution ' ,num2str(mu), ' Number of Targets ',str2),'FontSize',36);
hold on;
scatter(mu,pop,90,'d','k','filled');
end




