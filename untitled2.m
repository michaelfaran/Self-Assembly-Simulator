figure;
x = wellx;
y1 = welly-wellstd;
y2 = welly+wellstd;
plot(x,welly);
hold on;
plot(x, y1)
hold on
plot(x, y2)
shade(x,y1,x,y2,'FillType',[1 2;2 1]);
