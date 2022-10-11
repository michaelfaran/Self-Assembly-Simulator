function The_one_choosen_trajectory(Total_energy,distance1,distance2,address,mainFolder)
address1=fileparts(address);
figure;
% subplot(3,2,[1 2]);
set(gca,'FontSize',36)
disco=10^4*linspace(1,length(distance2),length(distance2));
turncoats=10^4*[1000,2000,3000,4000];
yyaxis left
plot(disco,Total_energy,'b');
 ylabel('Energy','FontSize',36);
yyaxis right
plot(disco,distance1,'r--');
hold on;
plot(disco,distance2,'g-.');
hold on;
 ylabel('d','FontSize',36);
 xlabel('MC steps','FontSize',36);

% for i = 1 : length(turncoats)
% xline(turncoats(i),'--k');
% end
hold on
plot([turncoats; turncoats], [ylim; ylim; ylim; ylim]','k--','LineWidth',3)
hold off
text(turncoats-700000, 1.2*double(max(max(distance1),max(distance2))).*[1 1 1 1], {'B', 'C', 'D','E'},'FontSize',36)

fullscreen();
 [x1,x2,x3]=fileparts(address);
 [x4,x5,x6]=fileparts(x1);
 [x7,x8,x9]=fileparts(x4);
 [x10,x11,x12]=fileparts(x7);
 ix2=strfind (x2,'_');

 yourFolder=replace(horzcat(mainFolder,'\',x11,x12,'_',x8),'.','_');
    if ~exist(yourFolder, 'dir')
       mkdir(yourFolder)
    end
    previoudcd=cd;
%     hold on;

%     tiledlayout(2,2)
% img_cell={};
     for ii=1:1:length(turncoats)
         cd(x1)
% %         nexttile;
% %      subplot(3,2,2+ii)
     name=horzcat('State_mu_',x2((ix2(3)+1):(ix2(4)-1)),'_run_index_', num2str(str2num(x2((ix2(end-4)+1):(ix2(end-3)-1)))-1),'_num_target_0_turn_number_');
imname=horzcat(name,num2str(turncoats(ii)),'_J_strong_-',x2(strfind (x2,'energy')+(7:9)),'.png');
% img = imread(imname);
% img_cell=[img_cell img];
copyfile( imname, yourFolder)
    end
%     multi = cat(1,img_cell{1},img_cell{2},img_cell{3},img_cell{4});
%      montage(multi);
 cd(previoudcd);
%  AddLetters2Plots(gcf)
meata=horzcat(x5,'_',x2,'.png');
cd(yourFolder)
saveas(gcf,meata);
cd(mainFolder)