

%calculate the first minimum of the mutual infromation to describe delay

%total energy
%delays=[logspace(10,10,10)]
cd(['C:\Users\admin\Documents\GitHub\GradProject\Results\06_24_2022_18_20_48_mu_1_Js__4_0_runs_12\2' ...
    '']);
mainFolder = cd;

addpath ('C:\Users\admin\Documents\GitHub\GradProject\mi');
addpath('C:\Users\admin\Documents\GitHub\GradProject\github_repo');
addpath('C:\Users\admin\Documents\GitHub\GradProject\rp-master\rp-master');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject\knee_pt');
addpath 'C:\Users\admin\Documents\GitHub\GradProject\Beast\Matlab';
energy_vec=[ 4.0];
drive_vec=1;
mainname='PlotAllMovieUPDATED';
Main_dir_hazirim= 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder\PlotAllMovieUPDATED';
folderName=horzcat(Main_dir_hazirim,'_Run_', strrep(datestr(datetime,13), ':', '_'));
mkdir(folderName);
cd(folderName);
% cd(Main_dir_hazirim)
% really=length(address2);%for defualt
really=2;
%check b4 go, if the date of the simulation results is less then the 18_5
%flag or not, and all others for resample, smothing etc
inital_flag=1;
resample_flag=1;
%if smooth then change those
data_smooth_flag=0;
window_samples=1000000;
%nevertheless those as well about resample
downsample_index=10000;
post_mortem_flag_18_5_21=1;
%floor(length(Total_energy)/delays(I));

for idi=1:1:length(energy_vec)

    for jj=1:1:length(drive_vec)
        
        %initate our dreams
        mu = drive_vec(jj);
        energy= energy_vec(idi);
        %num_of_targets_might_change
        %check check
        
        %the figures of merit,"distance","energy","entropy
        
        if resample_flag==0
        energy_str =horzcat('energy_UP_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        entropy_str = horzcat('entropy_UP_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
                distance_str =horzcat('distance_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
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

    for ii=2:1:really
        pivot2=load(TXT_filepaths{address2(ii)});
        if resample_flag==1
           if post_mortem_flag_18_5_21==1
            Total_energy2=pivot2.foo; 
            else

            Total_energy2= sum(cumsum(pivot2.foo),2);
           end

        IL=floor(linspace(1,length(Total_energy2),length(Total_energy2)/downsample_index));
        Total_energy =Total_energy2(IL);
        elseif resample_flag==0
        Total_energy=ceil(pivot2.foo);
        end

%total entropy

            pivot2=load(TXT_filepaths{address3(ii)});
        if resample_flag==1
%         Total_entropy2= sum(cumsum(pivot2.foo),2);
        Total_entropy2= pivot2.foo;
        IL=floor(linspace(1,length(Total_entropy2),length(Total_entropy2)/downsample_index));
        Total_entropy =Total_entropy2(IL);
        elseif resample_flag==0
        Total_entropy=ceil(pivot2.foo);
        end

         pivot=load(TXT_filepaths{address(ii)});
        dist11=pivot.foo(:,1);
         dist22=pivot.foo(:,2);
         
        if resample_flag==1
        IL=floor(linspace(1,length(Total_entropy2),length(Total_entropy2)/downsample_index));
        dist1 =dist11(IL);
        dist2=dist22(IL);
        end
        dir2=cd;
        aa=TXT_filepaths(ii);
        bb=aa{1};
        k=strfind(aa{1},'mu');
        kk=k(2);
        pup=bb(kk:end);
        Ii=find(bb(kk:end)=='_');
        mu=str2num(pup((Ii(1)+1):1:(Ii(2)-1)));
        run_index=str2num((pup((Ii(6)+1):1:(Ii(7)-1))))-1;
        J_strong=(pup((Ii(3)+1):1:(Ii(4)-1)));
        name=horzcat('State_mu_',num2str(mu),'_run_index_',num2str(run_index),'_num_target_0_turn_number_');
        name1=horzcat('Target_mu_',num2str(mu),'_run_index_',num2str(run_index),'_num_target_0_turn_number_');
        name2=horzcat('Target_mu_',num2str(mu),'_run_index_',num2str(run_index),'_num_target_1_turn_number_');
        resolution=1000000;
        Date=["","","","","",""];
        Iip=find(bb(1:end)=='_');
        %date [mm_dd_yyyy_hh_mm_ss]
        Date(1)=bb((Iip(1)-2):Iip(1)-1);
        Date(2)=bb((Iip(2)-2):Iip(2)-1);
         Date(3)=bb((Iip(3)-4):Iip(3)-1);
        Date(4)=bb((Iip(4)-2):Iip(4)-1);
Date(5)=bb((Iip(5)-2):Iip(5)-1);
Date(6)=bb((Iip(6)-2):Iip(6)-1);
        %State_mu_1_run_index_0_num_target_0_turn_number_7000000_J_strong_-4.0
        a=1; 
        aaa=dir(TXT_filepaths{address(ii)});
        dir2=aaa.folder;
        v= MovieMakerCallUP(folderName,dir2,a,name, name1,name2,Total_energy,Total_entropy,dist1,dist2,resolution,energy,Date,downsample_index,mu);
        cd(Main_dir_hazirim)
        close(v);
        close all;
        
    %Total_energy= pivot2.foo; 
    %Total_energy=movingaverage(ceil(pivot2.foo));
   %o=beast(Total_energy, 'start', 0, 'tseg.min',floor(0.1*length(Total_energy)),'season','none');
%    o=beast(Total_energy, 'start', 0,'season','none');
%     cp2=o.trend.cp;
%     cp3=cp2(cp2<o.trend.ncp_median);
%     cp=sort(cp2);
%     %cpI=sort(o.season.cp);
%     x=cp;
%      xx=[0; x; length(Total_energy)];
%      xxx=xx(2:end)-xx(1:(end-1));
%       y=xx(xxx>mutual_min_vec(ii));
%         cp=y;


%         hold on;
%         for i = 1 : length(cp)
%             plot( [cp(i),cp(i)], get(gca,'Ylim'), 'color', 'k');
%             ylabel('Energy')
%             xlabel('Big Steps')
%         end
                hold on;
%         for i = 1 : length(cpI)
%             plot( [cpI(i),cpI(i)], get(gca,'Ylim'), 'color', 'r');
%             ylabel('Energy')
%             xlabel('Big Steps')
%         end
    end
%     if data_smooth_flag==1
%     sgtitle(horzcat('Energy States Division, Strong Energy is ',num2str(energy_vec),' and the Drive is ',num2str(drive_vec),' and the Downsample is ',num2str(downsample_index),' Smoothed Over ', num2str(window_samples)))
%     else
%     sgtitle(horzcat('Energy States Division, Strong Energy is ',num2str(energy_vec),' and the Drive is ',num2str(drive_vec),' and the Downsample is ',num2str(downsample_index)))
%     end
%     str2=num2str(2);

 
    end
end

