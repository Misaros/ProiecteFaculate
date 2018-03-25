t=second;
u=Volt;
y=Volt1;
plot(t,[u,y]);
hold on
yst=mean(y(966:1000));
ust=mean(u(966:1000));
y0=mean(y(427:496));
u0=mean(u(427:496));
ymax=y(553);
t0=0;
t1=t(553)
T=(t1-t0)
d1=yst-y0;
d2=ust-u0;
k=d1/d2;
sigma=(ymax-yst)/(yst-y0);
tita=(-log(sigma))/sqrt(log(sigma)^2+pi^2);
omegan=pi/(T*sqrt(1-tita^2));
H=tf(k*omegan^2,[1 2*tita*omegan omegan^2]); 

ys=lsim(H,u,t);
figure
plot(t,[ys,y]);
legend('Ysimulat','Yprimit');
%Spatiul starilor
A=[0 1; -(omegan^2) -2*tita*omegan];
B=[0;k*omegan*omegan];
C=[1 0];
D=0;
sys_Misaros=ss(A,B,C,D);
figure
ys=lsim(sys_Misaros,u,t,[y(1),0]);
plot(t,[ys,y]);
%Eroarea medie patratica
e=y-ys;
J=sum(e.^2/length(e))
%Eroarea medie normalizata
ym=mean(y);
Empn=norm(y-ys)/norm(y-ym)