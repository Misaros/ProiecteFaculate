t=second;
u=Volt;
y=Volt1;
plot(t,[u,y]);
hold on

yst=mean(y(921:953));
ust=mean(u(921:953));
plot(t,yst*ones(size(t)),'r');
k=yst/ust;
dt=t(100)-t(99);
T=t(659)-t(608);

A1=sum(y(608:659)-yst)*dt;
A2=sum(y(660:716)-yst)*dt;
sigma= -A2/A1;

tita=(-log(sigma))/sqrt(log(sigma)^2+pi^2);
omegan=pi/(T*sqrt(1-tita^2));

H=tf(k*omegan^2,[1 2*tita*omegan omegan^2])

ys=lsim(H,u,t);
figure
plot(t,[ys,y]);
legend('Ysimulat','Yprimit');

%Spatiul starilor
A=[0 1; -(omegan^2) -2*tita*omegan];
B=[0;k*omegan*omegan];
C=[1 0];
D=0;
sys_Marius=ss(A,B,C,D);
figure
ys=lsim(sys_Marius,u,t,[y(1),0]);
plot(t,[ys,y]);
legend('Ysimulat','Yprimit');

e=y-ys;
J=sum(e.^2/length(e))

ym=mean(y);
Empn=norm(y-ys)/norm(y-ym)