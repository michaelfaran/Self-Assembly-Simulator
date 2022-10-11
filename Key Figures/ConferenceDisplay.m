ylabel('TiT','FontSize',36)
xlabel('\Delta\mu','FontSize',36)
delta_mu=0:1:10;
% hold on;
% plot(delta_mu,[pop(1:1:10); 10^7],'r','LineWidth',5);
set(gca,'FontSize',36)
ylim([0 5*10^7])
xlim([-0.5 10])
 fullscreen();