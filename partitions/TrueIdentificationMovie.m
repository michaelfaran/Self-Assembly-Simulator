%I = imread('cameraman.tif');

scrsz = get(groot, 'ScreenSize'); %Get screen size
f = figure('Position', [scrsz(3)/10, scrsz(4)/5, scrsz(4)/2*2.4, scrsz(4)/2]); %Set figure position by screen size.
positionVector1 = [0, 0.95-0.9, 0.9, 0.9]; %position vector for largest image.
positionVector2 = [0.23+0.25, 0.95-0.7, 0.6, 0.7];
ydrift=0;
xdrift1=+0.015;
x1=0.7;
y1=0.7;
x=0.3;
y=0.3;
positionVector1 = [0.5-0.5*x1+xdrift1, 0+ydrift+y, x1,y1];
positionVector2 = [0.5-0.5*x, 0+1*y/6+ydrift, x, y];
% positionVector3 = [0.555, 0.95-0.4, 0.4, 0.4];
% positionVector4 = [0.775, 0.95-0.267, 0.267, 0.267]; %position vector for smallest image.
axes(f, 'Position', positionVector1);
imshow(img, 'border', 'tight');
axes(f, 'Position', positionVector2);
imshow(newImg, 'border', 'tight');
set(gcf,'color','w');

% axes(f, 'Position', positionVector3);
% imshow(I, 'border', 'tight');
% axes(f, 'Position', positionVector4);
% imshow(I, 'border', 'tight');

