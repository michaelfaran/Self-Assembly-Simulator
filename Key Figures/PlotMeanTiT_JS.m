%Michael add 10/10/2022
% Adding results instead of the orginial Place where the simulation was
% stuck

ResultsDir='C:\Users\admin\Documents\Results';


key_fig_path='C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Key Figures';
mainname='07_31_2022_14_16_01_mu_0_Js__3_5__0_5__10_runs_2_Target_Start';
restoredefaultpath
addpath 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder'
Main_dir_hazirim= 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Tfas_Distrubtion_Energies';
cd(Main_dir_hazirim)
mainFolder = horzcat('C:\Users\admin\Documents\Results\',mainname,'\2');
oldpath= addpath(['C:\Users\admin\Documents\Results\',mainname,'\2' ...
    '']);
addpath ('C:\Users\admin\Documents\GitHub\GradProject\mi');
addpath('C:\Users\admin\Documents\GitHub\GradProject\github_repo');
addpath('C:\Users\admin\Documents\GitHub\GradProject\rp-master\rp-master');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject\knee_pt');
addpath 'C:\Users\admin\Documents\GitHub\GradProject\Beast\Matlab';

folderName=horzcat(mainname,'_Run_', strrep(datestr(datetime,13), ':', '_'));
mkdir(folderName);
cd(folderName)

% 
% cd(['C:\Users\admin\Documents\Results\05_24_2022_19_05_42-Many_Drives_4_kbt\2' ...
%     '']);
% mainFolder = cd;
% addpath ('C:\Users\admin\Documents\GitHub\GradProject\mi');
% addpath('C:\Users\admin\Documents\GitHub\GradProject\github_repo');
% addpath('C:\Users\admin\Documents\GitHub\GradProject\rp-master\rp-master');
%  addpath ('C:\Users\admin\Documents\GitHub\GradProject');
%  addpath ('C:\Users\admin\Documents\GitHub\GradProject\knee_pt');
% addpath 'C:\Users\admin\Documents\GitHub\GradProject\Beast\Matlab';
%  addpath ('C:\Users\admin\Documents\GitHub\GradProject\knee_pt');


num_of_targets=2;
energy_vec=3:0.5:7;
drive_vec=0;
median_vec=zeros(length(energy_vec),length(drive_vec));
%check b4 go, if the date of the simulation results is less then the 18_5
%flag or not, and all others for resample, smothing etc
inital_flag=1;
resample_flag=1;
%if smooth then change those
data_smooth_flag=0;
window_samples=1000000;
helper=1;
%nevertheless those as well about resample
downsample_index=1;
post_mortem_flag_18_5_21=1;
%floor(length(Total_energy)/delays(I));
    mimi_SSJ={};
    mimi_SS={};
for idi=1:1:length(energy_vec)

    for jj=1:1:(length(drive_vec))
        cd(Main_dir_hazirim);
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
        energy_str2 =horzcat('energy_vec_mu_', num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        entropy_str2 = horzcat('entropy_vec_mu_', num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        distance_str2 =horzcat('distance_vec_mu_', num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
                
        end
        %Meet the butcher
         [~,message,~] = fileattrib([mainFolder,'\*']);
         fprintf('\n There are %i total files & folders.\n',numel(message));
         allExts = cellfun(@(s) s(end-2:end),{message.Name},'uni',0);% Get file ext
         TXTidx = ismember(allExts,'mat');% Search extensions for "CSV" at the end 
         TXT_filepaths = {message(TXTidx).Name};  % Use idx of TXTs to list paths.
         fprintf('There are %i files with *.mat file ext.\n',numel(TXT_filepaths));
        %rename the files if needed
        Vecc=~cellfun('isempty',strfind(TXT_filepaths,entropy_str));
        for ii=1:1:length(Vecc)
              if Vecc(ii)==1
                  % If numeric, rename
                  if strcmp(regexprep(TXT_filepaths{ii},'mini_summed_energy','mini_summed_energy_UP'),TXT_filepaths{ii})==0
                  
                  energy_str_2= regexprep(TXT_filepaths{ii},'mini_summed_energy','mini_summed_energy_UP');
                  movefile(TXT_filepaths{ii},energy_str_2);
                  
                  elseif strcmp(regexprep(TXT_filepaths{ii},'mini_summed_distance','mini_summed_distance_UP'),TXT_filepaths{ii})==0
                  
                  distance_str_2= regexprep(TXT_filepaths{ii},'mini_summed_distance','mini_summed_distance_UP');
                  movefile(TXT_filepaths{ii},distance_str_2);

                  elseif strcmp(regexprep(TXT_filepaths{ii},'mini_summed_entropy','mini_summed_entropy_UP'),TXT_filepaths{ii})==0
                  
                  entropy_str_2= regexprep(TXT_filepaths{ii},'mini_summed_entropy','mini_summed_entropy_UP');
                  movefile(TXT_filepaths{ii},entropy_str_2);
                  
                  end
              end
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

        if isempty(address2)
        listt= ~cellfun('isempty',strfind(TXT_filepaths,distance_str2));
        address=find (listt==1);
        %energyzing
        listt2= ~cellfun('isempty',strfind(TXT_filepaths,energy_str2));
        address2=find (listt2==1);
        mutual_min_vec=zeros(length(address2),1);
        listt3= ~cellfun('isempty',strfind(TXT_filepaths,entropy_str2));
        address3=find (listt3==1);  
        end
 
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

        IL=floor(linspace(1,length(Total_energy2),length(Total_energy2)/downsample_index));
        Total_energy =Total_energy2(IL);
        Distance=pivot1.foo;

        elseif resample_flag==0
        Total_energy=ceil(pivot2.foo);
        end

          mimi1=length(find(Distance(:,1)==0));
          mimi2=length(find(Distance(:,2)==0));

%           if isempty(mimi1)
%           mimi1=length(Total_energy);  
%           end
%           if isempty(mimi2)
%           mimi2=length(Total_energy);
%           end
          mimi(ii)=mimi1;

    end


   cd(Main_dir_hazirim);
    mimi=mimi*downsample_index*helper;    
    mimi_SS=[mimi_SS; mimi];
% pop=median(mimi);
% histogram(mimi)
%  figure;upp=histogram(mimi,length(mimi));
%  if max(upp.BinEdges)<5*10^7
%     edges=[upp.BinEdges 5*10^7];
%     edges=linspace(0,edges(end),length(edges));
%     upp=histogram(mimi,edges);
%  else   
%  edges=[upp.BinEdges(1:(end-1)) 5*10^7];
%  edges=linspace(0,edges(end),length(edges));
%  upp=histogram(mimi,edges);
%  hold on;
%  bar(upp.BinEdges(2:end)-(upp.BinEdges(2)-upp.BinEdges(1))/2,[zeros(length(mimi)-1,1);upp.Values(end)],1,'FaceColor',[0 0.4470 0.7410]	)
%      
%  end
end
cd(Main_dir_hazirim);


% mimi_SSJ=[mimi_SSJ ;mimi_SS];

% for idi=1:1:length(energy_vec)
%     figure;
% for idic=1:1:length(drive_vec)
% % plot(drive_vec,median_vec(idi,:),'LineWidth',16);
% %title(horzcat('Median Tfas(\mu)',' with Strong Energy ',num2str(energy), ' Number of Targets ',str2),'FontSize',36);
% a = mimi_SS{idic};
% c = arrayfun(@(x)length(find(a == x)), unique(a), 'Uniform', false);
% d= cell2mat(c);
% a=unique(a);
% if idic==1
% nani=max(d);
% end
% 
% BubblePlot(ones(1,numel(downsample_index))*drive_vec(idic), a*downsample_index*helper, d,'b');
% hold on
% end
% ylabel('T_{FAS}','FontSize',36)
% xlabel('\Delta\mu','FontSize',36)
% hold on;
% plot(drive_vec,median_vec(idi,:),'r','LineWidth',12);
% set(gca,'FontSize',36)
%  fullscreen();
% saveas(gcf,horzcat('Median_Tfas_mu_','_with_Strong_Energy_',num2str(energy), '_Number_of_Targets_',str2,'.png'));
end
cd(Main_dir_hazirim);


J=-flip(energy_vec);
pop=zeros(length(J),1);
figure;
for yy=1:1:(length(J)) 
    a=mimi_SS{yy,:};
[C,ia,ic] = unique(a);
a_counts = accumarray(ic,1);
try
value_counts = [C, a_counts];
catch
value_counts = [C, a_counts'];

end
pop(yy)=median(a);
BubblePlot(ones(1,size(a_counts,1))*J(length(J)-yy+1), C,4*a_counts ,'b',16);
hold on;
end

% figure; scatter (J,flip(ZZ),60,'filled');
ylabel('TiT','FontSize',36)
xlabel('J_{s}','FontSize',36)
hold on;
plot(J,flip(pop),'r','LineWidth',5);
set(gca,'FontSize',36)
 fullscreen();
 cd(key_fig_path);
saveas(gcf,horzcat('Median_TiT_J_','_with_Drive_',num2str(mu), '_Number_of_Targets_',num2str(num_of_targets),'.png'));
% title(horzcat('Tfas Distribution ' ,num2str(mu), ' Number of Targets ',str2),'FontSize',36);
% hold on;
% scatter(mu,pop,90,'d','k','filled');




