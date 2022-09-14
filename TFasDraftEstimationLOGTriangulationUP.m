
restoredefaultpath
addpath 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder'
Main_dir_hazirim= 'C:\Users\admin\Documents\Run_Matlab_Fast_Folder\Tfas_log_triag\Drives';
cd(Main_dir_hazirim)

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
mappx=[ mappx(:,1:3) log(mappx(:,4))];% the log thing
mindex=floor(size(mappx,1)/2);% the index for the size of learning
iter_num=10;% the number of cross validation iterations, on size of learning og mindex
tfas_reference=1;% The mu and std of the original histogram is:mu=1*10^7, or 1000 in coarsed-grained method, std=1*10^7,or 1000 in coarsed-grained method

red=length(mindex:length(mappx));
%mega matrix of tfas
tfas_predict_mat=zeros(iter_num,red);
tfas_actually_mat=zeros(iter_num,red);
mean_error_mat=zeros(iter_num,red);

    %5D
    mini1=(min(mappx(:,1)));
    maxi1=(max(mappx(:,1)));
    mini2=(min(mappx(:,2)));
    maxi2=(max(mappx(:,2)));   
    mini3=(min(mappx(:,3)));
    maxi3=(max(mappx(:,3))); 
    if coordinate_number==5
    mini4=(min(mappx(:,4)));
    maxi4=(max(mappx(:,4)));   
    mini5=(min(mappx(:,5)));
    maxi5=(max(mappx(:,5))); 
    end
    d1=linspace(floor(mini1),ceil(maxi1),150);
    d2=linspace(floor(mini2),ceil(maxi2),150);
    d3=linspace(floor(mini3),ceil(maxi3),150);
      if coordinate_number==5
    d4=linspace(floor(mini4),ceil(maxi4),10);
    d5=linspace(floor(mini5),ceil(maxi5),10);
    [x0,y0,z0,w0,v0] = ndgrid(d1,d2,d3,d4,d5);

    XI = [x0(:) y0(:) z0(:) w0(:) v0(:)];
      else 

    [x0,y0,z0] = ndgrid(d1,d2,d3);
        XI = [x0(:) y0(:) z0(:) ];  
      end  




for zz=1:1:iter_num

    x=mappx;
    random_x = x(randperm(size(x, 1)), :);
    mappx=random_x;
    mip=mappx(mindex:end,:);
    mop=mappx(1:(mindex-1),:);

%     %2D option
% coordinate_number=2;
%     mini1=(min(mop(:,1)));
%     maxi1=(max(mop(:,1)));
%     mini2=(min(mop(:,2)));
%     maxi2=(max(mop(:,2)));   
% 
%     d1=linspace(floor(mini1),ceil(maxi1),33);
%     d2=linspace(floor(mini2),ceil(maxi2),33);
%     [x0,y0] = ndgrid(d1,d2);
%     X=[mop(:,1) mop(:,2)];
%     Y=mop(:,4);
%     XI = [x0(:) y0(:)];
%     YI = griddatan(X,Y,XI);
%     YI = reshape(YI, size(x0));
%     Ix= discretize(mip(:,1),d1);  
%     Iy= discretize(mip(:,2),d2);  
%     meanx=mean(Ix(~isnan(Ix)));
%     Ix(isnan(Ix))=round(meanx);
%     meany=mean(Iy(~isnan(Iy)));
%     Iy(isnan(Iy))=round(meany);

%     %3D
%     mini1=(min(mop(:,1)));
%     maxi1=(max(mop(:,1)));
%     mini2=(min(mop(:,2)));
%     maxi2=(max(mop(:,2)));   
%     mini3=(min(mop(:,3)));
%     maxi3=(max(mop(:,3))); 
% 
%     d1=linspace(floor(mini1),ceil(maxi1),33);
%     d2=linspace(floor(mini2),ceil(maxi2),33);
%     d3=linspace(floor(mini3),ceil(maxi3),33);
%     [x0,y0,z0] = ndgrid(d1,d2,d3);
%     X=mop(:,1:3);
%     Y=mop(:,4);
%     XI = [x0(:) y0(:) z0(:)];
%     YI = griddatan(X,Y,XI);
%     YI = reshape(YI, size(x0));
%     Ix= discretize(mip(:,1),d1);  
%     Iy= discretize(mip(:,2),d2);  
%     Iz= discretize(mip(:,3),d3);  
%     meanx=mean(Ix(~isnan(Ix)));
%     Ix(isnan(Ix))=round(meanx);
%     meany=mean(Iy(~isnan(Iy)));
%     Iy(isnan(Iy))=round(meany);
%     meanz=mean(Iz(~isnan(Iz)));
%     Iz(isnan(Iz))=round(meanz);


        if coordinate_number==5
        X=mop(:,1:5);
    Y=mop(:,6);
        else
    X=mop(:,1:3);
    Y=mop(:,4);
        end
      

    YI = griddatan(X,Y,XI);
    YI = reshape(YI, size(x0));
    Ix= discretize(mip(:,1),d1);  
    Iy= discretize(mip(:,2),d2);  
    Iz= discretize(mip(:,3),d3); 
          if coordinate_number==5
            Iw= discretize(mip(:,4),d4);  
            Iv= discretize(mip(:,5),d5);  
          end
    meanx=mean(Ix(~isnan(Ix)));
    Ix(isnan(Ix))=round(meanx);
    meany=mean(Iy(~isnan(Iy)));
    Iy(isnan(Iy))=round(meany);
    meanz=mean(Iz(~isnan(Iz)));
    Iz(isnan(Iz))=round(meanz);
              if coordinate_number==5

    meanw=mean(Iw(~isnan(Iw)));
    Iw(isnan(Iw))=round(meanw);
    meanv=mean(Iv(~isnan(Iv)));
    Iv(isnan(Iv))=round(meanv);
              end
                    TFAS_real=zeros(size(mip,1),1);
                    TFAS_predicted=zeros(size(mip,1),1);
    
                    for ii=1:1:size(mip,1)

                        if coordinate_number==3
                        TFAS_real(ii)=mip(ii,coordinate_number+1);
                        TFAS_predicted(ii)=YI(Ix(ii),Iy(ii),Iz(ii));
                        elseif coordinate_number==2
                        TFAS_real(ii)=mip(ii,coordinate_number+2);
                        TFAS_predicted(ii)=YI(Ix(ii),Iy(ii));
                        elseif coordinate_number==5
                        TFAS_real(ii)=mip(ii,coordinate_number+1);
                        TFAS_predicted(ii)=YI(Ix(ii),Iy(ii),Iz(ii),Iw(ii),Iv(ii));
                        end
                        if isnan(TFAS_predicted(ii))
                             TFAS_predicted(ii)=median(Y);
                        end
                    end


                    tfas_predict_mat(zz,1:end)=TFAS_predicted;
                    tfas_actually_mat(zz,1:end)=TFAS_real;
                    mean_error_mat(zz,1:end)=abs(TFAS_real-TFAS_predicted);

end
 tfas_predict_mat=exp( tfas_predict_mat);
 tfas_actually_mat= exp(tfas_actually_mat);
folderName=horzcat('History Samples ',num2str(length(mop)),' Checking Samples ',num2str(length(mip)),' Dimension ',num2str(coordinate_number),' Run ', strrep(datestr(datetime), ':', '_'));
mkdir(folderName);
cd(folderName)



            
            Sapphire=zeros(length(iter_num),1);

            for zz=1:1:iter_num
 
                look=abs(tfas_predict_mat(zz,1:end)-tfas_actually_mat(zz,1:end)).^2;
                Sapphire(zz)=mean(look);

            end
           ruby=sqrt(mean(Sapphire));
     
   
overall_minimal_mean_error=ruby;

        figure;
        fullscreen();     

              xx=squeeze(tfas_predict_mat(1,1:end));
            [x,I]=sort(xx);
        bin_width=50;
        hista=linspace(bin_width*floor(min(x/bin_width)),bin_width*ceil(max(x)/bin_width),floor((max(x)-min(x))/bin_width)+2);
            meaning=zeros(iter_num,length(hista)-1);
            stding=zeros(iter_num,length(hista)-1);

            for zz=1:1:iter_num          
            xx=squeeze(tfas_predict_mat(zz,1:end));
            [x,I]=sort(xx);
%             yy=squeeze(tfas_actually_mat(zz,1:end)-tfas_predict_mat(zz,1:end));
            yy=squeeze(tfas_actually_mat(zz,1:end));
            y=yy(I);
            subplot(3,1,1)
            scatter(x,y)
%             Y=[Y y];
            % X = [ones(length(x),1) x];
            % X=x;
%             hold on;
%                 b = x\(y);
%             yCalc2 = x*b;
%             plot(x,yCalc2,'--')
%             title('Scattered Data')
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
               yo =sort(y_new(I));
        mean_hista(ii)=median(y_new(I));
        %taking the lower std
        aop=ceil(0.16*length(yo));

        std_hista(ii)=mean_hista(ii)-yo(aop);
%         std_hista(ii)=std(y_new(I));

            end
        
        end
       x_hista=(hista(2:end)+hista(1:(end-1)))/2;
        I2=find (isnan(mean_hista) & x_hista>0,1);
        I3=find (isnan(std_hista) &  x_hista>0,1);
        I4=min(I2,I3);
    subplot(3,1,3)  
        h2=plot(x_hista(1:I4),std_hista(1:I4),'y--');
        hold on;
        h1=plot(x_hista(1:I4),mean_hista(1:I4),'g--')  ;
        hold on;
        h3=plot(x_hista(1:I4),x_hista(1:I4),'k');
        
        meaning(zz,1:(length(hista)-1))=mean_hista;
        stding(zz,1:(length(hista)-1))=std_hista;
%         legend('Mean','STD','Linear Compare')
        title('Predicted Perfromace')
%         legend('STD','Mean','Linear Compare')

       [mmmm,I5]= min(abs(x-x_hista(I4)));
        subplot(3,1,2)
         scatter(x(1:I5),y(1:I5));
            hold on;
                    xlabel('Log_T_{FAS} Predicted')
        ylabel('Log_T_{FAS} Measured')
%          hold on;
%                 b = x\(y);
%             yCalc2 = x*b;
%             plot(x,yCalc2,'--')
%             title('Scattered Data')
            end
        mean_vec=zeros(1,size(mean_hista,2));
        std_vec=zeros(1,size(mean_hista,2));
        for row=1:1:size(meaning,2)
            uyu=meaning(:,row);
            utu=stding(:,row);
            nani=~isnan(uyu);
            uyu=uyu(nani);
            utu=utu(nani);
            if length(nani)>(iter_num/2)
            mean_vec(row)=mean(uyu); 
            std_vec(row)=mean(utu);
            else
            mean_vec(row)=nan;  
            std_vec(row)=nan;
            end

        end
        subplot(3,1,3)  
        h4=plot(x_hista(1:I4),mean_vec(1:I4),'r','MarkerSize',20);
        hold on;
        h5=plot(x_hista(1:I4),std_vec(1:I4),'b','MarkerSize',20);
        xlabel('T_{FAS} Predicted')
        ylabel('T_{FAS} Measured')
        legend([h1 h2 h3 h4 h5],'Mean','STD','Linear Compare','Iterations mean','Iterations STD')
%         sgtitle(horzcat('Weights Number ',num2str(mm)))



