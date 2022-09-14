figure;

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
%     cp2=o.trend.cp;
%     cp3=cp2(1:1:o.trend.ncp_median);
%     cp=sort(cp3);
    %cpI=sort(o.season.cp);
    x=cp;
%      xx=[0; x; length(Total_energy)];
%      xxx=xx(2:end)-xx(1:(end-1));
%       y=xx(xxx>mutual_min_vec(ii));
%         cp=y;
        %The_one_choosen_trajectory(Total_energy,Distance(:,1), Distance(:,2), (TXT_filepaths{ii}),Main_dir_hazirim);

         plot((1:1:length(Total_energy))*10000,Total_energy);
%         mimi(ii)=find(Total_energy<-172,1);
        hold on;
        for i = 1 : length(cp)
            plot( [cp(i),cp(i)]*10000, get(gca,'Ylim'), 'color', 'k');
            ylabel('E [K_{B}T]')
            xlabel('t [MC Steps]')
            ylim([min(Total_energy)-1 0])
        end         
        set(gca,'FontSize',36)
