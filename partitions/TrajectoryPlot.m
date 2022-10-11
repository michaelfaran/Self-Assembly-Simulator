tableData = readtable('LogPosition.txt');
t = tableData.temps_s_;
x = tableData.x_m_;
y = tableData.y_m_;
z = tableData.z_m_;
% Subplot of the deplacement 
% figure;
% subplot(3,1,1); plot(t,x); title ('X to time'); ylabel('X');
% subplot(3,1,2);plot(t,y); title ('Y to time'); ylabel('Y');
% subplot(3,1,3);plot(t,z); title ('Z to time'); ylabel('Z');
% xlabel('Time');
% 3 plots in 1 figure 
figure;
plot3(x,y,z,'-b');
hold on
plot3(x,y,z,'co','LineWidth',0.5);
% plots start point:
plot3(x(1),y(1),z(1),'*g','LineWidth',5);
%plots end point:
plot3(x(end),y(end),z(end),'*r','LineWidth',5);
% add legend:
legend({'Trajectory','Points','Start Point','Finish Point'});
% some axis properties:
box on
grid on
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Object Position');
% Best way is X-Z view.
rotate3d on;
% Best way is X-Z view.
%%%%%%%%%%%%%% This Section written for demo %%%%%%%%%%%%
% %% comet3 Function Demo (Working very well)
% figure;
% comet3(x,y,z);
%% mArrow3 Function Demo (May not be working very well) looks bad.
% Array = [x,y,z];
% for i = 1:size(Array,1)-1
% mArrow3(Array(i,:),Array(i+1,:),'stemWidth',0.0002,'facealpha',0.5,'tipWidth',0.005);
% end
