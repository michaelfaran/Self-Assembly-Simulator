%calculate the first minimum of the mutual infromation to describe delay

%total energy
%delays=[logspace(10,10,10)]
cd(['C:\Users\admin\Documents\GitHub\GradProject\Results\04_19_2022_21_33_44-The_Choosen_Optimist\2' ...
    '']);
mainFolder = cd;
addpath ('C:\Users\admin\Documents\GitHub\GradProject\mi');
addpath('C:\Users\admin\Documents\GitHub\GradProject\github_repo');
addpath('C:\Users\admin\Documents\GitHub\GradProject\rp-master\rp-master');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject');
addpath('C:\Users\admin\Documents\GitHub\GradProject\knee_pt')
addpath('C:\Users\admin\Documents\GitHub\GradProject\Sankey\Sankey')
energy_vec=4.5;
drive_vec=1;
delays=4*10.^(0:0.1:2);
mutual_information=zeros(1,length(delays));

for idi=1:1:length(energy_vec)

    for jj=1:1:length(drive_vec)
        
        %initate our dreams
        mu = drive_vec(jj);
        energy= energy_vec(idi);
        %num_of_targets_might_change
        %check check
        
        %the figures of merit,"distance","energy","entropy
        
        %distance_str =horzcat('distance_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        energy_str =horzcat('energy_UP_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        %entropy_str = horzcat('entropy_vec_mu_',num2str(mu),'_energy_',char(sprintfc('%0.1f',energy)));
        



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
        %listt= ~cellfun('isempty',strfind(TXT_filepaths,distance_str));
        %address=find (listt==1);
        %energyzing
        listt2= ~cellfun('isempty',strfind(TXT_filepaths,energy_str));
        address2=find (listt2==1);
        mutual_min_vec=zeros(length(address2),1);
        %listt3= ~cellfun('isempty',strfind(TXT_filepaths,entropy_str));
        %address3=find (listt3==1);   
        
        pivot_length=length(load(TXT_filepaths{address2(ii)}).foo);
        energy_vecs = zeros(pivot_length,length(address2)) ;
        delay_vec= zeros(1,length(address2));
        dimension_vec= zeros(1,length(address2));

        figg= figure;
        t = tiledlayout('flow');
     
        for ii=1:1:length(address2)
        pivot2=load(TXT_filepaths{address2(ii)});
        
        %Total_energy= sum(cumsum(pivot2.foo),2);
        Total_energy=ceil(pivot2.foo);
        energy_vecs(:,ii)=Total_energy;
        nexttile
        tic
        for mm =1:1:length(delays)
       % pivot=load(TXT_filepaths{address(ii)});
       
        %Total_energy_delayed= Total_energy(delays(ii)+1:end);
        mutual_information(mm)=mutualinfo(Total_energy(1:(floor(length(Total_energy)-delays(mm)))),Total_energy(delays(mm)+1:end));
        sprintf(horzcat('The delay checked is',num2str(delays(mm))));
        
        end
      %  x=1:1:(length(pivot2.foo));
        yyaxis left
    %    try
         plot(delays,mutual_information);
         [M,I]=min(mutual_information) ;
         mutual_min_vec(ii)=delays(I);
  %      catch
 %          plotBig(x,pivot2.foo);
%        end
            %       
    %  yyaxis right
     %   plot(x,(pivot.foo(:,1)));
      %  hold on
        %plotBig(x,(pivot.foo(:,2)),'k');
       % ylabel('Distance from Targets, Black is 1, Orange is 2')
       % ylim([0 200]);
       
        toc
        end
        
        
        %calculating the embedding dimension



        end
        sprintf(num2str(mutual_min_vec,3))
        ax = axes(figg);
        han = gca;
        han.Visible = 'off';
        % X label
        axx=xlabel('Steps');
        han.XLabel.Visible = 'on';
        % Left label
        yyaxis(han, 'left');
        ylabel('Mutual Information Energy of the Energy Vector')
        han.YLabel.Visible = 'on';
        % Right label
%         yyaxis(han, 'right');
%         ylabel('Distance from Targets, Black is 1, Orange is 2')
%         han.YLabel.Visible = 'on';
        set(gca,'FontSize',28)
        posix=get(axx,'Position');
        set(gca,'Position',[ 0.05 0.05 0.9 0.9]);
        set(axx,'Position',[0.5 0.025 0]);
        title(horzcat(horzcat('Mutual Information on the Summed Energy with drive mu of ',num2str(mu),' and strong energy of ',num2str(energy))))
        han.Title.Visible = 'on';
        figg.WindowState = 'maximized';
        saveas(gcf,horzcat('Mutual Information on the Summed Energy of ',num2str(mu),' and strong energy of ',regexprep(num2str(energy),'\.',',')),'png');
        save(horzcat('Minima of Mutual Information on the Summed Energy of ',num2str(mu),' and strong energy of ',regexprep(num2str(energy),'\.',',')),'mutual_min_vec')
        
        figg2= figure;
        s = tiledlayout('flow');
        maaa=zeros(length(mutual_min_vec),1);
        for ii=1:1:length(address2)
        pivot2=load(TXT_filepaths{address2(ii)});
        %Total_energy= sum(cumsum(pivot2.foo),2);
        Total_energy=ceil(pivot2.foo);
        nexttile
        tic

      %  x=1:1:(length(pivot2.foo));
        yyaxis left
    %    try
        delay_vec(ii)=floor(mutual_min_vec(ii));
        [m,lo,n]=fnn_deneme_call(Total_energy,floor(mutual_min_vec(ii)),20,60,2);
        maaa(ii)=m;

        
  %      catch
 %          plotBig(x,pivot2.foo);
%        end
            %       
    %  yyaxis right
     %   plot(x,(pivot.foo(:,1)));
      %  hold on
        %plotBig(x,(pivot.foo(:,2)),'k');
       % ylabel('Distance from Targets, Black is 1, Orange is 2')
       % ylim([0 200]);
       
        toc
        end
        
        ax = axes(figg2);
        han = gca;
        han.Visible = 'off';
        % X label
        axx=xlabel('Embedding Dimension');
        han.XLabel.Visible = 'on';
        % Left label
        yyaxis(han, 'left');
        ylabel('%F.N.N')
        han.YLabel.Visible = 'on';
        % Right label
%         yyaxis(han, 'right');
%         ylabel('Distance from Targets, Black is 1, Orange is 2')
%         han.YLabel.Visible = 'on';
        set(gca,'FontSize',28)
        posix=get(axx,'Position');
        set(gca,'Position',[ 0.05 0.05 0.9 0.9]);
        set(axx,'Position',[0.5 0.025 0]);
        title(horzcat(horzcat('Embedding Dimensions of Summed Energy with drive mu of ',num2str(mu),' and strong energy of ',num2str(energy))))
        han.Title.Visible = 'on';
        figg.WindowState = 'maximized';
        saveas(gcf,horzcat(horzcat('Embedding Dimensions of Summed Energy with drive mu of ',num2str(mu),' and strong energy of ',num2str(energy))),'png');
        save(horzcat('Embedding Dimension on the Summed Energy of ',num2str(mu),' and strong energy of ',regexprep(num2str(energy),'\.',',')),'mutual_min_vec')
        
        %calculating the embedding dimension



        end




for jj=1:1:length(maaa)


delay=delay_vec(jj);
d=maaa(jj);
Total_energy=energy_vecs(:,jj);
N = length(Total_energy); % length of time series
y = embed(Total_energy,d,delay); % embed into 2 dimensions using delay 17
index_y=embed(1:1:length(Total_energy),d,delay);

figure;
epsilon_vec=0.1:0.1:10;
epsilon_vec=10;
recurrurence_vec=zeros(size(epsilon_vec));
entropy_vec=zeros(size(epsilon_vec));
[R,D]=rp(y,0,'fix','max');
h= histogram(D);
vec_val=sort(h.BinEdges);
lek=length(h.BinEdges);
high_per=floor(0.95*lek);
low_per=floor( 0.5*lek);
num_of_eps_val=15;
mega_eps_vec=linspace(vec_val(low_per),vec_val(high_per),num_of_eps_val);



for ii=1:1:length(recurrurence_vec)
[R,D]=rp(y,epsilon_vec(ii),'fix','max');
R=R-diag(diag(R));
recurrurence_vec(ii) = sum(sum(R))/(length(recurrurence_vec).*length(recurrurence_vec)); % calculate RP using maximum norm and fixed threshold
z=rqa(R,1,0);

end

figure;
imagesc(R);
colorbar
title(horzcat('Recurrence Plot, Euclidean Distance is ',num2str(epsilon_vec(ii)),' Delay in Big Steps and Dimension are ',num2str(delay),' & ',num2str(d)),'FontSize',42)
ylabel('Vec Number','FontSize',42)
xlabel('Vec Number','FontSize',42)

figure;
plot(epsilon_vec,recurrurence_vec);


end




















        %close gcf;

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





%delays=10.^(2:1:7);
%res =[10000];
%Total_energy= sum(cumsum(pivot2.foo),2);
%delays=2:res:length(ceil(0.5*Total_energy-2));
% delays=10.^(1:0.1:7);
% mutual_information=zeros(1,length(delays));
% 
% for ii=1:1:length(delays)
% tic
% Total_energy_delayed= Total_energy(delays(ii)+1:end);
% mutual_information(ii)=mutualinfo(Total_energy(1:(length(Total_energy)-delays(ii))),Total_energy_delayed);
% sprintf(horzcat('The delay checked is',num2str(delays(ii))));
% toc
% end
% 
% figure;
% plot(delays,10*log10(mutual_information));
% title('Mutual information(Delays)')
% ylabel('Mutual information(#)');
% xlabel('Delays(steps)');