figure; imagesc(d1,d2,YI);colorbar; ax = gca;
 set(gca,'FontSize',36);
xlabel('y_{1}');ylabel('y_{2}');
xlabel('y_{1}','FontSize',28);ylabel('y_{2}','FontSize',28);
title('log ( T_{FAS} ) Map','FontSize',28)
title(sprintf(horzcat('Map of log','$( \\hat{T}_{FAS} )$')),'Interpreter','latex','FontSize',36);
fullscreen()