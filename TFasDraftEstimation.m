
restoredefaultpath
addpath 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder'
Main_dir_hazirim= 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Gather_Tfas_DATA';
cd(Main_dir_hazirim)
% mainFolder = horzcat('C:\Users\admin\Documents\GitHub\GradProject\Results\',mainname,'\2');
% oldpath= addpath(['C:\Users\admin\Documents\GitHub\GradProject\Results\',mainname,'\2' ...
%     '']);
addpath ('C:\Users\admin\Documents\GitHub\GradProject\mi');
addpath('C:\Users\admin\Documents\GitHub\GradProject\github_repo');
addpath('C:\Users\admin\Documents\GitHub\GradProject\rp-master\rp-master');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject');
 addpath ('C:\Users\admin\Documents\GitHub\GradProject\knee_pt');
addpath 'C:\Users\admin\Documents\GitHub\GradProject\Beast\Matlab';
addpath 'C:\Users\admin\Documents\GitHub\GradProject\partitions';
%for drive 1, energy 4
coordinate_number=3;
Mydata=importdata(horzcat('All_data',num2str(coordinate_number),'.mat'));
I=find(Mydata(:,coordinate_number+1)~=0);
mappx=Mydata(I,:);
flag_victoria=1;% this flag determines whether we are seeking weights or not.
mindex=floor(size(mappx,1)/2);% the index for the size of learning
iter_num=10;% the number of cross validation iterations, on size of learning og mindex
tfas_reference=1;% The mu and std of the original histogram is:mu=1*10^7, or 1000 in coarsed-grained method, std=1*10^7,or 1000 in coarsed-grained method
neighbours_vec=[1;5;20;50;200;400;];%The neighbours to check,the basic- neighbours_vec=1
neighbours_vec=[200];%The neighbours to check,the basic- neighbours_vec=1

%don't change it at the moment below
cg_gap=0.2; %this is relevant if we want to optimize the weights

%defining the weights
Weights_mean=zeros(iter_num,coordinate_number,length(neighbours_vec));
Weights_std=zeros(iter_num,coordinate_number,length(neighbours_vec));
Weights_mean3=zeros(iter_num,coordinate_number,length(neighbours_vec));
Weights_std3=zeros(iter_num,coordinate_number,length(neighbours_vec));



if flag_victoria==1
%     victoria=0:cg_gap:1;
%     ccc=zeros(length(victoria)*length(victoria),2);
baseStr = dec2base(1:1:10^(coordinate_number),10);
digitalx=baseStr - '0';
digitalx=ceil(digitalx/(cg_gap/0.1));
digital=cg_gap*digitalx;
well_ind=zeros(size(digital,1),1);
for ii=1:1:size(digital,1)
if sum(digital(ii,:))==1     
well_ind(ii)=ii;
end
end
well=find(well_ind~=0);
W=digital(well,2:end);
W=unique(W,'rows');


    %     if flag_victoria==1 && coordinate_number==3  
%         for jj=1:1:(length(victoria))
%         for yy=1:1:(length(victoria))
%             mappx=[];
%         ccc(length(victoria)*(yy-1)+jj,1:2)=[victoria(yy);victoria(jj)]';
%         end
%         end
%         
%         II=find( (sum(ccc,2)<1));
%         rrr=ccc(II,:);
%         ddd=1-sum(rrr,2);
%         W=[rrr ddd];
%         else 
%         mappx=[];
%         W=W_input;
%     end
elseif flag_victoria==0
    victoria=1;
    W=(1/coordinate_number)*ones(1,coordinate_number);

end
W=[0.2 0.6 0.2];
red=length(mindex:length(mappx));
%mega matrix of tfas
tfas_predict_mat=zeros(iter_num,size(W,1),length(neighbours_vec),red);
tfas_actually_mat=zeros(iter_num,size(W,1),length(neighbours_vec),red);
mean_error_mat=zeros(iter_num,size(W,1),length(neighbours_vec),red);
%in the previous coordiantes
% W_input=[0.0187 0.125 1-0.0187-0.125];
%in pca coordinets, a beginning for 5 parameters
% victoria=1/3; From bubble chart it is 0.1,0.25,0.65


for zz=1:1:iter_num

% for ii=1:1:size(mapp,1)    
% if (mapp(ii,coordinate_number+1)~=0)
% mappx=[mappx;mapp(ii,:)];
% end
% end
    x=mappx;
    random_x = x(randperm(size(x, 1)), :);
    mappx=random_x;
    mip=mappx(mindex:end,:);
    mop=mappx(1:(mindex-1),:);
    
    
%     std_mat=zeros(length(neighbours_vec),length(victoria));
%     mean_mat=zeros(length(neighbours_vec),length(victoria));
%     std_mat2=zeros(length(neighbours_vec),length(victoria));
%     mean_mat2=zeros(length(neighbours_vec),length(victoria));

    d=zeros(size(mip,1),size(mop,1));
        for mm=1:1:size(W,1)
            for nn=1:1:length(neighbours_vec)
                neighbours_num=neighbours_vec(nn);
                    for jj=1:1:size(mop,1)
                        for ii=1:1:size(mip,1)
                            d(ii,jj)=norm(W(mm,:).*(mip(ii,1:coordinate_number)-mop(jj,1:coordinate_number)));
                        end
                    end
                    
                    mop_times=mop(:,coordinate_number+1);
                    TFAS_real=zeros(size(mip,1),1);
                    TFAS_predicted=zeros(size(mip,1),1);

                    for ii=1:1:size(mip,1)
                        TFAS_real(ii)=mip(ii,coordinate_number+1);
                        v=d(ii,:); 
                        [a,I]=sort(v);
                        b=(1./a(1:neighbours_num)).^2;
                        %changed to square metric 13/6
                        miata=I(1:neighbours_num);
                        TFAS_predicted(ii)=sum(b(1:end).*(mop(miata(1:end),coordinate_number+1)'));
                        adsds=TFAS_predicted(ii);
                        TFAS_predicted(ii)=TFAS_predicted(ii)/sum(b);
                    end
%                     got_it=100*abs(TFAS_predicted-TFAS_real)./TFAS_real;
%                     got_it2=100*abs(TFAS_predicted-TFAS_real)./tfas_reference;
%                         
%                     mean_mat(nn,mm)=mean(got_it);
%                     mean_mat2(nn,mm)=mean(got_it2);
                    % median(got_it)
%                     std_mat(nn,mm)=std(got_it);
%                     std_mat2(nn,mm)=std(got_it2);
                    tfas_predict_mat(zz,mm,nn,1:end)=TFAS_predicted;
                    tfas_actually_mat(zz,mm,nn,1:end)=TFAS_real;
                    mean_error_mat(zz,mm,nn,1:end)=abs(TFAS_real-TFAS_predicted);
                end
            end

% min_mean_vec=zeros(length(neighbours_vec),1);
% min_std_vec=zeros(length(neighbours_vec),1);
% min_mean_vec3=zeros(length(neighbours_vec),1);
% min_std_vec3=zeros(length(neighbours_vec),1);
%     for nn=1:1:length(neighbours_vec)
%         [r,c]=find(mean_mat==min(mean_mat(nn,:)),1);
%         min_mean_vec(nn)=unique(min(mean_mat(nn,:)));
%         Weights_mean(zz,:,nn)=W(c,1:coordinate_number);
%         [r2,c2]=find(std_mat==min(std_mat(nn,:)),1);
%         Weights_std(zz,:,nn)=W(c2,1:coordinate_number);
%         min_std_vec(nn)=unique(min(std_mat(nn,:)));
%         
%         [r,c]=find(mean_mat2==min(mean_mat2(nn,:)),1);
%         min_mean_vec3(nn)=unique(min(mean_mat2(nn,:)));
%         Weights_mean3(zz,:,nn)=W(c,1:coordinate_number);
%         [r2,c2]=find(std_mat2==min(std_mat2(nn,:)),1);
%         Weights_std3(zz,:,nn)=W(c2,1:coordinate_number);
%         min_std_vec3(nn)=unique(min(std_mat2(nn,:)));
%     
%     end

end

folderName=horzcat('History Samples ',num2str(length(mop)),' Checking Samples ',num2str(length(mip)),' Dimension ',num2str(coordinate_number),' Run ', strrep(datestr(datetime), ':', '_'));
mkdir(folderName);
cd(folderName)

ruby=zeros(size(W,1),length(neighbours_vec)) ;
    for mm=1:1:size(W,1)
        for nn=1:1:length(neighbours_vec)
            
            Sapphire=zeros(length(iter_num),1);

            for zz=1:1:iter_num
 
                look=abs(tfas_predict_mat(zz,mm,nn,1:end)-tfas_actually_mat(zz,mm,nn,1:end)).^2;
                Sapphire(zz)=mean(look);

            end
           ruby(mm,nn)=sqrt(mean(Sapphire));
     
        end
    end
overall_minimal_mean_error=min(min(ruby));

    for mm=1:1:size(W,1)
        figure;
        fullscreen();     
        nn=1;
              xx=squeeze(tfas_predict_mat(1,1,1,1:end));
            [x,I]=sort(xx);
        bin_width=50;
        hista=linspace(bin_width*floor(min(x/bin_width)),bin_width*ceil(max(x)/bin_width),floor((max(x)-min(x))/bin_width)+2);
            meaning=zeros(iter_num,length(hista)-1);
            stding=zeros(iter_num,length(hista)-1);
            for zz=1:1:iter_num          
            xx=squeeze(tfas_predict_mat(zz,mm,nn,1:end));
            [x,I]=sort(xx);
            yy=squeeze(tfas_actually_mat(zz,mm,nn,1:end)-tfas_predict_mat(zz,mm,nn,1:end));
            yy=squeeze(tfas_actually_mat(zz,mm,nn,1:end));
            y=yy(I);
            subplot(3,1,1)
            scatter(x,y)
%             Y=[Y y];
            % X = [ones(length(x),1) x];
            % X=x;
            hold on;
                b = x\(y);
            yCalc2 = x*b;
            plot(x,yCalc2,'--')
            title('Scattered Data')
            y_new=y;

        hista=linspace(bin_width*floor(min(x/bin_width)),bin_width*ceil(max(x)/bin_width),floor((max(x)-min(x))/bin_width)+2);
        std_hista=zeros(1,length(hista)-1);
        mean_hista=zeros(1,length(hista)-1);
        for ii=1:1:(length(hista)-1)
            I=find (hista(ii)<x & x<(hista(ii+1)));
            if length(I)<10 %do nto consider when there is not enough statistics
            std_hista(ii)=nan;
            mean_hista(ii)=nan;
            else
        std_hista(ii)=std(y_new(I));
        mean_hista(ii)=mean(y_new(I));
            end
        
        end
       x_hista=(hista(2:end)+hista(1:(end-1)))/2;
        I2=find (isnan(mean_hista) & x_hista>1000,1);
        I3=find (isnan(std_hista) &  x_hista>1000,1);
        I4=min(I2,I3);

        subplot(3,1,3)  
        plot(x_hista(1:I4),std_hista(1:I4),'r')
        hold on;
        plot(x_hista(1:I4),mean_hista(1:I4),'b')  
        hold on;
        plot(x_hista(1:I4),x_hista(1:I4))

        meaning(zz,length(hista)-1)=mean_hista;
        stding(zz,length(hista)-1)=std_hista;

        title('Predicted Perfromace')
        legend('STD','Mean','Linear Compare')

       [mmmm,I5]= min(abs(x-x_hista(I4)));
        subplot(3,1,2)
         scatter(x(1:I5),y(1:I5));
            hold on;
%          hold on;
%                 b = x\(y);
%             yCalc2 = x*b;
%             plot(x,yCalc2,'--')
%             title('Scattered Data')
            end
        sgtitle(horzcat('Weights Number ',num2str(mm)))


    end
%     hold on;
%     X = [ones(length(squeeze(tfas_predict_mat(zz,mm,nn,1:end))),1) squeeze(tfas_predict_mat(zz,mm,nn,1:end))];

%transforming back
% y_new=y;
% 
% bin_width=100;
% hista=linspace(bin_width*floor(min(x/bin_width)),bin_width*ceil(max(x)/bin_width),floor((max(x)-min(x))/bin_width)+2);
% std_hista=zeros(1,length(hista)-1);
% mean_hista=zeros(1,length(hista)-1);
% for ii=1:1:(length(hista)-1)
%     I=find (hista(ii)<x & x<(hista(ii+1)));
%     if length(I)<10 %do nto consider when there is not enough statistics
%     std_hista(ii)=nan;
%     mean_hista(ii)=nan;
%     else
% std_hista(ii)=std(y_new(I));
% mean_hista(ii)=mean(y_new(I));
%     end
% 
% end
% figure;
% x_hista=(hista(2:end)+hista(1:(end-1)))/2;
% plot(x_hista,std_hista)
% title('std')
% hold on;
% plot(x_hista,mean_hista)
% title('Mean')
% legend('std','mean')
% Weighted_Center_Mass_std_vec=zeros(coordinate_number,length(neighbours_vec));
% Weighted_Center_Mass_Mean_vec=zeros(coordinate_number,length(neighbours_vec));
% Weighted_Center_Mass_std_vec3=zeros(coordinate_number,length(neighbours_vec));
% Weighted_Center_Mass_Mean_vec3=zeros(coordinate_number,length(neighbours_vec));
%Optimal Weights calc
% for nn=1:1:length(neighbours_vec)
%     s4u=zeros(size(Weights_mean,1),1);
%     s4u2=zeros(size(Weights_std,1),1);
% 
%     for uu=1:1:size(Weights_mean,1)
%         s4u(uu)=length(find(Weights_mean(uu,1,nn)==Weights_mean(:,1,nn) & Weights_mean(uu,2,nn)==Weights_mean(:,2,nn)  & Weights_mean(uu,3,nn)==Weights_mean(:,3,nn)));
%         s4u2(uu)=length(find(Weights_std(uu,1,nn)==Weights_std(:,1,nn) & Weights_std(uu,2,nn)==Weights_std(:,2,nn)  & Weights_std(uu,3,nn)==Weights_std(:,3,nn)));
%     end
% A=[Weights_mean(:,1,nn),Weights_mean(:,2,nn),Weights_mean(:,3,nn),s4u2];
% Weighted_Center_Mass_Mean= [mean(Weights_mean(:,1,nn).*s4u);mean(Weights_mean(:,2,nn).*s4u);mean(Weights_mean(:,3,nn).*s4u)]/sum(mean(Weights_mean(:,1,nn).*s4u)+mean(Weights_mean(:,2,nn).*s4u)+mean(Weights_mean(:,3,nn).*s4u));
% Weighted_Center_Mass_Mean_vec(1:3,nn)=Weighted_Center_Mass_Mean;
% 
% mii=num2str(Weighted_Center_Mass_Mean);
% figure;bubblechart3(Weights_mean(:,1,nn),Weights_mean(:,2,nn),Weights_mean(:,3,nn),s4u);
% xlabel('Mean','FontSize',28);
% ylabel('Variance','FontSize',28);
% zlabel('Trend','FontSize',28);
% title(horzcat('Bubble Chart of Weights, MEAN Optimization, Neighbours Number ',num2str(neighbours_vec(nn)), ' , Mass Center is ',mii(1,:),'',mii(2,:),'',mii(3,:)))
% savefig(gcf,(horzcat('Bubble Chart of Weights, MEAN Optimization, Neighbours Number ',num2str(neighbours_vec(nn)), ' , Mass Center is ',mii(1,:),'',mii(2,:),'',mii(3,:),'.fig')));
% 
% A1=[Weights_std(:,1,nn),Weights_std(:,1,nn),Weights_std(:,1,nn),s4u2];
% Weighted_Center_Mass_std= [mean(Weights_std(:,1,nn).*s4u2);mean(Weights_std(:,2,nn).*s4u2);mean(Weights_std(:,3,nn).*s4u2)]/sum(mean(Weights_std(:,1,nn).*s4u2)+mean(Weights_std(:,2,nn).*s4u2)+mean(Weights_std(:,3,nn).*s4u2));
% Weighted_Center_Mass_std_vec(1:3,nn)=Weighted_Center_Mass_std;
% mii2=num2str(Weighted_Center_Mass_std);
% figure;bubblechart3(Weights_std(:,1,nn),Weights_std(:,2,nn),Weights_std(:,3,nn),s4u2);
% xlabel('Mean','FontSize',28);
% ylabel('Variance','FontSize',28);
% zlabel('Trend','FontSize',28);
% title(horzcat('Bubble Chart of Weights, STD Optimization, Neighbours Number ',num2str(neighbours_vec(nn)), ' , Mass Center is ',mii2(1,:),'',mii2(2,:),'',mii2(3,:)))
% savefig(gcf,(horzcat('Bubble Chart of Weights, STD Optimization, Neighbours Number ',num2str(neighbours_vec(nn)), ' , Mass Center is ',mii2(1,:),'',mii2(2,:),'',mii2(3,:),'.fig')));
% 
% end
% 
% %Optimal Weights calc,bulky to tfas
% for nn=1:1:length(neighbours_vec)
% s4u=zeros(size(Weights_mean3,1),1);
% s4u2=zeros(size(Weights_std3,1),1);
% 
% for uu=1:1:size(Weights_mean3,1)
% s4u(uu)=length(find(Weights_mean3(uu,1,nn)==Weights_mean3(:,1,nn) & Weights_mean3(uu,2,nn)==Weights_mean3(:,2,nn)  & Weights_mean3(uu,3,nn)==Weights_mean3(:,3,nn)));
% s4u2(uu)=length(find(Weights_std3(uu,1,nn)==Weights_std3(:,1,nn) & Weights_std3(uu,2,nn)==Weights_std3(:,2,nn)  & Weights_std3(uu,3,nn)==Weights_std3(:,3,nn)));
% end
% A=[Weights_mean3(:,1,nn),Weights_mean3(:,2,nn),Weights_mean3(:,3,nn),s4u];
% Weighted_Center_Mass_Mean= [mean(Weights_mean3(:,1,nn).*s4u);mean(Weights_mean3(:,2,nn).*s4u);mean(Weights_mean3(:,3,nn).*s4u)]/sum(mean(Weights_mean3(:,1,nn).*s4u)+mean(Weights_mean3(:,2,nn).*s4u)+mean(Weights_mean3(:,3,nn).*s4u));
% Weighted_Center_Mass_Mean_vec3(1:3,nn)=Weighted_Center_Mass_Mean;
% 
% A1=[Weights_std3(:,1,nn),Weights_std3(:,1,nn),Weights_std3(:,1,nn),s4u2];
% Weighted_Center_Mass_std= [mean(Weights_std3(:,1,nn).*s4u2);mean(Weights_std3(:,2,nn).*s4u2);mean(Weights_std3(:,3,nn).*s4u2)]/sum(mean(Weights_std3(:,1,nn).*s4u2)+mean(Weights_std3(:,2,nn).*s4u2)+mean(Weights_std3(:,3,nn).*s4u2));
% Weighted_Center_Mass_std_vec3(1:3,nn)=Weighted_Center_Mass_std;
% 
% 
% end



% final_weights_std=mean(Weighted_Center_Mass_std_vec,2);
% final_weights_mean=mean(Weighted_Center_Mass_Mean_vec,2);
% final_weights_std3=mean(Weighted_Center_Mass_std_vec3,2);
% final_weights_mean3=mean(Weighted_Center_Mass_Mean_vec3,2);
% save('final_weights_std.mat','final_weights_std')
% save('final_weights_mean.mat','final_weights_mean')
% save('std_mat.mat','std_mat')
% save('mean_mat.mat','mean_mat')
% save('min_std_vec.mat','min_std_vec')
% save('min_mean_vec.mat','min_mean_vec')
% save('final_weights_std_tfas_meidan_compare.mat','final_weights_std3')
% save('final_weights_mean_tfas_meidan_compare.mat','final_weights_mean3')
% save('std_mat_tfas_meidan_compare.mat','std_mat2')
% save('mean_mat_tfas_meidan_compare.mat','mean_mat2')
% min(min(mean_mat))
% min(min(std_mat))
% [r,c]=find(mean_mat==min(min(mean_mat)));
% std_mat(r,c)
% Weights_mean=W(c,1:3)
% [r2,c2]=find(std_mat==min(min(std_mat)));
% Weights_std=W(c2,1:3)