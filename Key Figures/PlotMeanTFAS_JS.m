%Michael plots Figure 2 left side in Gili's important paper
cd('C:\Users\admin\Documents\GitHub\GradProject\Results\07_26_2022_23_40_46_mu_0_Js__3_5__0_5__7_runs_2\2')
target_num=2;
formatSpec = '%.1f';
mu=1;
J=-7.5:0.5:-3;
mainFolder = cd;%make sure the main folder doesnt contain spaces
str1='07_26_2022_23_40_46_mu_0_Js__3_5__0_5__7_runs_2\2';
num_of_runs_per_one=2;
number_of_rows_in_simulation_text=7;
key_fig_path='C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Key Figures';

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
cd(horzcat('C:\Users\admin\Documents\GitHub\GradProject\Results\',str1));
mu=0;
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
ZZ=zeros(length(J),size(INDEX2,1)*size(INDEX2,2)/length(J));

%   INDEX2=INDEX2-1;
for yy=1:1:(length(J))
    INDEX3= INDEX2(yy:length(J):end)-1;
    for jj=1:1:length(INDEX3)
        celll=table2array(text(INDEX3(jj),1));
        rock=celll{1,1};
        Ii=find( celll{1,1}==':');
        rockk=rock((Ii+2):end);
        ttt=str2num(rockk);
        % celll{1,1}
        % ttt= cellfun(@(x)str2double(x), regexp(table2array(text ((INDEX2(jj)):1:(INDEX2(jj+1)),1)),'\d*','Match'));
        ZZ(yy,jj)=ttt;
        %jj=jj+1;
        % This is for many Js
        % if jj == length(J)
        % break
        % end
    end
end
cd('C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Tfas_triag')
pop=median(ZZ,2);
% subplot(2,2,po);
% plot(flip(J(1:(end-1)),2),flip(pop(1:(end-1)),1));
% ylabel('Tfas Mean');
% xlabel('Js');
% title(horzcat('Tfas Mean(Js),Number of Targets',str2));
figure;


for yy=1:1:(length(J)) 
    a=(ZZ(yy,:));
[C,ia,ic] = unique(a);
a_counts = accumarray(ic,1);
try
value_counts = [C, a_counts];
catch
value_counts = [C, a_counts'];

end
BubblePlot(ones(1,size(a_counts,1))*J(length(J)-yy+1), C,3*log(a_counts) ,'b',8);
hold on;
end

% figure; scatter (J,flip(ZZ),60,'filled');
ylabel('T_{FAS}','FontSize',36)
xlabel('J_{s}','FontSize',36)
hold on;
plot(flip(J),pop,'r','LineWidth',5);
set(gca,'FontSize',36)
 fullscreen();
 cd(key_fig_path);
saveas(gcf,horzcat('Median_Tfas_J_','_with_Drive_',num2str(mu), '_Number_of_Targets_',str2,'.png'));
% title(horzcat('Tfas Distribution ' ,num2str(mu), ' Number of Targets ',str2),'FontSize',36);
% hold on;
% scatter(mu,pop,90,'d','k','filled');
end




