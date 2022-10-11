   
%calculate the first minimum of the mutual infromation to describe delay
%total energy
%delays=[logspace(10,10,10)]
%num2str(mu, '%5.1f') switch to num2str(mu, '%5.1f')
CallME='Grand_mu_statistics';
%1 mu
% mainname1='06_24_2022_18_20_48_mu_1_Js__4_0_runs_12';
% mainname2='06_20_2022_18_45_03_mu_1_Js__4_0_runs_3';
% mainname3='06_15_2022_10_53_04_mu_1_Js__4_0_runs_5';
% mainname4='06_12_2022_19_31_54_mu_1_Js__4_0_runs_5';
% mainname5='06_11_2022_18_31_37_mu_1_Js__4_0_runs_3';
% mainname6='06_10_2022_23_18_49_mu_1_Js__4_0_runs_3';


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
Main_dir_hazirim= 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Tfas_Distrubtion_Drives_Margi';
cd(Main_dir_hazirim)

folderName=horzcat(CallME,'_Run_', strrep(datestr(datetime,13), ':', '_'));
mkdir(folderName);
cd(folderName)
    mimi_SS={};

energy_vec=4.0;
 drive_vec=0.2:0.2:2.8;
% drive_vec= [0.2 1];

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
        %rename the files if needed
%         Vecc=~cellfun('isempty',strfind(TXT_filepaths,entropy_str));
%         for ii=1:1:length(Vecc)
%               if Vecc(ii)==1
%                   % If numeric, rename
%                   if strcmp(regexprep(TXT_filepaths{ii},'mini_summed_energy','mini_summed_energy_UP'),TXT_filepaths{ii})==0
%                   
%                   energy_str_2= regexprep(TXT_filepaths{ii},'mini_summed_energy','mini_summed_energy_UP');
%                   movefile(TXT_filepaths{ii},energy_str_2);
%                   
%                   elseif strcmp(regexprep(TXT_filepaths{ii},'mini_summed_distance','mini_summed_distance_UP'),TXT_filepaths{ii})==0
%                   
%                   distance_str_2= regexprep(TXT_filepaths{ii},'mini_summed_distance','mini_summed_distance_UP');
%                   movefile(TXT_filepaths{ii},distance_str_2);
% 
%                   elseif strcmp(regexprep(TXT_filepaths{ii},'mini_summed_entropy','mini_summed_entropy_UP'),TXT_filepaths{ii})==0
%                   
%                   entropy_str_2= regexprep(TXT_filepaths{ii},'mini_summed_entropy','mini_summed_entropy_UP');
%                   movefile(TXT_filepaths{ii},entropy_str_2);
%                   
%                   end
%               end
%         end
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
%floor(length(Total_energy)/delays(I));
mimi_SS={};

for idi=1:1:length(energy_vec)
for jj=1:1:length(drive_vec)
% for joj=1:1:length((Mergi))  

% mainname=Mergi{joj};
% 
% mainFolder = horzcat('C:\Users\admin\Documents\GitHub\GradProject\Results\',mainname,'\2');
% oldpath= addpath(['C:\Users\admin\Documents\GitHub\GradProject\Results\',mainname,'\2' ...
%     '']);

% mimi_SS={};

median_vec=zeros(length(energy_vec),length(drive_vec));


        
        %initate our dreams
        mu = drive_vec(jj);
        energy= energy_vec(idi);
        %num_of_targets_might_change
        %check check
        
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




% figgg= figure;
%     t = tiledlayout('flow');
    mimi=zeros(1,length(address2));

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

          mimi1=find(Distance(:,1)==0,1);
          mimi2=find(Distance(:,2)==0,1);
          if isempty(mimi1)
          mimi1=length(Total_energy);  
          end
          if isempty(mimi2)
          mimi2=length(Total_energy);
          end
          mimi(ii)=min(mimi1,mimi2) ;
    end

            mimi=mimi*downsample_index*helper;
        mimi_SS=[mimi_SS; mimi];
%     if data_smooth_flag==1
%     sgtitle(horzcat('Energy States Division, Strong Energy is ',num2str(energy),' and the Drive is ',num2str(mu, '%5.1f'),' and the Downsample is ',num2str(downsample_index*helper),' Smoothed Over ', num2str(window_samples)),'FontSize',24)
%     else
%     sgtitle(horzcat('Energy States Division, Strong Energy is ',num2str(energy),' and the Drive is ',num2str(mu, '%5.1f'),' and the Downsample is ',num2str(downsample_index*helper)),'FontSize',24);
%     end  


%      end
%     cd(mainFolder)


% well=[];
% for op=1:1:length(Mergi)  
% dirty=mimi_SS{op,1};
% well=[well dirty];
% end


Plot_Histograms_KLD(mimi,drive_vec(jj),energy_vec(idi))
% mimija= [mimija ; well];

end
end

mu_vec=zeros(length(drive_vec),length(energy_vec));
std_vec=zeros(length(drive_vec),length(energy_vec));
% %attempt again
for idi=1:1:length(energy_vec)
for jj=1:1:length(drive_vec)

        %initate our dreams
mu = drive_vec(jj);
energy= energy_vec(idi);
a=regexprep(horzcat('Results_of_Tfas_Distribution_of_mu_' , num2str(mu,'%.1f'),'_Strong_Energy_',num2str(energy,'%.1f')),'\.','_'); 
A=convertStringsToChars(horzcat(a,'.mat'));
load(A);
[pop,linear_scale_std_minus]=Plot_Histograms_KLD_mu_sigma(mimi,mu,energy);
mu_vec(jj,idi)=pop;
std_vec(jj,idi)=linear_scale_std_minus;

end
end

% figure;
% fullscreen();
% yyaxis left
% plot(drive_vec,mu_vec(:,1),'LineWidth',6);
ylabel('TFAS Median','FontSize',36)
xlabel('\Delta\mu','FontSize',36)
hold on;
yyaxis right
plot(drive_vec,std_vec(:,1),'LineWidth',6);
xlabel('\Delta\mu','FontSize',36)
ylabel('TFAS STD','FontSize',36)
legend('Median','STD','FontSize',36)
set(gca,'FontSize',36)
drive_vec_crowded=linspace(min(drive_vec),max(drive_vec),10^4);

figure;
fullscreen();
yyaxis left
g = fittype('b*exp(-c*x)+d');
f = fit(drive_vec',mu_vec(:,1),g ,'StartPoint',[15*10^7 3 0.5*10^7]);
h=plot(drive_vec,mu_vec(:,1),'o',drive_vec_crowded,f(drive_vec_crowded),'b-','LineWidth',6);
 
eq = formula(f); %Formula of fitted equation
parameters = coeffnames(f); %All the parameter names
values = coeffvalues(f); %All the parameter values
for idx = 1:numel(parameters)
      param = parameters{idx};
      l = length(param);
      loc = regexp(eq, param); %Location of the parameter within the string
      while ~isempty(loc)     
          %Substitute parameter value
          if idx==2
          eq = [eq(1:loc-1) num2str(values(idx),'%.1f') eq(loc+l:end)];
          else 
          eq = [eq(1:loc-1) num2str(values(idx),'%0.1e') eq(loc+l:end)];
          end      
          loc = regexp(eq, param);
      end
end


ylabel('T_{FAS} Median','FontSize',36)
xlabel('\Delta\mu','FontSize',36)
hold on;

yyaxis right
g = fittype('b*exp(-c*x)+d');
f = fit(drive_vec',std_vec(:,1),g ,'StartPoint',[15*10^7 3 0.5*10^7]);
h1=plot(drive_vec,std_vec(:,1),'o',drive_vec_crowded,f(drive_vec_crowded),'r-','LineWidth',6);

eq2 = formula(f); %Formula of fitted equation
parameters = coeffnames(f); %All the parameter names
values = coeffvalues(f); %All the parameter values
for idx = 1:numel(parameters)
      param = parameters{idx};
      l = length(param);
      loc = regexp(eq2, param); %Location of the parameter within the string
      while ~isempty(loc)     
          %Substitute parameter value
          if idx==2
          eq2 = [eq2(1:loc-1) num2str(values(idx),'%.1f') eq2(loc+l:end)];
          else 
          eq2 = [eq2(1:loc-1) num2str(values(idx),'%0.1e') eq2(loc+l:end)];
          end
          loc = regexp(eq2, param);
      end
end
xlabel('\Delta\mu','FontSize',36)
ylabel('T_{FAS} STD','FontSize',36)
% legend('Median','STD','FontSize',36)

legendinfo = legend('M','M_{fit}','\sigma','\sigma_{fit}');
% legendinfo.String{2} = regexprep(horzcat('M_{fit}=',eq),'x)','\\Delta\\mu)');
% legendinfo.String{4} = regexprep(horzcat('\sigma_{fit}=',eq2),'x)','\\Delta\\mu)');
%  legendinfo.String{2} = 'M_{fit}';
%  legendinfo.String{4} = '\sigma_{fit}';
set(gca,'FontSize',36)
saveas(gcf,horzcat('Tfas_Meta_fig' ,'.png'));


