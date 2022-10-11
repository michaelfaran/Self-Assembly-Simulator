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
prefix='Results11_08_2021_18_28_06';
%prefix='';

foo01=load(horzcat(prefix,'entropy_vec_mu_0_run_num_1_num_target_1_total_num_target_2.mat'));
foo02=load(horzcat(prefix,'entropy_vec_mu_0_run_num_2_num_target_1_total_num_target_2.mat'));
foo03=load(horzcat(prefix,'entropy_vec_mu_0_run_num_3_num_target_1_total_num_target_2.mat'));
foo11=load(horzcat(prefix,'entropy_vec_mu_1_run_num_1_num_target_1_total_num_target_2.mat'));
foo12=load(horzcat(prefix,'entropy_vec_mu_1_run_num_2_num_target_1_total_num_target_2.mat'));
foo13=load(horzcat(prefix,'entropy_vec_mu_1_run_num_3_num_target_1_total_num_target_2.mat'));
foo21=load(horzcat(prefix,'entropy_vec_mu_2_run_num_1_num_target_1_total_num_target_2.mat'));
foo22=load(horzcat(prefix,'entropy_vec_mu_2_run_num_2_num_target_1_total_num_target_2.mat'));
foo23=load(horzcat(prefix,'entropy_vec_mu_2_run_num_3_num_target_1_total_num_target_2.mat'));
foo01d=load(horzcat(prefix,'distance_vec_mu_0_run_num_1_num_target_1_total_num_target_2.mat'));
foo02d=load(horzcat(prefix,'distance_vec_mu_0_run_num_2_num_target_1_total_num_target_2.mat'));
foo03d=load(horzcat(prefix,'distance_vec_mu_0_run_num_3_num_target_1_total_num_target_2.mat'));
foo11d=load(horzcat(prefix,'distance_vec_mu_1_run_num_1_num_target_1_total_num_target_2.mat'));
foo12d=load(horzcat(prefix,'distance_vec_mu_1_run_num_2_num_target_1_total_num_target_2.mat'));
foo13d=load(horzcat(prefix,'distance_vec_mu_1_run_num_3_num_target_1_total_num_target_2.mat'));
foo21d=load(horzcat(prefix,'distance_vec_mu_2_run_num_1_num_target_1_total_num_target_2.mat'));
foo22d=load(horzcat(prefix,'distance_vec_mu_2_run_num_2_num_target_1_total_num_target_2.mat'));
foo23d=load(horzcat(prefix,'distance_vec_mu_2_run_num_3_num_target_1_total_num_target_2.mat'));
foo01e=load(horzcat(prefix,'energy_vec_mu_0_run_num_1_num_target_1_total_num_target_2.mat'));
foo02e=load(horzcat(prefix,'energy_vec_mu_0_run_num_2_num_target_1_total_num_target_2.mat'));
foo03e=load(horzcat(prefix,'energy_vec_mu_0_run_num_3_num_target_1_total_num_target_2.mat'));
foo11e=load(horzcat(prefix,'energy_vec_mu_1_run_num_1_num_target_1_total_num_target_2.mat'));
foo12e=load(horzcat(prefix,'energy_vec_mu_1_run_num_2_num_target_1_total_num_target_2.mat'));
foo13e=load(horzcat(prefix,'energy_vec_mu_1_run_num_3_num_target_1_total_num_target_2.mat'));
foo21e=load(horzcat(prefix,'energy_vec_mu_2_run_num_1_num_target_1_total_num_target_2.mat'));
foo22e=load(horzcat(prefix,'energy_vec_mu_2_run_num_2_num_target_1_total_num_target_2.mat'));
foo23e=load(horzcat(prefix,'energy_vec_mu_2_run_num_3_num_target_1_total_num_target_2.mat'));

% a01=cumsum(foo01e.foo (1:end,1));
% a02=cumsum(foo01e.foo (1:end,2));
% a01t=a01+a02;
% a03=cumsum(foo02e.foo (1:end,1));
% a04=cumsum(foo02e.foo (1:end,2));
% a02t=a03+a04;
% a05=cumsum(foo03e.foo (1:end,1));
% a06=cumsum(foo03e.foo (1:end,2));
% a03t=a05+a06;
% figure;plot(a01t); hold on; plot(a02t); plot(a03t);
% 
% a01=cumsum(foo11e.foo (1:end,1));
% a02=cumsum(foo11e.foo (1:end,2));
% a01t=a01+a02;
% a03=cumsum(foo12e.foo (1:end,1));
% a04=cumsum(foo12e.foo (1:end,2));
% a02t=a03+a04;
% a05=cumsum(foo13e.foo (1:end,1));
% a06=cumsum(foo13e.foo (1:end,2));
% a03t=a05+a06;
% figure;plot(a01t); hold on; plot(a02t); plot(a03t);
% 
% 
% 
% a01=cumsum(foo01.foo (1:end,1));
% a02=cumsum(foo01.foo (1:end,2));
% a03=cumsum(foo02.foo (1:end,1));
% a04=cumsum(foo02.foo (1:end,2));
% a05=cumsum(foo03.foo (1:end,1));
% a06=cumsum(foo03.foo (1:end,2));
% a01t=a01+a02;
% a02t=a03+a04;
% a03t=a05+a06;
% figure;plot(a01t); hold on; plot(a02t); plot(a03t);
% 
% 
% 
% a01=cumsum(foo01.foo (1:end,1));
% a02=cumsum(foo01.foo (1:end,2));
% a03=cumsum(foo02.foo (1:end,1));
% a04=cumsum(foo02.foo (1:end,2));
% a05=cumsum(foo03.foo (1:end,1));
% a06=cumsum(foo03.foo (1:end,2));
% a01t=a01+a02;
% a02t=a03+a04;
% a03t=a05+a06;
% figure;plot(a01t); hold on; plot(a02t); plot(a03t);
% 
% 
% a01=cumsum(foo11.foo (1:end,1));
% a02=cumsum(foo11.foo (1:end,2));
% a03=cumsum(foo12.foo (1:end,1));
% a04=cumsum(foo12.foo (1:end,2));
% a05=cumsum(foo13.foo (1:end,1));
% a06=cumsum(foo13.foo (1:end,2));
% a01t=a01+a02;
% a02t=a03+a04;
% a03t=a05+a06;
% figure;plot(a01t); hold on; plot(a02t); plot(a03t);


x=1:1:(length(foo01.foo));
%plot everything
if ~isfile('Entropy.png')
     % File exists.
figure
subplot(3,3,1);
 yyaxis left
plot(x,sum(cumsum(foo01.foo),2));
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
plot(x,sum(cumsum(foo02.foo),2));
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
plot(x,sum(cumsum(foo03.foo),2));
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
plot(x,sum(cumsum(foo11.foo),2));
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
plot(x,sum(cumsum(foo12.foo),2));
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
plot(x,sum(cumsum(foo13.foo),2));
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
plot(x,sum(cumsum(foo21.foo),2));
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
plot(x,sum(cumsum(foo22.foo),2));
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
plot(x,sum(cumsum(foo23.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 2, run 3, num of target 2')
yyaxis right
plot(x,(foo23d.foo(:,1)));
hold on
plot(x,(foo23d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
%figure('units','normalized','outerposition',[0 0 1 1])

set(gcf,'units','normalized','outerposition',[0 0 1 1]);
saveas(gcf,'Entropy.png')
 %distances
close(gcf);
end

%plot the entropy and its derivative in time
Wind=1000000;
if ~isfile('EntropyEPRpertt.png')
     % File exists.
figure
subplot(3,3,1);
 yyaxis left
plot(x,sum(cumsum(foo01.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 0, run 1, num of target 2')
yyaxis right
pop=sum(cumsum(foo01.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')


subplot(3,3,2);
yyaxis left
plot(x,sum(cumsum(foo02.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 0, run 2, num of target 2')
yyaxis right
pop=sum(cumsum(foo02.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')



subplot(3,3,3);
yyaxis left
plot(x,sum(cumsum(foo03.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 0, run 3, num of target 2')
yyaxis right
pop=sum(cumsum(foo03.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,4);
yyaxis left
plot(x,sum(cumsum(foo11.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 0, run 3, num of target 2')
yyaxis right
pop=sum(cumsum(foo11.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,5);
yyaxis left
plot(x,sum(cumsum(foo12.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 1, run 2, num of target 2')
yyaxis right
pop=sum(cumsum(foo12.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,6);
yyaxis left
plot(x,sum(cumsum(foo13.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 1, run 2, num of target 2')
yyaxis right
pop=sum(cumsum(foo13.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,7);
yyaxis left
plot(x,sum(cumsum(foo21.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 2, run 1, num of target 2')
yyaxis right
pop=sum(cumsum(foo21.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,8);
yyaxis left
plot(x,sum(cumsum(foo22.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 2, run 2, num of target 2')
yyaxis right
pop=sum(cumsum(foo22.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,9);
yyaxis left
plot(x,sum(cumsum(foo23.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title('Mu is 2, run 3, num of target 2')
yyaxis right
pop=sum(cumsum(foo23.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')


set(gcf,'units','normalized','outerposition',[0 0 1 1]);
saveas(gcf,'EntropyEPRpert.png')
 %distances
close(gcf);
end

%plot the total energy over time

if ~isfile('Energy.png')
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(3,3,1);
yyaxis left
plot(x,sum(cumsum(foo01e.foo,1),2));
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
plot(x,sum(cumsum(foo02e.foo,1),2));
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
plot(x,sum(cumsum(foo03e.foo,1),2));
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
plot(x,sum(cumsum(foo11e.foo,1),2));
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
plot(x,sum(cumsum(foo12e.foo,1),2));
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
plot(x,sum(cumsum(foo13e.foo,1),2));
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
plot(x,sum(cumsum(foo21e.foo,1),2));
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
plot(x,sum(cumsum(foo22e.foo,1),2));
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
plot(x,sum(cumsum(foo23e.foo,1),2));
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 2, run 2, num of target 2')
yyaxis right
plot(x,(foo23d.foo(:,1)));
hold on
plot(x,(foo23d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
 
% subplot(3,3,9);
% % yyaxis left
% plot(x,(foo23d.foo(:,1)));
% hold on
% plot(x,(foo23d.foo(:,2)),'k');
% ylabel('Distance from Targets, Black is 1, Orange is 2')
% xlabel('Steps')
% title('Mu is 2, run 1, num of target 2')
% yyaxis right
% plot(x,cumsum(foo23e.foo));
% ylabel('Total Energy')
% ylim([0 200]);
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
saveas(gcf,'Energy.png')
close(gcf);
end




%plot the entropy and its derivative in time
Wind=1000000;
if ~isfile('dEPRpert.png')
     % File exists.
figure
subplot(3,3,1);
 yyaxis left
plot(x,(foo01d.foo(:,1)));
hold on
plot(x,(foo01d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
xlabel('Steps')
title('Mu is 0, run 1, num of target 2')
yyaxis right
pop=sum(cumsum(foo01.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')


subplot(3,3,2);
 yyaxis left
plot(x,(foo02d.foo(:,1)));
hold on
plot(x,(foo02d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
xlabel('Steps')
title('Mu is 0, run 2, num of target 2')
yyaxis right
pop=sum(cumsum(foo02.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')



subplot(3,3,3);
 yyaxis left
plot(x,(foo03d.foo(:,1)));
hold on
plot(x,(foo03d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
xlabel('Steps')
title('Mu is 0, run 3, num of target 2')
yyaxis right
pop=sum(cumsum(foo03.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,4);
yyaxis left
 yyaxis left
plot(x,(foo11d.foo(:,1)));
hold on
plot(x,(foo11d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
xlabel('Steps')
title('Mu is 0, run 3, num of target 2')
yyaxis right
pop=sum(cumsum(foo11.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,5);
 yyaxis left
plot(x,(foo12d.foo(:,1)));
hold on
plot(x,(foo12d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
xlabel('Steps')
title('Mu is 1, run 2, num of target 2')
yyaxis right
pop=sum(cumsum(foo12.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,6);
 yyaxis left
plot(x,(foo13d.foo(:,1)));
hold on
plot(x,(foo13d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
xlabel('Steps')
title('Mu is 1, run 2, num of target 2')
yyaxis right
pop=sum(cumsum(foo13.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,7);
 yyaxis left
plot(x,(foo21d.foo(:,1)));
hold on
plot(x,(foo21d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
xlabel('Steps')
title('Mu is 2, run 1, num of target 2')
yyaxis right
pop=sum(cumsum(foo21.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,8);
 yyaxis left
plot(x,(foo22d.foo(:,1)));
hold on
plot(x,(foo22d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
xlabel('Steps');
title('Mu is 2, run 2, num of target 2')
yyaxis right
pop=sum(cumsum(foo22.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')

subplot(3,3,9);
 yyaxis left
plot(x,(foo23d.foo(:,1)));
hold on
plot(x,(foo23d.foo(:,2)),'k');
ylabel('Distance from Targets, Black is 1, Orange is 2')
ylim([0 200]);
xlabel('Steps')
title('Mu is 2, run 3, num of target 2')
yyaxis right
pop=sum(cumsum(foo23.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind);
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind);
plot(x,popitup2);
ylabel('EPR Derivative')


set(gcf,'units','normalized','outerposition',[0 0 1 1]);
saveas(gcf,'dEPRpert.png')
 %distances
close(gcf);
end







for jj=1:1:3
for ii=1:1:3 
a=1;
jjs=num2str(jj);
jjs2=num2str(jj-1);
iis=num2str(ii-1);
foo=horzcat('foo',iis,jjs);
a=eval(horzcat(foo,'.foo'));
b=eval(horzcat(foo,'e.foo'));
c=eval(horzcat(foo,'d.foo(:,1)'));
d=eval(horzcat(foo,'d.foo(:,2)'));
name=horzcat(prefix,'State_mu_',iis,'_run_index_',jjs2,'_num_target_0');
name1=horzcat(prefix,'Target_mu_',iis,'_run_index_',jjs2,'_num_target_0');
name2=horzcat(prefix,'Target_mu_',iis,'_run_index_',jjs2,'_num_target_1');
resolution=500000;
dist1=c;
dist2=d;
entropy=sum([cumsum(a(2:end,:)); 0 0],2);
%saveas(gcf,'Entropy.png')
energy=sum([cumsum(b(2:end,:)); 0 0],2);

%saveas(gcf,'Energy.png')
dir2=cd;
v= MovieMakerCall(dir2,a,name, name1,name2,energy,entropy,dist1,dist2,resolution);
close(v);
close all;
end
end



% for k = 1:20 
%    surf(sin(2*pi*k/20)*Z,Z)
%    frame = getframe(gcf);
%    writeVideo(v,frame);
% end



