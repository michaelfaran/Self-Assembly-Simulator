%MoviemKaer
function v= MovieMakerCall(dir,a,name, name1,name2,energy,entropy,dist1,dist2,resolution)
cd=dir;
S=cd(end-18:end);

yyyy=str2double(S(7:10));
mm=str2double(S(12:13));
dd=str2double(S(1:2));
HH=str2double(S(12:13));
MM=str2double(S(15:16));
SS=str2double(S(18:19));
DateVector = [yyyy,mm,dd,HH,MM,SS];

close all
le=length(energy);
x=1:1:length(energy);
% a=dir(['C:\Users\admin\Documents\GitHub\GradProject\Results\10_10_2021_15_21_05' '/*.png']);
% name='State_mu_0_run_index_0_num_target_0';
% name1='Target_mu_0_run_index_0_num_target_0';
% name2='Target_mu_0_run_index_0_num_target_1';
% resolution=500000;
%out=size(a,1);
% out=4;
out=le/resolution;

v = VideoWriter(horzcat(name,'.avi'));
axis tight manual 
set(gca,'nextplot','replacechildren'); 
v.FrameRate = 1;
open(v);
vfig=gcf;
k=1;
%burn the first
imname=horzcat(name,'_turn_number_',num2str((k-1)*resolution),'.png');
img = imread(imname);
imshow(img);

%pointfirstfigure

%I = imread('cameraman.tif');

scrsz = get(groot, 'ScreenSize'); %Get screen size
f = figure('Position', [scrsz(3)/10, scrsz(4)/5, scrsz(4)/2*2.4, scrsz(4)/2]); %Set figure position by screen size.
%x1=0.4;
name22=regexprep(name,'_',' ');
name33=name22(6:end);
sgtitle({horzcat('Simulation Results from ',datestr(DateVector) ),name33},'FontSize',20) ;
y1=0.075;
size2=0.9;
shift=-0.1;
positionVector1o = [0, shift+y1, size2, size2]; %position vector for largest image.
axes10=axes(f, 'Position', positionVector1o);

y2=0;
x2=0.125;

up=0.896959183673469;
bottom=0.162265306122449;
buff=2*0.09;
halfbuff=0.25*buff;
s=(up-bottom)/4;
s2=(up-bottom-buff)/4;
positionVector5 = [0.8-x2,halfbuff+bottom+0+y2+shift, s2, s2];
positionVector4 = [0.8-x2,halfbuff+ bottom+s+y2+shift, s2, s2];
positionVector3 = [0.8-x2,halfbuff+bottom+2*s+y2+shift, s2, s2]; %position vector for smallest image.
positionVector2 = [0.8-x2,halfbuff+ bottom+3*s+y2+shift,s2, s2]; %position vector for smallest image.


axes1=axes(f, 'Position', positionVector2);
%imshow(I, 'border', 'tight');
plot(x,energy);
ylabel(horzcat('Total Energy', 'k_B','T'));
title('Simulation Results(t)')
axes2=axes(f, 'Position', positionVector3);
%imshow(I, 'border', 'tight');
entropyDev=(entropy(2:end)-entropy(1:(end-1)))./(x(2)-x(1));
entropyDev=[entropyDev;entropyDev(end)];
plot(x,entropyDev);
ylabel('Total Entropy [#] and EPR')
hold on;
plot(x,entropy,'r');


axes3=axes(f, 'Position', positionVector4);
%imshow(I, 'border', 'tight');

plot(x,dist1);
ylabel('Distance from Target 1 [#]')

axes4=axes(f, 'Position', positionVector5);
%imshow(I, 'border', 'tight');
plot(x,dist2);
xlabel('Steps')
ylabel('Distance from Target 2 [#]')
set(gcf,'color','w');

% figure;
% subplot;
% plot(x,cumsum(foo23e.foo));%total energy

frame_h = get(handle(f),'JavaFrame');
set(frame_h,'Maximized',1);

for k=1:1:(out-1)
imname=horzcat(name,'_turn_number_',num2str((k-1)*resolution),'.png');
img = imread(imname);
figure;
imshow(img);
a0=gcf;

imname=horzcat(name1,'_turn_number_',num2str((k-1)*resolution),'.png');
img1 = imread(imname);
figure;
imshow(img);
a1=gcf;


imname=horzcat(name2,'_turn_number_',num2str((k-1)*resolution),'.png');
img2 = imread(imname);
figure;
imshow(img);
a2=gcf;

figure;
newImg = cat(2,img1, img2);
% newnewImg = cat(1,img,newImg);
imshow(newImg);
% savefig(horzcat(imname,'.fig'));
% open(horzcat(imname,'.fig'));

scrsz = get(groot, 'ScreenSize'); %Get screen size
f2 = figure('Position', [scrsz(3)/10, scrsz(4)/5, scrsz(4)/2*2.4, scrsz(4)/2]); %Set figure position by screen size.
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
axes(f2, 'Position', positionVector1);
imshow(img, 'border', 'tight');
axes(f2, 'Position', positionVector2);
imshow(newImg, 'border', 'tight');
frame_h = get(handle(f2),'JavaFrame');
set(frame_h,'Maximized',1);
saveas(gcf,'pivot.png');
A = imread('pivot.png');
image(axes10,A);
set(0, 'CurrentFigure', f);
axis(axes10,'off')




% axes_h = get(f,'CurrentAxes');
% copyobj(axes10,axes_h);
% imshow(f2, 'border', 'tight');
set(gcf,'color','w');

c1=xline(axes1,(k-1)*resolution,'--b');
c2=xline(axes2,(k-1)*resolution,'--b');
c3=xline(axes3,(k-1)*resolution,'--b');
c4=xline(axes4,(k-1)*resolution,'--b');



frame = getframe(f);
writeVideo(v,frame);
%figures to keep
figs2keep =[f vfig ];

% Uncomment the following to 
% include ALL windows, including those with hidden handles (e.g. GUIs)
% all_figs = findall(0, 'type', 'figure');

all_figs = findobj(0, 'type', 'figure');
delete(setdiff(all_figs, figs2keep));
delete(c1);
delete(c2);
delete(c3);
delete(c4);


end
    
close(v)