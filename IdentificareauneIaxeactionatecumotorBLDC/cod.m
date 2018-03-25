
c=misaros_marius;

t=double (c.X.Data');
u=double (c.Y(1,3).Data');%intrare
w=double (c.Y(1,2).Data');%viteza
y=double (c.Y(1,1).Data');%pozitie
x = length(t);
Te=t(2)-t(1); %perioada de esantionare

subplot(311)
plot(t,u)
title('Intrarea u [ V ]')
ylabel('u','fontsize',10);
xlabel('Timpul(sec)','fontsize',10);

subplot(312)
plot(t,w,'g')
grid on;
title('Viteza unghiulara \omega')
ylabel('\omega(rad/s)','fontsize',10);
xlabel('Timpul(sec)','fontsize',10);


subplot(313)
plot(t,y,'r')
title('Pozitia unghulara \theta "y" ')
ylabel('\theta(mm)','fontsize',10);
xlabel('Timpul(sec)','fontsize',10);




%Datele sunt alese de pe sensuri diferite ale motorului
i1=852;%date pt identificare
i2=2592;
i3=3354;%date pt validare 6848
i4=5150;
% 
% i1=1765;%date pt identificare
% i2=3155;
% i3=4357;%date pt validare 6848
% i4=5582;

t1=t(i1:i2); %timpul
u1=u(i1:i2); %intrarea
w1=w(i1:i2); %viteza
y1=y(i1:i2); %pozitia


t2=t(i3:i4); %timpul
u2=u(i3:i4); %intrarea
w2=w(i3:i4); %viteza
y2=y(i3:i4); %pozitia

% i_id=i1:i2;
% i_vd=i3:i4;
% 
% data1=iddata(w,u,Te);
% data2=iddata(y,w,Te);

% 
%Metoda celor mai mici patrate recursiva
% pentru viteza "w"
d_id_viteza=iddata(w1,u1,Te);
d_vd_viteza=iddata(w2,u2,Te); 
% pentru pozitie "y"
d_id_pozitie=iddata(y1,w1,Te);
d_vd_pozitie=iddata(y2,w2,Te);

%----- TOTUL E BINE SI FRUMOS------l^l%
%ARMAX CHECK

Marmax=armax(d_id_viteza,[1 1 1 0])
figure
compare(d_vd_viteza,Marmax)
figure
resid(Marmax,d_vd_viteza,'corr',25)

%Functia de transfer de la intrare la viteza cu metoda ARMAX
den1=Marmax.B
num1=Marmax.A
H_wu_armax=tf(den1,num1,Te)
H1=d2c(H_wu_armax,'zoh')

%MODELUL SISTEMULUI DE LA  w --> y
%ARMAX CHECK
Marmax2=armax(d_id_pozitie,[1 1 1 0])
figure
compare(d_vd_pozitie,Marmax2)
figure
resid(Marmax2,d_vd_pozitie,'corr',25)

%Functia de transfer de la viteza w la pozitia y
den2=Marmax2.B
num2=Marmax2.A
H_yw_armax=tf(den2,num2,Te)
H2=d2c(H_yw_armax,'tustin')
% armax
 figure
H_armax=H1*H2
 y_c_armax=lsim(H_armax,u,t);
 plot(t,[y_c_armax+y(1),y]);grid
legend('y_carmax','Iesirea');
title('Simulare finala');


% 2) Metoda erorii la iesire OE-Output error

%Modelul sistemului de la u la w
 %OE
Moe=oe(d_id_viteza,[1 1 0])
figure
compare(d_vd_viteza,Moe)
figure
resid(Moe,d_vd_viteza,'corr',25)

% Functia de transfer de la intrarea 'u' la viteza 'w' cu metoda OE

den3=Moe.B
num3=Moe.F
H_wu_oe=tf(den3,num3,Te)
H3=d2c(H_wu_oe,'zoh')

%Modelul sistemului de la viteza w la pozitia y
 %OE
Moe2=oe(d_id_pozitie,[1 1 0])
figure
compare(d_vd_pozitie,Moe2)
figure
resid(Moe2,d_vd_pozitie,'corr',25)
%functia de transfer de la viteza w la pozitia y cu metoda OE
den4=Moe2.B
num4=Moe2.F
H_yw_oe=tf(den4,num4,Te)
H4=d2c(H_yw_oe,'tustin')

 % oe
figure
H_oe=H3*H4
y_c_oe=lsim(H_oe,u,t);
plot(t,[y_c_oe+y(1),y]);grid
legend('y_coe','Iesirea');
title('Simulare finala');

%Calcularea vitezei si pozitiei utilizand spatiul starilor
data= iddata([w, y], u, Te);
Mss=n4sid(data, 1:5)
figure
resid(Mss,data);
figure
compare(data, Mss);

a = Mss.A
b = Mss.B
c = Mss.C
d = Mss.D
k = Mss.K
x0 = Mss.x0
figure
ycd = dlsim(a, b, c, d, u, x0);
plot(t, [ycd w y]);





