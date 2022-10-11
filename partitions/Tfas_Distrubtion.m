   
%calculate the first minimum of the mutual infromation to describe delay
%total energy
%delays=[logspace(10,10,10)]
cd(['C:\Users\admin\Documents\GitHub\GradProject\Results\05_24_2022_19_05_42-Many_Drives_4_kbt\2' ...
    '']);
mainFolder = cd;
addpath ('C:\Users\admin\Documents\GitHub\GradProject\mi');
addpath('C:\Users\admin\Documents\GitHub\GradProject\github_repo');
addpath('C:\Users\admin\Documents\GitHub\GradProject\rp-master\rp-master');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject\knee_pt');
addpath 'C:\Users\admin\Documents\GitHub\GradProject\Beast\Matlab';
energy_vec=4.0;
drive_vec=1.2;


%check b4 go, if the date of the simulation results is less then the 18_5
%flag or not, and all others for resample, smothing etc
inital_flag=1;
resample_flag=1;
%if smooth then change those
data_smooth_flag=0;
window_samples=1000000;
%nevertheless those as well about resample
downsample_index=1;
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
        energy_str =horzcat('energy_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        entropy_str = horzcat('entropy_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        distance_str =horzcat('distance_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
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




figgg= figure;
    t = tiledlayout('flow');
    mimi=zeros(1,length(address2));
    for ii=1:1:length(address2)
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
    nexttile
    tic
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
        plot(Total_energy);
        MINN=min(Total_energy);    
        mimi(ii)=find(Total_energy==MINN,1);

        if (MINN>-120)
        mimi(ii)=length(Total_energy);
        end
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
    if data_smooth_flag==1
    sgtitle(horzcat('Energy States Division, Strong Energy is ',num2str(energy_vec),' and the Drive is ',num2str(drive_vec),' and the Downsample is ',num2str(downsample_index),' Smoothed Over ', num2str(window_samples)))
    else
    sgtitle(horzcat('Energy States Division, Strong Energy is ',num2str(energy_vec),' and the Drive is ',num2str(drive_vec),' and the Downsample is ',num2str(downsample_index)))
    end
    str2=num2str(2);
    mimi=mimi*downsample_index;
pop=median(mimi);
% histogram(mimi)
 figure;upp=histogram(mimi,length(mimi));
% figure; scatter(mu,mimi(:),60,'filled');
ylabel('Tfas Distribution','FontSize',36);
xlabel('TFAS(Steps)','FontSize',36);
title(horzcat('Tfas Distribution of mu ' ,num2str(mu),' Strong Energy ',num2str(energy_vec), ' Number of Targets ',str2),'FontSize',36);
set(gca,'FontSize',36)
hold on;
% scatter(pop,1,90,'d','k','filled');
[MM,iiii]=min(abs(upp.BinEdges-pop));
try
x= upp.BinEdges(iiii)+upp.BinWidth/2;
[M,II]=min(abs(upp.BinEdges-pop));
y=upp.Values(II);
bar(x,y,upp.BinWidth,'r');
catch
x= upp.BinEdges(iiii)-upp.BinWidth/2;
[M,II]=min(abs(upp.BinEdges-pop));
y=upp.Values(II-1);
bar(x,y,upp.BinWidth,'r');
end
    end
end

