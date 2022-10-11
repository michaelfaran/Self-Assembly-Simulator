figure;
 sgtitle('Different Scales Effect for average EPR as Potential Order Parameter')

hx=2:1:7;
hx=7;
Wind=10.^hx;

for ii=1:1:length(hx)
subplot(3,2,ii);
yyaxis left
plot(x,sum(cumsum(foo22.foo),2));
ylabel('Total Entropy Production')
xlabel('Steps')
title(horzcat('Mu is 2, run 1, num of target 2, Window Size is',num2str(Wind(ii))))
hold on;
yyaxis right
pop=sum(cumsum(foo22.foo),2);
popDER=[pop(2:end)- pop(1:(end-1));pop(end)-pop(end-1)];
popitup=movsum(popDER,Wind(ii));
popDER2=[popitup(2:end)- popitup(1:(end-1));popitup(end)-popitup(end-1)];
popitup2=movsum(popDER2,Wind(ii));
% hold on;
 plot(x,popitup2); 
% pop2 = smoothdata(pop,'sgolay',10^6) ;
% pop2DER=[pop2(2:end)- pop2(1:(end-1));pop2(end)-pop2(end-1)];
% hold on;
% plot(x,pop2DER); 
ylabel('EPR Mov');
hold on;
% plot(x,pop2DER);
end

