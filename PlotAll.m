%Load results;
cd('C:\Users\admin\Documents\GitHub\GradProject\Results\11_08_2021_18_28_06');
% foo01=load('entropy_vec_mu_0_run_num_1_num_target_1_total_num_target_2.mat');
% foo02=load('entropy_vec_mu_0_run_num_2_num_target_1_total_num_target_2.mat');
% foo03=load('entropy_vec_mu_0_run_num_3_num_target_1_total_num_target_2.mat');
% foo11=load('entropy_vec_mu_1_run_num_1_num_target_1_total_num_target_2.mat');
% foo12=load('entropy_vec_mu_1_run_num_2_num_target_1_total_num_target_2.mat');
% foo13=load('entropy_vec_mu_1_run_num_3_num_target_1_total_num_target_2.mat');
% foo21=load('entropy_vec_mu_2_run_num_1_num_target_1_total_num_target_2.mat');
% foo22=load('entropy_vec_mu_2_run_num_2_num_target_1_total_num_target_2.mat');
% foo23=load('entropy_vec_mu_2_run_num_3_num_target_1_total_num_target_2.mat');
% foo01d=load('distance_vec_mu_0_run_num_1_num_target_1_total_num_target_2.mat');
% foo02d=load('distance_vec_mu_0_run_num_2_num_target_1_total_num_target_2.mat');
% foo03d=load('distance_vec_mu_0_run_num_3_num_target_1_total_num_target_2.mat');
% foo11d=load('distance_vec_mu_1_run_num_1_num_target_1_total_num_target_2.mat');
% foo12d=load('distance_vec_mu_1_run_num_2_num_target_1_total_num_target_2.mat');
% foo13d=load('distance_vec_mu_1_run_num_3_num_target_1_total_num_target_2.mat');
% foo21d=load('distance_vec_mu_2_run_num_1_num_target_1_total_num_target_2.mat');
% foo22d=load('distance_vec_mu_2_run_num_2_num_target_1_total_num_target_2.mat');
% foo23d=load('distance_vec_mu_2_run_num_3_num_target_1_total_num_target_2.mat');
% foo01e=load('energy_vec_mu_0_run_num_1_num_target_1_total_num_target_2.mat');
% foo02e=load('energy_vec_mu_0_run_num_2_num_target_1_total_num_target_2.mat');
% foo03e=load('energy_vec_mu_0_run_num_3_num_target_1_total_num_target_2.mat');
% foo11e=load('energy_vec_mu_1_run_num_1_num_target_1_total_num_target_2.mat');
% foo12e=load('energy_vec_mu_1_run_num_2_num_target_1_total_num_target_2.mat');
% foo13e=load('energy_vec_mu_1_run_num_3_num_target_1_total_num_target_2.mat');
% foo21e=load('energy_vec_mu_2_run_num_1_num_target_1_total_num_target_2.mat');
% foo22e=load('energy_vec_mu_2_run_num_2_num_target_1_total_num_target_2.mat');
% foo23e=load('energy_vec_mu_2_run_num_3_num_target_1_total_num_target_2.mat');


foo01=load('entropy_vec_mu_0_run_num_1_num_target_1_total_num_target_2.mat');
foo02=load('entropy_vec_mu_0_run_num_2_num_target_1_total_num_target_2.mat');
foo03=load('entropy_vec_mu_0_run_num_3_num_target_1_total_num_target_2.mat');
foo11=load('entropy_vec_mu_1_run_num_1_num_target_1_total_num_target_2.mat');
foo12=load('entropy_vec_mu_1_run_num_2_num_target_1_total_num_target_2.mat');
foo13=load('entropy_vec_mu_1_run_num_3_num_target_1_total_num_target_2.mat');
foo21=load('entropy_vec_mu_2_run_num_1_num_target_1_total_num_target_2.mat');
foo22=load('entropy_vec_mu_2_run_num_2_num_target_1_total_num_target_2.mat');
foo23=load('entropy_vec_mu_2_run_num_3_num_target_1_total_num_target_2.mat');
foo01d=load('distance_vec_mu_0_run_num_1_num_target_1_total_num_target_2.mat');
foo02d=load('distance_vec_mu_0_run_num_2_num_target_1_total_num_target_2.mat');
foo03d=load('distance_vec_mu_0_run_num_3_num_target_1_total_num_target_2.mat');
foo11d=load('distance_vec_mu_1_run_num_1_num_target_1_total_num_target_2.mat');
foo12d=load('distance_vec_mu_1_run_num_2_num_target_1_total_num_target_2.mat');
foo13d=load('distance_vec_mu_1_run_num_3_num_target_1_total_num_target_2.mat');
foo21d=load('distance_vec_mu_2_run_num_1_num_target_1_total_num_target_2.mat');
foo22d=load('distance_vec_mu_2_run_num_2_num_target_1_total_num_target_2.mat');
foo23d=load('distance_vec_mu_2_run_num_3_num_target_1_total_num_target_2.mat');
foo01e=load('energy_vec_mu_0_run_num_1_num_target_1_total_num_target_2.mat');
foo02e=load('energy_vec_mu_0_run_num_2_num_target_1_total_num_target_2.mat');
foo03e=load('energy_vec_mu_0_run_num_3_num_target_1_total_num_target_2.mat');
foo11e=load('energy_vec_mu_1_run_num_1_num_target_1_total_num_target_2.mat');
foo12e=load('energy_vec_mu_1_run_num_2_num_target_1_total_num_target_2.mat');
foo13e=load('energy_vec_mu_1_run_num_3_num_target_1_total_num_target_2.mat');
foo21e=load('energy_vec_mu_2_run_num_1_num_target_1_total_num_target_2.mat');
foo22e=load('energy_vec_mu_2_run_num_2_num_target_1_total_num_target_2.mat');
foo23e=load('energy_vec_mu_2_run_num_3_num_target_1_total_num_target_2.mat');

x=1:1:(length(foo01.foo));
%plot everything

figure;
 subplot(3,3,1);
 plot(x,cumsum(foo01.foo));
yyaxis left
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 0, run 1, num of target 2')
yyaxis right
plot(x,(foo01d.foo(:,1)));
hold on
plot(x,(foo01d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);

subplot(3,3,2);
yyaxis left
plot(x,cumsum(foo02.foo));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 0, run 2, num of target 2')
yyaxis right
plot(x,(foo02d.foo(:,1)));
hold on
plot(x,(foo02d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);

subplot(3,3,3);
yyaxis left
plot(x,cumsum(foo03.foo));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 0, run 3, num of target 2')
yyaxis right
plot(x,(foo03d.foo(:,1)));
hold on
plot(x,(foo03d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);

subplot(3,3,4);
yyaxis left
plot(x,cumsum(foo11.foo));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 0, run 3, num of target 2')
yyaxis right
plot(x,(foo11d.foo(:,1)));
hold on
plot(x,(foo11d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);

subplot(3,3,5);
yyaxis left
plot(x,cumsum(foo12.foo));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 1, run 2, num of target 2')
yyaxis right
plot(x,(foo12d.foo(:,1)));
hold on
plot(x,(foo12d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);

subplot(3,3,6);
yyaxis left
plot(x,cumsum(foo13.foo));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 1, run 2, num of target 2')
yyaxis right
plot(x,(foo13d.foo(:,1)));
hold on
plot(x,(foo13d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);

subplot(3,3,7);
yyaxis left
plot(x,cumsum(foo21.foo));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 2, run 1, num of target 2')
yyaxis right
plot(x,(foo21d.foo(:,1)));
hold on
plot(x,(foo21d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);

subplot(3,3,8);
yyaxis left
plot(x,cumsum(foo22.foo));
yyaxis right
plot(x,(foo22d.foo(:,1)));
hold on
plot(x,(foo22d.foo(:,2)),'k');
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 2, run 2, num of target 2')
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
subplot(3,3,9);
yyaxis left
plot(x,cumsum(foo23.foo));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 2, run 3, num of target 2')
yyaxis right
plot(x,(foo23d.foo(:,1)));
hold on
plot(x,(foo23d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);

saveas(gcf,'Entropy.png')
 %distances
 
%plot the total energy over time

figure;
subplot(3,3,1);
yyaxis left
plot(x,cumsum(foo01e.foo));
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 0, run 1, num of target 2')
yyaxis right
plot(x,(foo01d.foo(:,1)));
hold on
plot(x,(foo01d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
subplot(3,3,2);
yyaxis left
plot(x,cumsum(foo02e.foo));
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 0, run 2, num of target 2')
yyaxis right
plot(x,(foo02d.foo(:,1)));
hold on
plot(x,(foo02d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
subplot(3,3,3);
yyaxis left
plot(x,cumsum(foo03e.foo));
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 0, run 3, num of target 2')
yyaxis right
plot(x,(foo03d.foo(:,1)));
hold on
plot(x,(foo03d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
subplot(3,3,4);
yyaxis left
plot(x,cumsum(foo11e.foo));
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 1, run 1, num of target 2')
yyaxis right
plot(x,(foo11d.foo(:,1)));
hold on
plot(x,(foo11d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
subplot(3,3,5);
yyaxis left
plot(x,cumsum(foo12e.foo));
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 1, run 2, num of target 2')
yyaxis right
plot(x,(foo12d.foo(:,1)));
hold on
plot(x,(foo12d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
subplot(3,3,6);
yyaxis left
plot(x,cumsum(foo13e.foo));
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 0, run 3, num of target 2')
yyaxis right
plot(x,(foo13d.foo(:,1)));
hold on
plot(x,(foo13d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
subplot(3,3,7);
yyaxis left
plot(x,cumsum(foo21e.foo));
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 2, run 1, num of target 2')
yyaxis right
plot(x,(foo21d.foo(:,1)));
hold on
plot(x,(foo21d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
subplot(3,3,8);
yyaxis left
plot(x,cumsum(foo21e.foo));
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 2, run 2, num of target 2')
yyaxis right
plot(x,(foo22d.foo(:,1)));
hold on
plot(x,(foo22d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
subplot(3,3,8);
yyaxis left
plot(x,cumsum(foo21e.foo));
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 2, run 2, num of target 2')
yyaxis right
plot(x,(foo22d.foo(:,1)));
hold on
plot(x,(foo22d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
subplot(3,3,9);
yyaxis left
plot(x,(foo23d.foo(:,1)));
hold on
plot(x,(foo23d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
xlabel('Steps')
title('Mu is 2, run 1, num of target 2')
yyaxis right
plot(x,cumsum(foo23e.foo));
ylabel('Total Energy')
ylim([0 200]);
 

a=dir(['C:\Users\admin\Documents\GitHub\GradProject\Results\10_17_2021_13_42_31' '/*.png']);
name='State_mu_0_run_index_0_num_target_0';
name1='Target_mu_0_run_index_0_num_target_0';
name2='Target_mu_0_run_index_0_num_target_1';
resolution=500000;
dist1=foo01d.foo(:,1);
dist2=foo01d.foo(:,2);


v= MovieMakerCall(a,name, name1,name2,energy,entropy,dist1,dist2,resolution);



% saveas(gcf,'Energy.png')
% 
% for k = 1:20 
%    surf(sin(2*pi*k/20)*Z,Z)
%    frame = getframe(gcf);
%    writeVideo(v,frame);
% end
% 
% close(v);

