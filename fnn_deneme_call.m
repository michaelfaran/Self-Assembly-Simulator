function [I,gg,FNN] = fnn_deneme_call(x,tao,mmax,rtol,atol)
tic
%x : time series
%tao : time delay
%mmax : maximum embedding dimension
%reference:M. B. Kennel, R. Brown, and H. D. I. Abarbanel, Determining
%embedding dimension for phase-space reconstruction using a geometrical 
%construction, Phys. Rev. A 45, 3403 (1992). 
%author:"Merve Kizilkaya"
%rtol=15
%atol=2;
N=length(x);
Ra=std(x,1);

for m=1:mmax
    M=N-m*tao;
    Y=psr_deneme(x,m,tao,M);
    FNN(m,1)=0;
    for n=1:M
        y0=ones(M,1)*Y(n,:);
        distance=sqrt(sum((Y-y0).^2,2));
        [neardis nearpos]=sort(distance);
        
        D=abs(x(n+m*tao)-x(nearpos(2)+m*tao));
        R=sqrt(D.^2+neardis(2).^2);
        if D/neardis(2) > rtol || R/Ra > atol
             FNN(m,1)=FNN(m,1)+1;
        end
    end
end
FNN=(FNN./FNN(1,1))*100;
I=find(FNN<5,1);
%[M,I]=min(FNN);
%figure
plot(1:length(FNN),FNN)
gg=tao*I;
gg(gg>500)=500;

grid on;
title(horzcat(num2str(I)))
xlabel('Embedding dimension')
ylabel('%F.N.N')
toc

function Y=psr_deneme(x,m,tao,npoint)
%Phase space reconstruction
%x : time series 
%m : embedding dimension
%tao : time delay
%npoint : total number of reconstructed vectors
%Y : M x m matrix
% author:"Merve Kizilkaya"
N=length(x);
if nargin == 4
    M=npoint;
else
    M=N-(m-1)*tao;
end

Y=zeros(M,m); 

for i=1:m
    Y(:,i)=x((1:M)+(i-1)*tao)';
end
