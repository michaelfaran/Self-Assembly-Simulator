%Michael crazy clustering attempt
%taking a sliding window of mutual information first minima ahaead, and
%then do a sliding window approach, and compare the distance from all other
%vectors 
try_delay=floor(delays(I2));
crazy_mat=zeros(length(Total_energy2)-try_delay,try_delay);

for ii=1:1:size(crazy_mat,1)
crazy_mat(ii,1:try_delay)=Total_energy2(ii:(try_delay+ii-1));
end

norm_matrix=zeros(size(crazy_mat,1),size(crazy_mat,1));

for ii=1:1:size(crazy_mat,1)
    for jj=1:1:size(crazy_mat,1)
    norm_matrix(ii,jj)=norm(crazy_mat(ii,:)-crazy_mat(jj,:));
    end
end

G = graph(norm_matrix);
% m_dim=dime_vec(I2);
%labels = dbscan(R,30,1);
yyyy=figure;
a = axes;
hh=plot(a,G);
X=zeros(length(hh.XData),2);
X(:,1)=hh.XData;
X(:,2)=hh.YData;
close(yyyy)
%the value here  in minpts should just be bigger than the dimension of plus 1 the size
%of X according to matlab suggestion
minpts = 50;
kD = pdist2(X,X,'euc','Smallest',minpts);
% figure;
% plot(sort(kD(end,:)));
% title('k-distance graph')
% xlabel('Points sorted with 4th nearest distances')
% ylabel('50th nearest distances')
sortedkD=sort(kD(end,:));  
[res_x, idx_of_result] = knee_pt(sortedkD,1:1:length(kD),0);
epsilon=sortedkD(idx_of_result);
%grid
% epsilon=1;
%labels = dbscan(X,epsilon,minpts);
labelss= dbscan(X,epsilon,minpts); 

% labelss_prefering_flags=(1:1:m_dim).*floor(delays(I2));


figure; 
 gscatter( X(:,1), X(:,2),labelss);
 new_labels=ones(1,length(Total_energy2));
 for ii=1:1:(length(Total_energy2)-try_delay)
    state= labelss(ii);
    new_labels(ii) =state;
 end

vec_val2=unique(new_labels);

for ii=1:1:length(vec_val2)
find(new_labels==vec_val2(ii));
end

rooster= figure;
plot(Total_energy);
hold on
for ii=1:1:length(vec_val2)
scatter(find(new_labels==vec_val2(ii)),Total_energy(find(new_labels==vec_val2(ii))),200,'filled')

end
title(horzcat('Clustered Total Energy, Js is ',num2str(Js),' mu is ',num2str(drive)),'FontSize',42)
xlabel('Step','FontSize',42)
ylabel('Total Energy(k_{B}T)','FontSize',42);