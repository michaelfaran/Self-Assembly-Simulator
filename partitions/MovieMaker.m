%MoviemKaer
close all
a=dir(['C:\Users\admin\Documents\GitHub\GradProject\Results\10_10_2021_15_21_05' '/*.png']);
out=size(a,1);
out=4;
name='State_mu_0_run_index_0_num_target_0';
name1='Target_mu_0_run_index_0_num_target_0';
name2='Target_mu_0_run_index_0_num_target_1';
resolution=500000;
v = VideoWriter('Try2.avi');
axis tight manual 
set(gca,'nextplot','replacechildren'); 
v.FrameRate = 1;
open(v);
k=1;
%burn the first
imname=horzcat(name,'_turn_number_',num2str((k-1)*resolution),'.png');
img = imread(imname);
imshow(img);

for k=1:1:(out)
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
frame = getframe(gcf);
writeVideo(v,frame);



close(gcf);
end
    
close(v)