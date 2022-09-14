


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

BubblePlot(ones(1,numel(d))*drive_vec(idic), a*downsample_index*helper, d,'b');
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

