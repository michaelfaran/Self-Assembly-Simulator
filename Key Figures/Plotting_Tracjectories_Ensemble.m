%calculate the first minimum of the mutual infromation to describe delay

%total energy
%delays=[logspace(10,10,10)]C:\Users\admin\Documents\GitHub\GradProject\Results\06_12_2022_19_31_54_4.0_Js_1 mu_5_runs\2
%C:\Users\admin\Documents\GitHub\GradProject\Results\06_20_2022_18_45_03_4.0_Js_1 mu_3_runs\2


mainname='07_26_2022_23_40_46_mu_0_Js__3_5__0_5__7_runs_2';
restoredefaultpath
addpath 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder'
Main_dir_hazirim= 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Plotting_Trajectories_Ensemble';
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
energy_vec=[ 3  7 4.5];
drive_vec=0;
formatSpec = '%.1f';
folderName=horzcat(mainname,'_Run_', strrep(datestr(datetime,13), ':', '_'));
mkdir(folderName);
mydir=horzcat('\',folderName);
xxy=horzcat(Main_dir_hazirim,mydir);
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

%check if txt_filepeths is empty, if so, fix to add mu after point

        listt= ~cellfun('isempty',strfind(TXT_filepaths,distance_str));
        address=find (listt==1);
        
        listt= ~cellfun('isempty',strfind(TXT_filepaths,distance_str));
        address=find (listt==1);
        
        if  isempty(address)
        if resample_flag==0
        energy_str =horzcat('energy_UP_vec_mu_',char(sprintfc('%0.1f',mu)),'_energy_',char(sprintfc('%0.1f',energy)));
        entropy_str = horzcat('entropy_UP_vec_mu_',char(sprintfc('%0.1f',mu)),'_energy_',char(sprintfc('%0.1f',energy)));
                distance_str =horzcat('distance_vec_mu_',char(sprintfc('%0.1f',mu)),'_energy_',char(sprintfc('%0.1f',energy)));
        energy_str2 =horzcat('energy_vec_mu_', num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        entropy_str2 = horzcat('entropy_vec_mu_', num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        distance_str2 =horzcat('distance_vec_mu_', num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));


        elseif resample_flag==1
        energy_str =horzcat('energy_vec_mu_',char(sprintfc('%0.1f',mu)),'_energy_',char(sprintfc('%0.1f',energy)));
        entropy_str = horzcat('entropy_vec_mu_',char(sprintfc('%0.1f',mu)),'_energy_',char(sprintfc('%0.1f',energy)));
        distance_str =horzcat('distance_vec_mu_',char(sprintfc('%0.1f',mu)),'_energy_',char(sprintfc('%0.1f',energy)));
                energy_str2 =horzcat('energy_vec_mu_', num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        entropy_str2 = horzcat('entropy_vec_mu_', num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        distance_str2 =horzcat('distance_vec_mu_', num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        end

        end



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
%         cd C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Mutual_Entropy_Calc
%         figg= figure;
%         fullscreen();
%         t = tiledlayout('flow');
% 
%         for ii=1:1:length(address2)
%         pivot2=load(TXT_filepaths{address2(ii)});
%         if resample_flag==1
%            if post_mortem_flag_18_5_21==1
%             Total_energy2=pivot2.foo; 
%             else
% 
%             Total_energy2= sum(cumsum(pivot2.foo),2);
%            end
% 
%         IL=floor(linspace(1,length(Total_energy2),length(Total_energy2)/downsample_index));
%         Total_energy =Total_energy2(IL);
%         elseif resample_flag==0
%         Total_energy=ceil(pivot2.foo);
%         end
%         nexttile;
%         plot(Total_energy)
%         xlim([0 5*10^7]);
%         end
        figg=figure;
         t = tiledlayout('flow');
        fullscreen();
        IL=(1:1:5000)*downsample_index;
        for ii=1:1:length(address)
        nexttile
        pivot=load(TXT_filepaths{address(ii)});
        %pivot3=load(TXT_filepaths{address3(ii)});
        x=1:1:(length(pivot.foo));
        x=x(IL);
        %yyaxis left
        %plot(x,sum(cumsum(pivot3.foo),2));
        %yyaxis right
        plot(x,(pivot.foo(IL,1)));
        hold on
        plot(x,(pivot.foo(IL,2)),'k');
        %ylabel('Distance from Targets, Black is 1, Orange is 2')
        %ylim([0 200]);
        xlim([0 5*10^7]);
        end
%         ax = axes(figg);
%         han = gca;
%         han.Visible = 'off';
%         % X label
%         axx=xlabel('Steps');
%         han.XLabel.Visible = 'on';
        % Left label
%         yyaxis(han, 'left');
%         ylabel('Total Entropy Production')
%         han.YLabel.Visible = 'on';
%         % Right label
%         yyaxis(han, 'right');
        end
%         Distance=pivot1.foo;

ax = axes(figg);
han = gca;
han.Visible = 'off';
% X label

% X label
xlabel(t,'t [MC steps]','FontSize',36)      
ylabel(t,horzcat(['\fontsize{36}{ ','\color{blue}d_{1}}'],',',['\fontsize{36}{ ','\color{black}d_{2}}'],' [#]'),'FontSize',36,'interpreter','tex')
set(gca,'FontSize',36)

han.XLabel.Visible = 'on';
% Left label
han.YLabel.Visible = 'on';
% han.XLabel.Visible = 'on';
% % Left label
% % yyaxis(ax, 'left');
% ylabel(horzcat('E [K_{B}T]'))
% han.YLabel.Visible = 'on';
%         if inital_flag==1
%         delays=ceil(0.8*10.^(0:0.2:log10(length(Total_energy))));
%          dime_vec=zeros(size(delays,1));
%         mutual_information=zeros(1,length(delays));
%         dime_vec=floor(length(Total_energy)./delays);
%         inital_flag=0;
%         end

%         tic
%         for mm =1:1:length(delays)
%        % pivot=load(TXT_filepaths{address(ii)});
%        
%         %Total_energy_delayed= Total_energy(delays(ii)+1:end);
%         mutual_information(mm)=mutualinfo(Total_energy(1:(floor(length(Total_energy)-delays(mm)))),Total_energy(delays(mm)+1:end));
%         sprintf(horzcat('The delay checked is',num2str(delays(mm))));
%         
%         end
%       %  x=1:1:(length(pivot2.foo));
%         yyaxis left
%     %    try
%          plot(delays,mutual_information);
%          [M,I]=findpeaks(-mutual_information) ;
%          try
%          mutual_min_vec(ii)=delays(I(end));
%          catch
%         mutual_min_vec(ii)=delays(end);
%         warning(horzcat('NO MINIMUM WAS FOUND for',TXT_filepaths{address2(ii)}))
%          end
%   %      catch
%  %          plotBig(x,pivot2.foo);
% %        end
%             %       
%     %  yyaxis right
%      %   plot(x,(pivot.foo(:,1)));
%       %  hold on
%         %plotBig(x,(pivot.foo(:,2)),'k');
%        % ylabel('Distance from Targets, Black is 1, Orange is 2')
%        % ylim([0 200]);
%        
%         toc
        
        
        
        %calculating the embedding dimension



        end
%         sprintf(num2str(mutual_min_vec,3))
%         ax = axes(figg);
%         han = gca;
%         han.Visible = 'off';
%         % X label
%         axx=xlabel('Steps');
%         han.XLabel.Visible = 'on';
%         % Left label
%         yyaxis(han, 'left');
%         ylabel('Mutual Information Energy of the Energy Vector')
%         han.YLabel.Visible = 'on';
%         % Right label
% %         yyaxis(han, 'right');
% %         ylabel('Distance from Targets, Black is 1, Orange is 2')
% %         han.YLabel.Visible = 'on';
%         set(gca,'FontSize',28)
%         posix=get(axx,'Position');
%         set(gca,'Position',[ 0.05 0.05 0.9 0.9]);
%         set(axx,'Position',[0.5 0.025 0]);
%         title(horzcat(horzcat('Mutual Information on the Summed Energy with drive mu of ',num2str(mu),' and strong energy of ',num2str(energy))))
%         han.Title.Visible = 'on';
%         figg.WindowState = 'maximized';
%         saveas(gcf,horzcat('Mutual Information on the Summed Energy of ',num2str(mu),' and strong energy of ',regexprep(num2str(energy),'\.',',')),'png');
%         save(horzcat('Minima of Mutual Information on the Summed Energy of ',num2str(mu),' and strong energy of ',regexprep(num2str(energy),'\.',',')),'mutual_min_vec')
%         
%         figg2= figure;
%         s = tiledlayout('flow');
%         maaa=zeros(length(mutual_min_vec),1);
%         for ii=1:1:length(address2)
%         %pivot2=load(TXT_filepaths{address2(ii)});
%         %Total_energy= sum(cumsum(pivot2.foo),2);
%         %Total_energy=ceil(pivot2.foo);
%         nexttile
%         tic
% 
%       %  x=1:1:(length(pivot2.foo));
%         yyaxis left
%     %    try
%         [m,n]=fnn_deneme_call(Total_energy,floor(mutual_min_vec(ii)),20,60,2);
%         if isempty(m)
%         maaa(ii)=0;
%         else
%         maaa(ii)=m;
% 
%         end
%         
%   %      catch
%  %          plotBig(x,pivot2.foo);
% %        end
%             %       
%     %  yyaxis right
%      %   plot(x,(pivot.foo(:,1)));
%       %  hold on
%         %plotBig(x,(pivot.foo(:,2)),'k');
%        % ylabel('Distance from Targets, Black is 1, Orange is 2')
%        % ylim([0 200]);
%        
%         toc
%         end
%         
%         ax = axes(figg2);
%         han = gca;
%         han.Visible = 'off';
%         % X label
%         axx=xlabel('Embedding Dimension');
%         han.XLabel.Visible = 'on';
%         % Left label
%         yyaxis(han, 'left');
%         ylabel('%F.N.N')
%         han.YLabel.Visible = 'on';
%         % Right label
% %         yyaxis(han, 'right');
% %         ylabel('Distance from Targets, Black is 1, Orange is 2')
% %         han.YLabel.Visible = 'on';
%         set(gca,'FontSize',28)
%         posix=get(axx,'Position');
%         set(gca,'Position',[ 0.05 0.05 0.9 0.9]);
%         set(axx,'Position',[0.5 0.025 0]);
%         title(horzcat(horzcat('Embedding Dimensions of Summed Energy with drive mu of ',num2str(mu),' and strong energy of ',num2str(energy))))
%         han.Title.Visible = 'on';
%         figg.WindowState = 'maximized';
        saveas(gcf,horzcat(horzcat('Trajectories of ',num2str(mu),' and strong energy of ',regexprep(num2str(energy),'\.','_'))),'png');
%          save(horzcat('Embedding Dimension on the Summed Energy of ',num2str(mu),' and strong energy of ',regexprep(num2str(energy),'\.',',')),'mutual_min_vec')
%         
        %calculating the embedding dimension

        

        




%         close gcf;
% 
%         %now entropy with distance
% 
%         figg= figure;
%         t = tiledlayout('flow');
%         
%         for ii=1:1:length(address)
%         nexttile
%         pivot=load(TXT_filepaths{address(ii)});
%         pivot3=load(TXT_filepaths{address3(ii)});
%         x=1:1:(length(pivot3.foo));
%         yyaxis left
%         plot(x,sum(cumsum(pivot3.foo),2));
%         yyaxis right
%         plot(x,(pivot.foo(:,1)));
%         hold on
%         plot(x,(pivot.foo(:,2)),'k');
%         %ylabel('Distance from Targets, Black is 1, Orange is 2')
%         %ylim([0 200]);
%         end
%         ax = axes(figg);
%         han = gca;
%         han.Visible = 'off';
%         % X label
%         axx=xlabel('Steps');
%         han.XLabel.Visible = 'on';
%         % Left label
%         yyaxis(han, 'left');
%         ylabel('Total Entropy Production')
%         han.YLabel.Visible = 'on';
%         % Right label
%         yyaxis(han, 'right');
%         ylabel('Distance from Targets, Black is 1, Orange is 2')
%         han.YLabel.Visible = 'on';
%         set(gca,'FontSize',28)
%         posix=get(axx,'Position');
%         set(gca,'Position',[ 0.05 0.05 0.9 0.9]);
%         set(axx,'Position',[0.5 0.025 0]);
%         title(horzcat('Entropy and Distance with drive mu of ',num2str(mu),' and strong energy of ',num2str(energy)))
%         han.Title.Visible = 'on';
%         figg.WindowState = 'maximized';
%         saveas(gcf,horzcat('Entropy and Distance with drive mu of ',num2str(mu),' and strong energy of ',regexprep(num2str(energy),'\.',',')),'png');
%         close gcf;
% 
%     figg= figure;
%     t = tiledlayout('flow');
% 
%     for ii=1:1:length(address2)
%     pivot2=load(TXT_filepaths{address3(ii)});
%         if resample_flag==1
%         Total_entropy2= sum(cumsum(pivot2.foo),2);
%         IL=floor(linspace(1,length(Total_entropy2),length(Total_entropy2)/downsample_index));
%         Total_energy =Total_entropy2(IL);
%         elseif resample_flag==0
%         Total_entropy=ceil(pivot2.foo);
%         end
%     nexttile
%     tic
% %     Total_energy= sum(pivot2.foo,2);
%     o=beast(Total_entropy, 'start', 0, 'season','none');
%     cp=sort(o.trend.cp);
%     x=cp;
%      xx=[0; x; length(Total_entropy)];
%      xxx=xx(2:end)-xx(1:(end-1));
%       y=xx(xxx>mutual_min_vec(ii));
% %         cp=y;
%         plot(Total_entropy);
%         hold on;
%         for i = 1 : length(cp)
%             plot( [cp(i),cp(i)], get(gca,'Ylim'), 'color', 'k');
%             ylabel('Entropy')
%             xlabel('Big Steps')
%         end
%     end
% 
% % sgtitle(horzcat('Entropy States Division, Strong Energy is ',num2str(energy_vec),' and the Drive is ',num2str(drive_vec)))
% A={};
% A_reduced={};
%     figgg= figure;
%     t = tiledlayout('flow');
%     mimi=zeros(1,length(address2));
%     for ii=1:1:length(address2)
%         pivot1=load(TXT_filepaths{address(ii)});   
%         pivot2=load(TXT_filepaths{address2(ii)});
%         if resample_flag==1
%            if post_mortem_flag_18_5_21==1
%             Total_energy2=pivot2.foo; 
%             else
% 
%             Total_energy2= sum(cumsum(pivot2.foo),2);
%            end
% 
%         IL=floor(linspace(1,length(Total_energy2),length(Total_energy2)/downsample_index));
%         Total_energy =Total_energy2(IL);
%         elseif resample_flag==0
%         Total_energy=ceil(pivot2.foo);
%         end
%            Distance1=pivot1.foo;
%           Distance=Distance1(IL,:);
%           mimi1=find(Distance(:,1)==0,1);
%           mimi2=find(Distance(:,2)==0,1);
%           if isempty(mimi1)
%           mimi1=length(Total_energy);  
%           end
%           if isempty(mimi2)
%           mimi2=length(Total_energy);
%           end
%           mimi(ii)=min(mimi1,mimi2) ;
% %optional way to create figure
%     
%     nexttile
%     tic
%     %Total_energy= pivot2.foo; 
%     %Total_energy=movingaverage(ceil(pivot2.foo));
% %    o=beast(Total_energy, 'start', 0, 'tseg.min',floor(0.1*mimi(ii)),'season','none');
% o=beast(Total_energy, 'start', 0, 'tseg.min',0.01*length(Total_energy2),'season','none');
%    %here take the new Y
%    yyy=figure;xxx=plotbeast(o);
%    h = findobj(xxx(1),'Type','line');
%    Y=h(end-1,:).YData; 
%    close(yyy)
% %    o=beast(Total_energy, 'start', 0,'season','none');
% %    oo=beast(o.trend.order, 'start', 0,'season','none');
% % cp=sort(take_change_points(o.trend.cpOccPr,o.trend.ncp_median,floor(0.1*mimi(ii))));
% cp=sort(o.trend.cp(1:o.trend.ncp_median));
% 
% if sum(isnan(cp))~=0
%    cp=cp(1:(find (isnan(cp),1)-1));     
% end   
% cp=[1 ;cp];
% %taking the first one as well
% %     cp=[1;cp];
%    if ~isempty(find (cp==0))
%    cp=cp(find (cp~=0)); 
%    end     
%    [mu_vec,std_vec,skewness_vec,trend_vec,times_vec,SA_vec,cumulated_time_vec]=give_vecs(Total_energy,Distance,Y,cp);
%     %     cp=take_change_points_option2(o.trend.cp,o.trend.cpOccPr,o.trend.ncp_median,floor(0.01*mimi(ii)));
%     cc={ mu_vec std_vec  skewness_vec cumsum(times_vec) trend_vec  SA_vec cumulated_time_vec};
% 
%     if isempty(find(SA_vec==1))
%     cc={};
%     end 
%      A=[A; cc];
% %     cp2=o.trend.cp;
% %     cp3=cp2(1:1:o.trend.ncp_median);
% %     cp=sort(cp3);
%     %cpI=sort(o.season.cp);
%     x=cp;
% %      xx=[0; x; length(Total_energy)];
% %      xxx=xx(2:end)-xx(1:(end-1));
% %       y=xx(xxx>mutual_min_vec(ii));
% %         cp=y;
%         %The_one_choosen_trajectory(Total_energy,Distance(:,1), Distance(:,2), (TXT_filepaths{ii}),Main_dir_hazirim);
% 
%          plot(Total_energy);
% %         mimi(ii)=find(Total_energy<-172,1);
%         hold on;
%         for i = 1 : length(cp)
%             plot( [cp(i),cp(i)], get(gca,'Ylim'), 'color', 'k');
%             ylabel('Energy')
%             xlabel('Big Steps')
%         end
%        title(num2str(o.trend.ncp_median))
% %                 hold on;
% %         for i = 1 : length(cpI)
% %             plot( [cpI(i),cpI(i)], get(gca,'Ylim'), 'color', 'r');
% %             ylabel('Energy')
% %             xlabel('Big Steps')
% %         end
%     end
% 
% 
%     if data_smooth_flag==1
%     sgtitle(horzcat('Energy States Division, Strong Energy is ',num2str(energy_vec),' and the Drive is ',num2str(drive_vec),' and the Downsample is ',num2str(downsample_index),' Smoothed Over ', num2str(window_samples)))
%     else
%     sgtitle(horzcat('Energy States Division, Strong Energy is ',num2str(energy_vec),' and the Drive is ',num2str(drive_vec),' and the Downsample is ',num2str(downsample_index)))
%     end
%     savefig(figure(gcf),fullfile(Main_dir_hazirim,mydir,'Energy Trajectories.fig'),'compact');
% 
% % pop=median(mimi);
% % figure; scatter(mu,mimi(:),60,'filled');
% % ylabel('Tfas Distribution','FontSize',36);
% % xlabel('Drive Mu','FontSize',36);
% % title(horzcat('Tfas Distribution ' ,num2str(mu),'',num2str(energy_vec), ' Number of Targets ',str2),'FontSize',36);
% % hold on;
% % scatter(mu,pop,90,'d','k','filled');
% ssz=size(A);
% % cmin=length(Total_energy);
% % cmax=0;
% % for ii=1:1:ssz(1)
% % c=min(A{ii,5});
% % m=max(A{ii,5});
% % cmin=min(c,cmin);
% % cmax=max(m,cmax);
% % end
% % hold off;figure
% % for ii=1:1:ssz(1)
% %     x=A{ii,1};%mean_vec
% %     y=A{ii,2};%std_vec
% %     z=A{ii,4};%trend
% %     c=A{ii,5};%time
% %     
% % TrajectoryPlotVecs(x,y,z,c,cmin,cmax);
% % 
% % end
% % xlabel('Mean');
% % ylabel('Variance');
% % zlabel('Trend');
% % title('Trajectories of Simulation CG States with Time Colorbar')
% % % savefig('Stochastic 1');
% % %mydir='yourfullyqualifiedpath';
% % savefig(figure(gcf),fullfile(Main_dir_hazirim,mydir,'Stochastic 1.fig'),'compact');
% % 
% % %Now the remaining time to self assembly
% % 
% % cmin=length(Total_energy);
% % cmax=0;
% % for ii=1:1:ssz(1)
% % c=min(A{ii,7}~=0);
% % m=max(A{ii,7});
% % cmin=min(c,cmin);
% % cmax=max(m,cmax);
% % end
% % hold off;figure
% % for ii=1:1:ssz(1)
% %     x=A{ii,1};%mean_vec
% %     y=A{ii,2};%std_vec
% %     z=A{ii,4};%trend
% %     c=A{ii,7};%time
% %     %new index
% %     INDEX_nan=find(isnan (c));
% %     Index_Zero=find(c==0);
% %     Index_correct=find(c~=0);
% % TrajectoryPlotVecs4TfasMap(x,y,z,c,cmin,cmax,INDEX_nan,Index_Zero,Index_correct);
% % 
% % end
% % xlabel('Mean');
% % ylabel('Variance');
% % zlabel('Trend');
% % title('Trajectories of Simulation CG States with Time Remaining to Self Assemble Colorbar')
% % % savefig('Stochastic 2');
% % savefig(figure(gcf),fullfile(Main_dir_hazirim,mydir,'Stochastic 2.fig'),'compact');
% % 
% % %Time remanining to Self Assemble, just first one
% % 
% % cmin=length(Total_energy);
% % cmax=0;
% % 
% % for ii=1:1:ssz(1)
% %   AA=A{ii,7};  
% %  ending_theme=find(AA==0,1);
% %  AA=AA(1:ending_theme);
% % c=min(AA(AA>0));
% % m=max(AA);
% % cmin=min(c,cmin);
% % cmax=max(m,cmax);
% % 
% % end
% % 
% % hold off;figure
% % for ii=1:1:ssz(1)
% %     x=A{ii,1};%mean_vec
% %     y=A{ii,2};%std_vec
% %     z=A{ii,4};%trend
% %     c=A{ii,7};%time
% %     ending_theme=find(c==0,1);
% %     x=x(1:ending_theme);
% %     y=y(1:ending_theme);
% %     z=z(1:ending_theme);
% %     c=c(1:ending_theme);
% % %     A_reduced=[A_reduced; x y z];
% %     %new index
% %     INDEX_nan=find(isnan (c));
% %     Index_Zero=find(c==0);
% %     Index_correct=find(c~=0);
% % % TrajectoryPlotVecs4TfasMap(x,y,z,c,cmin,cmax,INDEX_nan,Index_Zero,Index_correct);
% % TrajectoryPlotVecs(x,y,z,c,cmin,cmax);
% % end
% % xlabel('Mean','FontSize',28);
% % ylabel('Variance','FontSize',28);
% % zlabel('Trend','FontSize',28);
% % title('Trajectories of Simulation CG States with Time Remaining to FIRST Self Assemble Colorbar')
% % % savefig('Stochastic 3');
% % savefig(figure(gcf),fullfile(Main_dir_hazirim,mydir,'Stochastic 3.fig'),'compact');
% % 
% % hold off;figure
% % 
% % for ii=1:1:ssz(1)
% %     x=A{ii,1};%mean_vec
% %     y=A{ii,2};%std_vec
% %     z=A{ii,4};%trend
% %     c=A{ii,6};%SA
% %     
% % TrajectoryPlotVecs(x,y,z,c,0,1);
% % 
% % end
% % xlabel('Mean');
% % ylabel('Variance');
% % zlabel('Trend');
% % title('Trajectories of Simulation CG States with Time Colorbar')
% % % savefig('Stochastic 4');
% % savefig(figure(gcf),fullfile(Main_dir_hazirim,mydir,'Stochastic 4.fig'),'compact');
% % 
% % 
% % 
% % hold off;figure
% % for ii=1:1:ssz(1)
% %     x=A{ii,1};%mean_vec
% %     y=A{ii,2};%std_vec
% %     z=A{ii,4};%trend
% %     c=A{ii,6};%SA
% %     ending_theme=find(c==1,1);
% %     x=x(1:ending_theme);
% %     y=y(1:ending_theme);
% %     z=z(1:ending_theme);
% %     c=c(1:ending_theme);
% % 
% % TrajectoryPlotVecs(x,y,z,c,0,1);
% % 
% % end
% % xlabel('Mean');
% % ylabel('Variance');
% % zlabel('Trend');
% % title('Trajectories of Simulation CG States with Time Colorbar,TFAS ONLY')
% % savefig(figure(gcf),fullfile(Main_dir_hazirim,mydir,'Stochastic 5.fig'),'compact');
% 
% cd(xxy);
% A_reduced=[];
% C_reduced=[];
% for ii=1:1:ssz(1)
%     x=A{ii,1};%mean_vec
%     y=A{ii,2};%std_vec
%     z=A{ii,5};%trend
%     w=A{ii,3};%skew
%     v=A{ii,4};%total_trajectorytime
%     c=A{ii,7};%time to self assemble
%     ending_theme=find(c==0,1);
%     x=x(1:ending_theme);
%     y=y(1:ending_theme);
%     z=z(1:ending_theme);
%     c=c(1:ending_theme);
%     w=w(1:ending_theme);
%     v=v(1:ending_theme)
%     B_reduced=[ x; y; z; c]';
%     D_reduced=[ x; y; z; w; v; c]';
%     A_reduced=[A_reduced; B_reduced];
%     C_reduced=[C_reduced; D_reduced];
% end
% save('A_redcued.mat','A_reduced');
% save('C_redcued.mat','A_reduced');
% 
%     M_reduced=C_reduced(:,1:3);
% Mm_reduced=(M_reduced-mean(M_reduced,1))./std(M_reduced,1);
% [coeff,score,latent] = pca(Mm_reduced);
% cmin=0;
% cmax=3000;
% hold off;figure
% for ii=1:1:ssz(1)
%     x=score(:,1);%mean_vec
%     y=score(:,2);%std_vec
%     z=score(:,3);%trend
%     c=C_reduced(:,6);
% %     c=A{ii,7};%time
% %     ending_theme=find(c==0,1);
% %     x=x(1:ending_theme);
% %     y=y(1:ending_theme);
% %     z=z(1:ending_theme);
% %     c=c(1:ending_theme);
% %     A_reduced=[A_reduced; x y z];
%     %new index
% %     INDEX_nan=find(isnan (c));
% %     Index_Zero=find(c==0);
% %     Index_correct=find(c~=0);
% % TrajectoryPlotVecs4TfasMap(x,y,z,c,cmin,cmax,INDEX_nan,Index_Zero,Index_correct);
% TrajectoryPlotVecs(x,y,z,c,cmin,cmax);
% end
% xlabel('Mean','FontSize',28);
% ylabel('Variance','FontSize',28);
% zlabel('Trend','FontSize',28);
% title('NEW COORD,Trajectories of Simulation CG States with Time Remaining to FIRST Self Assemble Colorbar')
% % savefig('Stochastic 3');
% savefig(figure(gcf),fullfile(Main_dir_hazirim,mydir,'Stochastic 6.fig'),'compact');


% %check matrix 
%  load('MetricMap.mat'); %should be h here
% 
%  for ii=1:1:size(A_reduced,1)
% % (ii)
% % 
%  end


