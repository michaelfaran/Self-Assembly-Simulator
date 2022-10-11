function[mu_vec,std_vec,Skewness_vec,trend_vec,Times_vec,SA_vec,cumulated_time_vec]=give_vecs(Total_energy,Distance,Y,cp)
lengthh=length(cp)-1;
T=Total_energy;
mu_vec=zeros(1,lengthh);
std_vec=zeros(1,lengthh);
% YYY=zeros(1,lengthh);
Skewness_vec=zeros(1,lengthh);
trend_vec=zeros(1,lengthh);
Times_vec=zeros(1,lengthh);
SA_vec=zeros(1,lengthh);
cumulated_time_vec=zeros(1,lengthh);
mimi1=zeros(1,length(T));
mimi2=zeros(1,length(T));
mimic1=find(Distance(:,1)==0);
mimic2=find(Distance(:,2)==0);
mimi1(mimic1)=1;
mimi2(mimic2)=1;
Y=floor(Y);
% YY=[Y(2:end)-Y(1:end-1) (Y(end)-Y(end-1))];
for ii=1:1:lengthh
mu_vec(ii)=mean(T(cp(ii):1:cp(ii+1)));
std_vec(ii)=std(T(cp(ii):1:cp(ii+1)));
Mediann=median(T(cp(ii):1:cp(ii+1)));
%appriximated by Pearson, see skewness wikipedia
Skewness_vec(ii)=(mu_vec(ii)-Mediann)/3*(std_vec(ii));
abc=polyfit(cp(ii):1:cp(ii+1),Y(cp(ii):1:cp(ii+1)),1);
trend_vec(ii)=abc(1);
Times_vec(ii)=cp(ii+1)-cp(ii);
SA_vec(ii)= logical(sum(mimi1(cp(ii):1:(cp(ii+1)))))+ logical(sum(mimi2(cp(ii):1:(cp(ii+1)))));
%  YYY(cp(ii):1:cp(ii+1))=abc(1).*ones(1,length(cp(ii):1:cp(ii+1)))';
end
SA_vec(SA_vec>1)=1;

%give back the time in the trajctory remains to S.A in the first time

for ii=1:1:lengthh
    aa=find(SA_vec==1);
    if isempty(find(aa==ii))
        try 
            II=find (aa>ii,1);
            omega=cumsum(Times_vec(ii:1:(aa(II)-1)));
            cumulated_time_vec(ii)=omega(end); 
        catch
            cumulated_time_vec(ii)=NaN; 
        end
    else
         cumulated_time_vec(ii)=0; 
    end
end

       
