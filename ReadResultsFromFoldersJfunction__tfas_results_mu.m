cd('C:\Users\admin\Documents\GitHub\GradProject\Results\12_05_2021_13_51_17');
%open('C:\Users\admin\Documents\GitHub\GradProject\Results\12_05_2021_13_51_17');
%each file contains
 d = dir('C:\Users\admin\Documents\GitHub\GradProject\Results\12_05_2021_13_51_17');
% remove all files (isdir property is 0)
dfolders = d([d(:).isdir]) ;
% remove '.' and '..' 
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));
value_end = getfield(dfolders(end,:),'name');
pivot=0;
for ii=1:1:(str2num(value_end)-1)
    value_ii = getfield(dfolders(ii,:),'name');
    cd(horzcat('C:\Users\admin\Documents\GitHub\GradProject\Results\12_05_2021_13_51_17\',num2str(value_ii)));
    %read txt file
    s=fileread(horzcat('output_05_12_2021_interaction_-4_targets_',value_ii,'.txt')); % your text file's name
    %assuming same number for each mu
    W = regexp(s,'tfas: (\w*)','tokens');
    Wanted = [W{:}].';
    WantedR = str2double (Wanted);
    W2 = regexp(s,'mu interaction = (\w*)','tokens');  
    Wanted2 = [W2{:}].';
    Wanted2R = str2num(cell2mat(Wanted2));
    if pivot == 0
    giant_big_big_matrix=zeros(str2num(value_end),length(WantedR)/length(Wanted2R),length(Wanted2R));
    pivot=1;
    end
    mystery=reshape(WantedR,length(WantedR)/length(Wanted2R),length(Wanted2R));
    giant_big_big_matrix(ii,:,:)=mystery;
end

Wanted2Ro=Wanted2R;
value_end2=value_end;

cd('C:\Users\admin\Documents\GitHub\GradProject\Results\12_07_2021_19_09_43');
%open('C:\Users\admin\Documents\GitHub\GradProject\Results\12_05_2021_13_51_17');
%each file contains
 d = dir('C:\Users\admin\Documents\GitHub\GradProject\Results\12_07_2021_19_09_43');
% remove all files (isdir property is 0)
dfolders = d([d(:).isdir]) ;
% remove '.' and '..' 
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));
value_end = getfield(dfolders(end,:),'name');
pivot=0;

for ii=1:1:(str2num(value_end)-1)
    value_ii = getfield(dfolders(ii,:),'name');
    cd(horzcat('C:\Users\admin\Documents\GitHub\GradProject\Results\12_07_2021_19_09_43\',num2str(value_ii)));
    %read txt file
    s=fileread(horzcat('output_07_12_2021_interaction_-4_targets_',value_ii,'.txt')); % your text file's name
    %assuming same number for each mu
    W = regexp(s,'tfas: (\w*)','tokens');
    Wanted = [W{:}].';
    WantedR = str2double (Wanted);
    W2 = regexp(s,'mu interaction = (\w*)','tokens');  
    Wanted2 = [W2{:}].';
    Wanted2R = str2num(cell2mat(Wanted2));
    if pivot == 0
    giant_big_big_matrix2=zeros(str2num(value_end),length(WantedR)/length(Wanted2R),length(Wanted2R));
    pivot=1;
    end
    mystery=reshape(WantedR,length(WantedR)/length(Wanted2R),length(Wanted2R));
    giant_big_big_matrix2(ii,:,:)=mystery;
end

figure;
for ii=1:1:(str2num(value_end2)-2)
    hold on;
    AA1= (1:1:length(Wanted2Ro))-1;
    AA=[AA1 Wanted2R'];
    BB=[mean(squeeze(giant_big_big_matrix(ii,:,:)),1) mean(squeeze(giant_big_big_matrix2(ii,:,:)),1)];
    plot(AA,BB);
end
legend('2 targets','3 targets','4 targets')
ylabel('TFAS')
xlabel('Mu')
title('TFAS(Drive),10 Runs Average')

