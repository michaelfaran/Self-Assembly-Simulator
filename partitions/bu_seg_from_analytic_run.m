%% Run this program to perform bottom-up segmentation based on analytichist
%% sensitivites of a first order transfer function

clc
clear all
close all

%% Setting global variables
global u y y_mod K T InitialState
global Ts
warning off
%% SIMULATION FOR GENERATING DATA FOR TIME-SERIES SEGMENTATION
%% Constants for TF simulation
Ts=.1;                  % sample time
K=1;                    % gain of TF
T=10;                   % time constant of TF
init_cond=1.5;          % initial condition for TF
help_vec=[1 1];         % determine which parameters should be included to the segmentation

%% Perform simulation - calculation of outputs and analytic sensitivities
sim('TF_SISO_orig_test') % simulation
y_orig=y_orig.signals.values;               % save generated outputs
u_orig=[u_orig.time u_orig.signals.values]; % save the model input
y_der_orig=y_der;                           % save the sensitivity output

y=y_orig;
u=u_orig;
u_original=u_orig;
t=u_orig(:,1);

%% BOTTOM-UP SEGMENTATION OF GENERATED DATA
%% Creating partial derivatives
t_step=250;
blocks.partials_norm=y_der_orig-repmat(mean(y_der_orig,1),size(y_der_orig,1),1); % calculation of normalized partial derivatives
blocks.partials_norm=blocks.partials_norm./repmat(std(blocks.partials_norm,1),size(blocks.partials_norm,1),1);
blocks.partials_norm=blocks.partials_norm(t_step:end,:);


%% bottom-up segmentation based on the partial derivatives
num_segments=10; % number of desired segment 
minres=2000; % numer of samples contained in minimal resolution
[segment,segment_all] = buseg(blocks.partials_norm,num_segments,minres,help_vec) % performing bottom-up segmentation

%% Visualize results
for i=length(segment_all)-1:-1:1
    cost_bu(i)=segment_all(i).mc;
end

cost_bu=[zeros(1,floor(t_step/minres)) cost_bu];
figure(1)
plot(cost_bu)
xlabel('Samples')
ylabel('Krzanowski measure')
axis([1 length(cost_bu) 0.9*min(cost_bu) 1.1*max(cost_bu)])


figure(4)

subplot(3,1,1)
plot(0:Ts:(size(y_orig,1)-1)*Ts,y_orig(:,1),'b-')
title('Fisher matrix based time-series segmentation')
ylabel('Output')
xlabel('Time (s)')
axis([1 length(y_orig)*Ts 0.9*min(y_orig(:,1)) 1.1*max(y_orig(:,1))])
for i=1:length(segment)
    line([(segment(i).rx+t_step)*Ts (segment(i).rx+t_step)*Ts], [0.9*min(min(y_orig)) 1.1*max(max(y_orig))]);
end


u_orig=u_original;
subplot(3,1,2)
plot(0:Ts:(length(u_orig(:,2))-1)*Ts,u_orig(:,2),'b-')
ylabel('Input')
xlabel('Time (s)')
axis([1 length(y_orig)*Ts 0.9*min(u_orig(:,2)) 1.1*max(u_orig(:,2))])
for i=1:length(segment)
    line([(segment(i).rx+t_step)*Ts (segment(i).rx+t_step)*Ts], [0.9*min(min(u_orig(:,2))) 1.1*max(max(u_orig(:,2)))]);
end


subplot(3,1,3)
xlabel('Time (s)')
ylabel('E criteria of the segments')
crit_store=[];
for i=1:length(segment)
    temp_crit=blocks.partials_norm(segment(i).lx:segment(i).rx,:);
    F_temp=cov(temp_crit);
    crit=max(eig(F_temp))/min(eig(F_temp));
    line([(segment(i).lx+t_step)*Ts (segment(i).rx+t_step)*Ts], [crit crit]);
    crit_store=[crit_store crit];
end
axis([1 length(y_orig)*Ts 0.9*min(crit_store) 1.1*max(crit_store)])
