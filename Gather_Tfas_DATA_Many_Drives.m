%michael added changes 6/10/2022:
%1. Consider here to change num2str(mu) vs. num2str(mu, '%5.1f')
% 2.Back in the day there was here a gap because I named it log
%here when it was not needed 
%3. The current BEAST choice for automatic detection of changes is
%0.01*length(total_energy), and t_order=1, up to 400 changepoints. This
%might be changed according to what is needed. 
%4. downsample_index, do not touch this, as this interpolates the index of
%the vector for the sake of the BEAST to operate well
CallME='Tfas_drives';

mainname1='06_30_2022_10_12_02_mu_0__0_2__2_8_Js__4_0_runs_2';
mainname2='07_06_2022_20_24_07_mu_0__0_2__2_8_Js__4_0_runs_2';
mainname3='07_17_2022_21_39_14_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname4='07_17_2022_10_57_23_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname5='07_18_2022_10_18_08_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname6='07_18_2022_13_49_34_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname7='07_05_2022_14_14_45_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname8='07_09_2022_17_49_20_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname9='07_14_2022_17_47_06_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname10='07_14_2022_17_47_09_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname11='07_15_2022_23_31_07_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname12='07_15_2022_23_48_11_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname13='07_15_2022_23_55_13_mu_0_0_2__2_8_Js__4_0_runs_2';
mainname14='07_17_2022_10_56_26_mu_0_0_2__2_8_Js__4_0_runs_2';


Mergi={mainname1 mainname2  mainname3 mainname4 mainname5 mainname6 mainname7 mainname8  mainname9 mainname10 mainname11 mainname12  mainname13 mainname14 };
restoredefaultpath
addpath 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder'
Main_dir_hazirim= 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Gather_Tfas_DATA_Many_Drives\';
cd(Main_dir_hazirim)

folderName=horzcat(CallME,'_Run_', strrep(datestr(datetime,13), ':', '_'));
mkdir(folderName);
cd(folderName)
    mimi_SS={};
xxy=horzcat(Main_dir_hazirim,folderName);
energy_vec=4.0;
 drive_vec=0.8:0.2:2.8;


TXT_filepathsgg={};
for joj=1:1:length(Mergi) 
  %Meet the butcher
   mainname=Mergi{joj}; 
 mainFolder = horzcat('C:\Users\admin\Documents\GitHub\GradProject\Results\',mainname,'\2');
 oldpath= addpath(['C:\Users\admin\Documents\GitHub\GradProject\Results\',mainname,'\2' ...
     '']);
         [~,message,~] = fileattrib([mainFolder,'\*']);
         fprintf('\n There are %i total files & folders.\n',numel(message));
         allExts = cellfun(@(s) s(end-2:end),{message.Name},'uni',0);% Get file ext
         TXTidx = ismember(allExts,'mat');% Search extensions for "CSV" at the end 
         TXT_filepaths = {message(TXTidx).Name};  % Use idx of TXTs to list paths.
         fprintf('There are %i files with *.mat file ext.\n',numel(TXT_filepaths));
  
        TXT_filepathsgg=[TXT_filepathsgg TXT_filepaths];
end
TXT_filepaths=TXT_filepathsgg;

addpath ('C:\Users\admin\Documents\GitHub\GradProject\mi');
addpath('C:\Users\admin\Documents\GitHub\GradProject\github_repo');
addpath('C:\Users\admin\Documents\GitHub\GradProject\rp-master\rp-master');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject\knee_pt');
addpath 'C:\Users\admin\Documents\GitHub\GradProject\Beast\Matlab';

%check b4 go, if the date of the simulation results is less then the 18_5
%flag or not, and all others for resample, smothing etc
inital_flag=1;
resample_flag=1;
%if smooth then change those
data_smooth_flag=0;
window_samples=1000000;
helper=1;
totalic_length=5*10^7;
%nevertheless those as well about resample
downsample_index=10000;
post_mortem_flag_18_5_21=1;

% mimi_SS={};

for idi=1:1:length(energy_vec)
for jj=1:1:length(drive_vec)

median_vec=zeros(length(energy_vec),length(drive_vec));


        
        %initate our dreams
        mu = drive_vec(jj);
        energy= energy_vec(idi);
        %num_of_targets_might_change
        %check check
%3/10/22 here consider to change the mu format in num2str depends
        %on what is needed  num2str(mu) vs. num2str(mu, '%5.1f')
        %on what is needed
        %the figures of merit,"distance","energy","entropy
        
        if resample_flag==0
        energy_str =horzcat('energy_UP_vec_mu_', num2str(mu, '%5.1f'),'_energy_',char(sprintfc('%0.1f',energy)));
        entropy_str = horzcat('entropy_UP_vec_mu_', num2str(mu, '%5.1f'),'_energy_',char(sprintfc('%0.1f',energy)));
        distance_str =horzcat('distance_vec_mu_', num2str(mu, '%5.1f'),'_energy_',char(sprintfc('%0.1f',energy)));

        elseif resample_flag==1
        energy_str =horzcat('energy_vec_mu_', num2str(mu, '%5.1f'),'_energy_',char(sprintfc('%0.1f',energy)));
        entropy_str = horzcat('entropy_vec_mu_', num2str(mu, '%5.1f'),'_energy_',char(sprintfc('%0.1f',energy)));
        distance_str =horzcat('distance_vec_mu_', num2str(mu, '%5.1f'),'_energy_',char(sprintfc('%0.1f',energy)));
        end



        %distancething
        listt= ~cellfun('isempty',strfind(TXT_filepaths,distance_str));
        address=find (listt==1);
        %energyzing
        listt2= ~cellfun('isempty',strfind(TXT_filepaths,energy_str));
        address2=find (listt2==1);
        mutual_min_vec=zeros(length(address2),1);
        listt3= ~cellfun('isempty',strfind(TXT_filepaths,entropy_str));
        address3=find (listt3==1);   



A={};
A_reduced={};
% figgg= figure;
%     t = tiledlayout('flow');
%     mimi=zeros(1,length(address2));

    for ii=1:1:length(address2)
        pivot2=load(TXT_filepaths{address2(ii)});
        pivot1=load(TXT_filepaths{address(ii)});
        if resample_flag==1
           if post_mortem_flag_18_5_21==1
            Total_energy2=pivot2.foo; 
            else

            Total_energy2= sum(cumsum(pivot2.foo),2);
           end
           %here assuming it is all just downsampled for the beginning
        if length(Total_energy2)~=(totalic_length/downsample_index)
        IL=floor(linspace(1,length(Total_energy2),length(Total_energy2)/downsample_index));
        else
        IL=floor(linspace(1,length(Total_energy2),length(Total_energy2)));
        end
        Total_energy =Total_energy2(IL);
        Distance=pivot1.foo;
        Distance=Distance(IL,:);
        elseif resample_flag==0
        Total_energy=ceil(pivot2.foo);
        end

%           mimi1=find(Distance(:,1)==0,1);
%           mimi2=find(Distance(:,2)==0,1);
%           if isempty(mimi1)
%           mimi1=length(Total_energy);  
%           end
%           if isempty(mimi2)
%           mimi2=length(Total_energy);
%           end
%           mimi(ii)=min(mimi1,mimi2) ;

%     nexttile
%     tic
    %Total_energy= pivot2.foo; 
    %Total_energy=movingaverage(ceil(pivot2.foo));
%    o=beast(Total_energy, 'start', 0, 'tseg.min',floor(0.1*mimi(ii)),'season','none');
o=beast(Total_energy, 'start', 0, 'tseg.min',0.01*length(Total_energy),'season','none');
   %here take the new Y
  yyy=figure;xxx=plotbeast(o);
   h = findobj(xxx(1),'Type','line');
   Y=h(end-1,:).YData; 
   close(yyy)
%    o=beast(Total_energy, 'start', 0,'season','none');
%    oo=beast(o.trend.order, 'start', 0,'season','none');
% cp=sort(take_change_points(o.trend.cpOccPr,o.trend.ncp_median,floor(0.1*mimi(ii))));
cp=sort(o.trend.cp(1:o.trend.ncp_median));

if sum(isnan(cp))~=0
   cp=cp(1:(find (isnan(cp),1)-1));     
end   
cp=[1 ;cp];
%taking the first one as well
%     cp=[1;cp];
   if ~isempty(find (cp==0))
   cp=cp(find (cp~=0)); 
   end     
   [mu_vec,std_vec,skewness_vec,trend_vec,times_vec,SA_vec,cumulated_time_vec]=give_vecs(Total_energy,Distance,Y,cp);
    %     cp=take_change_points_option2(o.trend.cp,o.trend.cpOccPr,o.trend.ncp_median,floor(0.01*mimi(ii)));
    cc={ mu_vec std_vec  skewness_vec cumsum(times_vec) trend_vec  SA_vec cumulated_time_vec};

    if isempty(find(SA_vec==1))
    cc={};
    end 
     A=[A; cc];
ssz=size(A);




    end
    cd(xxy);
A_reduced=[];
C_reduced=[];
for ii=1:1:ssz(1)
    x=A{ii,1};%mean_vec
    y=A{ii,2};%std_vec
    z=A{ii,5};%trend
    w=A{ii,3};%skew
    v=A{ii,4};%total_trajectorytime
    c=A{ii,7};%time to self assemble
    ending_theme=find(c==0,1);
    x=x(1:ending_theme);
    y=y(1:ending_theme);
    z=z(1:ending_theme);
    c=c(1:ending_theme);
    w=w(1:ending_theme);
    v=v(1:ending_theme);
%     B_reduced=[ x; y; z; c]';
    D_reduced=[ x; y; z; w; v; c]';
%     A_reduced=[A_reduced; B_reduced];
    C_reduced=[C_reduced; D_reduced];
end


 M_reduced=C_reduced(:,1:3);
Mm_reduced=(M_reduced-mean(M_reduced,1))./std(M_reduced,1);
[coeff,score,latent] = pca(Mm_reduced);
%now we would like to reach the metric of Mahalanobis Distance between two
%points, to take down the effect of variance on indicaiton on the future.
score3=score./(diag(cov(score)).*ones(3,size(score,1)))';
cmin=0;
cmax=3000;

MU_reduced=C_reduced(:,1:5);
MUm_reduced=(MU_reduced-mean(MU_reduced,1))./std(MU_reduced,1);
[coeff,score,latent] = pca(MUm_reduced);
%now we would like to reach the metric of Mahalanobis Distance between two
%points, to take down the effect of variance on indicaiton on the future.
score5=score./(diag(cov(score)).*ones(5,size(score,1)))';

% 
% 
% hold off;figure
% for ii=1:1:ssz(1)
%     x=score3(:,1);%mean_vec
%     y=score3(:,2);%std_vec
%     z=score3(:,3);%trend
%     c=C_reduced(:,6);
% TrajectoryPlotVecs(x',y',z',c,cmin,cmax);
% end
% xlabel('Mean','FontSize',28);
% ylabel('Variance','FontSize',28);
% zlabel('Trend','FontSize',28);
% title('NEW COORD,Trajectories of Simulation CG States with Time Remaining to FIRST Self Assemble Colorbar')
% % savefig('Stochastic 3');
% savefig(figure(gcf),fullfile(Main_dir_hazirim,folderName,horzcat('Stochastic_6_', regexprep(num2str(mu, '%5.1f'),'\.','_'),'.fig')),'compact');

A3_reduced=[];
A5_reduced=[];

for ii=1:1:size(score5,1)
    x=score5(ii,1);%mean_vec
    y=score5(ii,2);%std_vec
    z=score5(ii,5);%trend
    w=score5(ii,3);%skew
    v=score5(ii,4);%total_trajectorytime
    c=C_reduced(ii,6);

    D5_reduced=[ x; y; z; w; v; c]';
    A5_reduced=[A5_reduced; D5_reduced];
end
A5_reduced_PCA=A5_reduced;
save(horzcat('A5_reduced_PCA_',regexprep(num2str(mu, '%5.1f'),'\.','_'),'.mat'),'A5_reduced_PCA');



for ii=1:1:size(score3,1)
    x=score3(ii,1);%mean_vec
    y=score3(ii,2);%std_vec
    z=score3(ii,3);%trend
    c=C_reduced(ii,6);
    B3_reduced=[ x; y; z;  c]';
    A3_reduced=[A3_reduced; B3_reduced];
end
A3_reduced_PCA=A3_reduced;
save(horzcat('A3_reduced_PCA_',regexprep(num2str(mu, '%5.1f'),'\.','_'),'.mat'),'A3_reduced_PCA');


end
end
cmin=0;
cmax=3000;
figure;
ssz=size(A3_reduced_PCA);
for ii=1:1:ssz(1)
    x=A3_reduced_PCA(:,1);%mean_vec
    y=A3_reduced_PCA(:,2);%std_vec
    z=A3_reduced_PCA(:,3);%trend
    c=A3_reduced_PCA(:,4);
TrajectoryPlotVecs(x',y',z',c,cmin,cmax);
end
xlabel('Mean','FontSize',28);
ylabel('Variance','FontSize',28);
zlabel('Trend','FontSize',28);
title('NEW COORD,Trajectories of Simulation CG States with Time Remaining to FIRST Self Assemble Colorbar')
% savefig('Stochastic 3');
savefig(figure(gcf),fullfile(Main_dir_hazirim,folderName,horzcat('Stochastic_6_', regexprep(num2str(mu, '%5.1f'),'\.','_'),'.fig')),'compact');
