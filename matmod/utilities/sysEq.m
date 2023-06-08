
clear

%syms b d x y

syms b d
x = [0; 1];
y = [0.5, 0];
a = 1;
c = 0.3;

eqn = [y(1) == c*((x(1)*a+b).^(-1)) + d; y(2) == c*((x(2)*a+b).^(-1)) + d];


S = solve(eqn,[b d]);

c
b = eval(S.b(1))
d = eval(S.d(1))

%Sd = solve(eqn,d);
 
