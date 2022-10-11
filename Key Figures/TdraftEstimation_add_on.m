    for mm=1:1:size(W,1)
        figgg=figure;
        fullscreen();     

        nn=1;
            meaning=zeros(iter_num,length(hista)-1);
            stding=zeros(iter_num,length(hista)-1);
            for zz=1:1:iter_num          
            xx=squeeze(tfas_predict_mat(zz,mm,nn,1:end));
            [x,I]=sort(xx);
            yy=squeeze(tfas_actually_mat(zz,mm,nn,1:end)-tfas_predict_mat(zz,mm,nn,1:end));
            yy=squeeze(tfas_actually_mat(zz,mm,nn,1:end));
            y=yy(I);
            subplot(3,1,1)
            set(gca,'FontSize',20)
            scatter(x,y)
%             Y=[Y y];
            % X = [ones(length(x),1) x];
            % X=x;
            hold on;
                b = x\(y);
            yCalc2 = x*b;
            plot(x,yCalc2,'--')
%             title('Scattered Data')
            y_new=y;
%         xlabel('T_{FAS} Predicted')
%         ylabel('T_{FAS} Measured')

        bin_width=50;
        xp=[0 ;5000];
        hista=linspace(bin_width*floor(min(xp/bin_width)),bin_width*ceil(max(xp)/bin_width),floor((max(xp)-min(xp))/bin_width)+2);
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
        h2=plot(x_hista(1:I4),std_hista(1:I4),'y--');
        hold on;
        h1=plot(x_hista(1:I4),mean_hista(1:I4),'g--')  ;
        hold on;
        h3=plot(x_hista(1:I4),x_hista(1:I4),'k');
        set(gca,'FontSize',20)
        meaning(zz,1:(length(hista)-1))=mean_hista;
        stding(zz,1:(length(hista)-1))=std_hista;
%         legend('Mean','STD','Linear Compare')
% %         title('Predicted Perfromace')
%         legend('STD','Mean','Linear Compare')

       [mmmm,I5]= min(abs(x-x_hista(I4)));
        subplot(3,1,2)
        set(gca,'FontSize',20)
         scatter(x(1:I5),y(1:I5));
            hold on;
%                     xlabel('T_{FAS} Predicted')
%         ylabel('T_{FAS} Measured','FontSize',36)
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
%         xlabel('T_{FAS} Predicted','FontSize',36)
%         ylabel('T_{FAS} Measured','FontSize',36)
        legend([h1 h2 h3 h4 h5],'Mean','STD','Linear Compare','Iterations mean','Iterations STD')
%         sgtitle(horzcat('Weights Number ',num2str(mm)))
% han = gca;
% han.Visible = 'off';
set(gca,'FontSize',20)
ax = axes(figgg);
han = gca;
han.Visible = 'off';
% X label

% X label
xlabel('T_{FAS} Predicted [MC steps]','FontSize',20)      
y=ylabel('T_{FAS} Measured [MC steps]','FontSize',20);      
set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
set(gca,'FontSize',20)

han.XLabel.Visible = 'on';
% Left label
han.YLabel.Visible = 'on';
    end