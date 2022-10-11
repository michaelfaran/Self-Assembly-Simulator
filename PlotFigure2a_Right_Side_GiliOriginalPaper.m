%Michael plots Figure 2 left side in Gili's important paper
% 'C:\Users\admin\Documents\GitHub\GradProject\Results\new'
mainFolder ='C:\Users\admin\Documents\GitHub\GradProject\Results\new'; % Select your Main folder
 [~,message,~] = fileattrib([mainFolder,'\*']);
 fprintf('\n There are %i total files & folders.\n',numel(message));
 allExts = cellfun(@(s) s(end-2:end),{message.Name},'uni',0);% Get file ext
 TXTidx = ismember(allExts,'txt');% Search extensions for "CSV" at the end 
 TXT_filepaths = {message(TXTidx).Name};  % Use idx of TXTs to list paths.
 fprintf('There are %i files with *.txt file ext.\n',numel(TXT_filepaths));
% megaman='copy';
max_distance=1; %I think 172 is max
%  for ii = 1:numel(TXT_filepaths)
%     % Do import here
%  megaman=horzcat(megaman,'+', TXT_filepaths{1,ii});
%  end



target_num=1:1:4;
% target_num=2;

formatSpec = '%.1f';
figure;

megaman='copy';
for po=1:1:length(target_num)
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
mu=0;
J=-6:0.5:-3;
J=flip(J,2);

asaas=horzcat(str2,'.txt');
% txt=importdata(asaas);
 text = readtable(asaas);%was tihout the format and auto
aa = fileread( asaas );
% bb=txt.textdata;
% aa=table2cell(text(:,1));
C = strsplit(aa,'\n');

INDEX2=zeros(1,length(J));

for ii=1:1:length(J) 
tar_num=0;
pivot=0;
gg=horzcat('beginning run with mu =',num2str(mu),' and with interaction =',num2str(J(ii),formatSpec),'------');

for mm=1:1:length(C)
tf = strcmp(C{1,mm},gg);
if tf==1    
    pivot=pivot+1;
    INDEX2(1,ii)=pivot;
end
end
end


sizej=max(INDEX2);
INDEX=zeros(sizej,length(J)+1);
for ii=1:1:length(J)
jj=1;
for mm=1:1:length(C)
gg=horzcat('beginning run with mu =',num2str(mu),' and with interaction =',num2str(J(ii),formatSpec),'------');
tf = strcmp(C{1,mm},gg);
if tf==1
INDEX(jj,ii)=mm;
jj=jj+1;
else
tf=0;
end

end
end
INDEX(:,end)=[INDEX(2:end,1)-1; size(text,1)];

%assuming alll is one, and one is equal
ll=length(cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(1,1)+1):4:(INDEX(1,1+1)-2),1)),'\d*','Match')));
% ll=length(cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(ii,mm)+1):4:(INDEX(ii,mm+1)-2),1)),'\d*','Match')));

ZZ=zeros(length(J),sizej,ll);
DD=zeros(length(J),sizej,ll);

for mm=1:1:sizej
for  ii=1:1:length(J)

% for yy=1:1:ll

% INDEX(jj,mm)=length(C);
% ttt= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(mm,jj)):3:(INDEX(mm,jj+1)-3),1)),'\d*','Match'));
ttt= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(mm,ii)+1):4:(INDEX(mm,ii+1)-2),1)),'\d*','Match'));
ZZ(ii,mm,1:ll)=ttt;
ppp= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(mm,ii)+2):4:(INDEX(mm,ii+1)-1),1)),'\d.*','Match'));
DD(ii,mm,1:ll)=ppp;

% jj=jj+1;

end
end
ZZZ=reshape(ZZ,[size(ZZ,1) size(ZZ,2)*size(ZZ,3)]);
DDD=reshape(DD,[size(DD,1) size(DD,2)*size(DD,3)]);
pop=median(ZZZ,2);
rock= median(DDD,2)/max_distance; 
subplot(4,1,po);

yyaxis left
% set( get(subplot(2,1,i),'YLabel'), 'String', 'left Y label' );
plot(flip(J(1:(end)),2),flip(pop(1:(end)),1));
set( get(subplot(4,1,po),'YLabel'), 'String', 'Time in Target' );


yyaxis right
plot(flip(J(1:(end)),2),flip(rock(1:(end)),1));
set( get(subplot(4,1,po),'YLabel'), 'String', 'Average Distance');


% ylabel('Time In Target');
xlabel('Js');
title(horzcat('Time In Target(Js) and Avg Distance ,Number of Targets',str2));

end
sgtitle('All the Time In Targets and Distances') 

