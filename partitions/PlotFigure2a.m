%Michael plots Figure 2 left side in Gili's important paper
target_num=1:1:4;
% target_num=2;
formatSpec = '%.1f';
for po=1:1:length(target_num)
str2=num2str(target_num(po));
cd(horzcat('C:\Users\admin\Documents\GitHub\GradProject\Results\01_02_2022_14_43_01\',str2));
mu=0;
J=-6.5:0.5:-3;
J=flip(J,2);
INDEX=zeros(1,length(J));
asaas=horzcat('output_01_02_2022_14_43_01_targets_',str2,'.txt');
txt=importdata(asaas);
text = readtable(asaas);
bb=txt.textdata;
aa=table2cell(text(:,1));
for ii=1:1:length(J)
gg=horzcat('beginning run with mu =',num2str(mu),' and with interaction =',num2str(J(ii),formatSpec),'------');
for mm=1:1:length(aa)
tf = strcmp(aa{mm,1},gg);
if tf==1
INDEX(ii)=mm;
else
tf=0;
end
end

end

ll=length(str2double(table2array(text (INDEX(1):3:(INDEX(2)+2),2))));
ZZ=zeros(length(J),ll);
jj=1;
INDEX=[INDEX length(aa)];
for yy=1:1:(length(J))
ttt=str2double(text ((INDEX(jj)+2):3:(INDEX(jj+1)-1),1));
ZZ(yy,:)=ttt;
jj=jj+1;
end

pop=median(ZZ,2);
figure;
plot(flip(J,2),flip(pop,2));
ylabel('Tfas Mean');
xlabel('Js');
title(horzcat('Tfas Mean(Js),Number of Targets',str2));
end
