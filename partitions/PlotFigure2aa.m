%Michael plots Figure 2 left side in Gili's important paper
'C:\Users\admin\Documents\GitHub\GradProject\Results\new'
mainFolder = uigetdir(); % Select your Main folder
 [~,message,~] = fileattrib([mainFolder,'\*']);
 fprintf('\n There are %i total files & folders.\n',numel(message));
 allExts = cellfun(@(s) s(end-2:end),{message.Name},'uni',0);% Get file ext
 TXTidx = ismember(allExts,'txt');% Search extensions for "CSV" at the end 
 TXT_filepaths = {message(TXTidx).Name};  % Use idx of TXTs to list paths.
 fprintf('There are %i files with *.txt file ext.\n',numel(TXT_filepaths));
% megaman='copy';

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
 if (str2double(pivot{1,7})==po )   
 megaman=horzcat(megaman, TXT_filepaths{1,ii},'+');
 counter=counter+1;
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
cd(horzcat('C:\Users\admin\Documents\GitHub\GradProject\Results\new\',str2));
mu=0;
J=-6.5:0.5:-3;
J=flip(J,2);
INDEX=zeros(1,length(J));
asaas=horzcat('output_01_05_2022_18_57_51_targets_',str2,'.txt');
% txt=importdata(asaas);
 text = readtable(asaas);%was tihout the format and auto
aa = fileread( asaas );
% bb=txt.textdata;
% aa=table2cell(text(:,1));
C = strsplit(aa,'\n');

for ii=1:1:length(J)
gg=horzcat('beginning run with mu =',num2str(mu),' and with interaction =',num2str(J(ii),formatSpec),'------');
for mm=1:1:length(C)
tf = strcmp(C{1,mm},gg);
if tf==1
INDEX(ii)=mm;
else
tf=0;
end
end

end

ll=length(cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(1)):3:(INDEX(1+1)-3),2)),'\d*','Match')));
ZZ=zeros(length(J),ll);
jj=1;
% INDEX=[INDEX length(aa)];
INDEX(end)=length(C);
for yy=1:1:(length(J))
ttt= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX(jj)):3:(INDEX(jj+1)-3),2)),'\d*','Match'));
ZZ(yy,:)=ttt;
jj=jj+1;
if jj == length(J)
break
end
end

pop=median(ZZ,2);
subplot(2,2,po);
plot(flip(J(1:(end-1)),2),flip(pop(1:(end-1)),1));
ylabel('Tfas Mean');
xlabel('Js');
title(horzcat('Tfas Mean(Js),Number of Targets',str2));
end
