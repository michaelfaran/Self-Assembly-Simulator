%plot probablity trjactories
figure;X = [1 2 3 4];
Y = [4 5 6 7];
Z = [8 9 10 11];
C=[1 2 1 4];
sz=40;
scatter3(X,Y,Z,sz,C,'filled')
line(X,Y,Z)
colorbar()