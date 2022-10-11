cd('C:\Users\admin\Documents\GitHub\GradProject\Results\03_08_2022_18_33_12-free_market\2\1');
 foo22e=load('energy_vec_mu_1_run_num_1_num_target_1_total_num_target_2.mat');
x=1:1:(length(foo22e.foo));
E=cumsum(sum(foo22e.foo,2));
figure;
plot(x,E)
ylabel('Total Energy');
xlabel('Steps');
title('Mu is 2, run 1, num of target 2')

delay=10;
E2=E(delay:end);
E1=E(1:(end-delay+1));
figure;
scatter(E1,E2);
ylabel(horzcat('E(t-',num2str(delay),')'));
xlabel('E');
title(horzcat('Delay of',num2str(delay)))

