%Load results;
cd(['C:\Users\admin\Documents\GitHub\GradProject\Results\04_19_2022_21_33_44-The_Choosen_Optimist\2' ...
    '']);
mainFolder = cd;
addpath('C:\Users\admin\Documents\GitHub\GradProject\github_repo')
energy_vec=4:0.5:5;
drive_vec=2;

for idi=1:1:length(energy_vec)

    for jj=1:1:length(drive_vec)
        
        %initate our dreams
        mu = drive_vec(jj);
        energy= energy_vec(idi);
        %num_of_targets_might_change
        %check check
        
        %the figures of merit,"distance","energy","entropy
        
        distance_str =horzcat('distance_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        energy_str =horzcat('energy_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        entropy_str = horzcat('entropy_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        



        %Meet the butcher
         [~,message,~] = fileattrib([mainFolder,'\*']);
         fprintf('\n There are %i total files & folders.\n',numel(message));
         allExts = cellfun(@(s) s(end-2:end),{message.Name},'uni',0);% Get file ext
         TXTidx = ismember(allExts,'mat');% Search extensions for "CSV" at the end 
         TXT_filepaths = {message(TXTidx).Name};  % Use idx of TXTs to list paths.
         fprintf('There are %i files with *.mat file ext.\n',numel(TXT_filepaths));
        %rename the files if needed
%         Vecc=~cellfun('isempty',strfind(TXT_filepaths,distance_str));
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



        %distancething
        listt= ~cellfun('isempty',strfind(TXT_filepaths,distance_str));
        address=find (listt==1);
        %energyzing
        listt2= ~cellfun('isempty',strfind(TXT_filepaths,energy_str));
        address2=find (listt2==1);

        listt3= ~cellfun('isempty',strfind(TXT_filepaths,entropy_str));
        address3=find (listt3==1);   
        
        figg= figure;
        t = tiledlayout('flow');
        
        for ii=1:1:length(address2)
        nexttile
        pivot=load(TXT_filepaths{address(ii)});
        pivot2=load(TXT_filepaths{address2(ii)});
        x=1:1:(length(pivot2.foo));
        yyaxis left
        try
            plotBig(x,sum(cumsum(pivot2.foo),2));
        catch
            plotBig(x,pivot2.foo);
        end
            %       
      yyaxis right
        plot(x,(pivot.foo(:,1)));
        hold on
        plotBig(x,(pivot.foo(:,2)),'k');
        ylabel('Distance from Targets, Black is 1, Orange is 2')
        ylim([0 200]);
        end
        ax = axes(figg);
        han = gca;
        han.Visible = 'off';
        % X label
        axx=xlabel('Steps');
        han.XLabel.Visible = 'on';
        % Left label
        yyaxis(han, 'left');
        ylabel('Total Energy')
        han.YLabel.Visible = 'on';
        % Right label
%         yyaxis(han, 'right');
%         ylabel('Distance from Targets, Black is 1, Orange is 2')
%         han.YLabel.Visible = 'on';
        set(gca,'FontSize',28)
        posix=get(axx,'Position');
        set(gca,'Position',[ 0.05 0.05 0.9 0.9]);
        set(axx,'Position',[0.5 0.025 0]);
        title(horzcat(horzcat('Mini Summed Energy with drive mu of ',num2str(mu),' and strong energy of ',num2str(energy))))
        han.Title.Visible = 'on';
        figg.WindowState = 'maximized';
        saveas(gcf,horzcat('Mini Summed Energy with drive mu of ',num2str(mu),' and strong energy of ',regexprep(num2str(energy),'\.',',')),'png');
        close gcf;

        %now entropy with distance
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
    end
end

