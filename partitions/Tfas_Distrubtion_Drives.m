   
%calculate the first minimum of the mutual infromation to describe delay
%total energy
%delays=[logspace(10,10,10)]
mainname='05_24_2022_19_05_42_mu_0__0_4__6_Js__4_0_runs_2';
restoredefaultpath
addpath 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder'
Main_dir_hazirim= 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Tfas_Distrubtion_Drives';
cd(Main_dir_hazirim)
mainFolder = horzcat('C:\Users\admin\Documents\GitHub\GradProject\Results\',mainname,'\2');
oldpath= addpath(['C:\Users\admin\Documents\GitHub\GradProject\Results\',mainname,'\2' ...
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
% cd(['C:\Users\admin\Documents\GitHub\GradProject\Results\05_24_2022_19_05_42-Many_Drives_4_kbt\2' ...
%     '']);
% mainFolder = cd;
% addpath ('C:\Users\admin\Documents\GitHub\GradProject\mi');
% addpath('C:\Users\admin\Documents\GitHub\GradProject\github_repo');
% addpath('C:\Users\admin\Documents\GitHub\GradProject\rp-master\rp-master');
%  addpath ('C:\Users\admin\Documents\GitHub\GradProject');
%  addpath ('C:\Users\admin\Documents\GitHub\GradProject\knee_pt');
% addpath 'C:\Users\admin\Documents\GitHub\GradProject\Beast\Matlab';
%  addpath ('C:\Users\admin\Documents\GitHub\GradProject\knee_pt');

energy_vec=4.0;
drive_vec=0:0.4:6;
median_vec=zeros(length(energy_vec),length(drive_vec));
%check b4 go, if the date of the simulation results is less then the 18_5
%flag or not, and all others for resample, smothing etc
inital_flag=1;
resample_flag=1;
%if smooth then change those
data_smooth_flag=0;
window_samples=1000000;
helper=10000;
%nevertheless those as well about resample
downsample_index=1;
post_mortem_flag_18_5_21=1;
%floor(length(Total_energy)/delays(I));
    mimi_SS={};
for idi=1:1:length(energy_vec)

    for jj=1:1:length(drive_vec)
        
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
%         MINN=min(Total_energy);    
%         mimi(ii)=find(Total_energy==MINN,1);
          mimi1=find(Distance(:,1)==0,1);
          mimi2=find(Distance(:,2)==0,1);
          if isempty(mimi1)
          mimi1=length(Total_energy);  
          end
          if isempty(mimi2)
          mimi2=length(Total_energy);
          end
          mimi(ii)=min(mimi1,mimi2) ;
%         if (MINN>-148)
%         mimi(ii)=length(Total_energy);
%         end


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
    sgtitle(horzcat('Energy States Division, Strong Energy is ',num2str(energy),' and the Drive is ',num2str(mu),' and the Downsample is ',num2str(downsample_index*helper),' Smoothed Over ', num2str(window_samples)),'FontSize',24)
    else
    sgtitle(horzcat('Energy States Division, Strong Energy is ',num2str(energy),' and the Drive is ',num2str(mu),' and the Downsample is ',num2str(downsample_index*helper)),'FontSize',24);
    end 
    mimi_SS=[mimi_SS; mimi];
    fullscreen();
    saveas(figgg,horzcat('Energy_States_Division_Strong_Energy_is_',num2str(energy),'_and_the_Drive_is_',num2str(mu),'_and_the_Downsample_is_',num2str(downsample_index*helper),'.png'));
    close(figgg);
    str2=num2str(2);
    mimi=mimi*downsample_index*helper;
pop=median(mimi);
% histogram(mimi)
 figure;upp=histogram(mimi,length(mimi));
 if max(upp.BinEdges)<5*10^7
    edges=[upp.BinEdges 5*10^7];
    edges=linspace(0,edges(end),length(edges));
    upp=histogram(mimi,edges);
 else   
 edges=[upp.BinEdges(1:(end-1)) 5*10^7];
 edges=linspace(0,edges(end),length(edges));
 upp=histogram(mimi,edges);
 hold on;
 bar(upp.BinEdges(2:end)-(upp.BinEdges(2)-upp.BinEdges(1))/2,[zeros(length(mimi)-1,1);upp.Values(end)],1,'FaceColor',[0 0.4470 0.7410]	)
     
 end
 fullscreen();
% figure; scatter(mu,mimi(:),60,'filled');
ylabel('Count','FontSize',36);
xlabel('T_{FAS}','FontSize',36);
%title(horzcat('Tfas Distribution of mu ' , num2str(mu, '%5.1f'),' Strong Energy ',num2str(energy), ' Number of Targets ',str2),'FontSize',36);
set(gca,'FontSize',36)

hold on;
% scatter(pop,1,90,'d','k','filled');
[MM,iiii]=min(abs(upp.BinEdges-pop));
try
x= upp.BinEdges(iiii)+upp.BinWidth/2;
 [M,II]=min(abs(upp.BinEdges-pop));
 y=upp.Values(II);
% bar(x,y,upp.BinWidth,'r');
c1=xline(x,'--r','LineWidth',6);
catch
x= upp.BinEdges(iiii)-upp.BinWidth/2;
 [M,II]=min(abs(upp.BinEdges-pop));
 y=upp.Values(II-1);
% bar(x,y,upp.BinWidth,'r');
c1=xline(x,'--r','LineWidth',6);
end
%legend('Histogram Data','Median')
saveas(gcf,horzcat('Tfas_Distribution_of_mu_' , num2str(mu, '%5.1f'),'_Strong_Energy',num2str(energy),'.png'));
close(gcf);
median_vec(idi,jj)=x;
    end
%     cd(mainFolder)
end




for idi=1:1:length(energy_vec)
    figure;
for idic=1:1:length(drive_vec)
% plot(drive_vec,median_vec(idi,:),'LineWidth',16);
%title(horzcat('Median Tfas(\mu)',' with Strong Energy ',num2str(energy), ' Number of Targets ',str2),'FontSize',36);
a = mimi_SS{idic};
c = arrayfun(@(x)length(find(a == x)), unique(a), 'Uniform', false);
d= cell2mat(c);
a=unique(a);
if idic==1
nani=max(d);
end

BubblePlot(ones(1,numel(downsample_index))*drive_vec(idic), a*downsample_index*helper, d,'b');
hold on
end
ylabel('T_{FAS}','FontSize',36)
xlabel('\Delta\mu','FontSize',36)
hold on;
plot(drive_vec,median_vec(idi,:),'r','LineWidth',12);
set(gca,'FontSize',36)
 fullscreen();
saveas(gcf,horzcat('Median_Tfas_mu_','_with_Strong_Energy_',num2str(energy), '_Number_of_Targets_',str2,'.png'));
end



