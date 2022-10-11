function TrajectoryPlotVecs(X,Y,Z,C,bottom,top)
% X = [1 2 3 4];
% Y = [4 5 6 7];
% Z = [8 9 10 11];
% C=[1 2 1 4];
sz=80;
scatter3(X,Y,Z,sz,C,'filled');
hold on;
colormap jet;
colorbar;
caxis([bottom top]);
% D=([X(2:(end)); Y(2:(end)); Z(2:(end))]-[X(1:(end-1)) ;Y(1:(end-1)) ;Z(1:(end-1))])/2;
% TriColor=rand(1,3);
% quiver3(X(1:(end-1)),Y(1:(end-1)),Z(1:(end-1)),D(1,1:end),D(2,1:end),D(3,1:end),0,'Color',TriColor,'MaxHeadSize',0.05);
% hold on;
% line(X,Y,Z,'Color',TriColor);

%  hold on;
% line(X,Y,Z);
% hold on;
% plots start point:
% line(X(1),Y(1),Z(1),sz,C(1),'filled','*');%plots end point:
scatter3(X(1),Y(1),Z(1),3*sz,C(1),'filled','^');
hold on;
scatter3(X(end),Y(end),Z(end),3*sz,C(end),'filled','d');
% add legend:
legend({'Points','Arrows','Trajectory','Start Point','Finish Point'});
% some axis properties:
box on
grid on
% some axis properties:
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% title('Object Position');
% Best way is X-Z view.
% rotate3d on;
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
