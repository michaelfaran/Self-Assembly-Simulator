figure;
subplot(3,1,1);
A=cumsum(squeeze(foo(3,1,1,:)));
plot(A);
title('Entropy Production (Simulation Steps) for \mu=2')


subplot(3,1,2);
A=cumsum(squeeze(foo(3,1,2,:)));
plot(A);
ylabel('Total Entropy Production')

subplot(3,1,3);
A=cumsum(squeeze(foo(3,1,3,:)));
plot(A);
xlabel('Simulation Steps')

