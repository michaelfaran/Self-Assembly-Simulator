function cost=cost_function_Krzan(A,B)

[pc_A ev_A]=eigs(A,1);
[pc_B ev_B]=eigs(B,1);

U_A=fliplr(pc_A);
U_B=fliplr(pc_B);


cost=1-(trace(U_A'*U_B*U_B'*U_A))/(size(U_A,2));


