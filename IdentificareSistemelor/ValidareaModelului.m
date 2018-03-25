%Raspuns la treapta cu modelul identificat la raspuns la impuls
t=second;
u=Volt;
y=Volt1;

A=[0,1;-9.558375291288938e+06,-5.367295698685774e+02];
B=[0;1.999065046302644e+06];
C=[1,0];
D=0;
sys_Marius=ss(A,B,C,D);
figure
ys=lsim(sys_Marius,u,t,[y(1),0]);
plot(t,[ys,y,u]);
legend('Ysimulat','Yprimit','U');

%Eroarea medie patratica
e=y-ys;
J=sum(e.^2/length(e))
%Eroarea medie normalizata
ym=mean(y);
Empn=norm(y-ys)/norm(y-ym)

%%
% Raspuns la impuls cu modelul identificat la raspuns la treapta
t=second;
u=Volt;
y=Volt1;

A=[0,1;-9.450876871268911e+06,-1.010491802426854e+03];
B=[0;2.083263884665887e+06];
C=[1,0];
D=0;
sys_Marius=ss(A,B,C,D);
figure
ys=lsim(sys_Marius,u,t,[y(1),0]);
plot(t,[ys,y,u]);
legend('Ysimulat','Yprimit','U');

%Eroarea medie patratica
e=y-ys;
J=sum(e.^2/length(e))
%Eroarea medie normalizata
ym=mean(y);
Empn=norm(y-ys)/norm(y-ym)