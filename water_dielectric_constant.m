%The values of the dielectric constant of SPC/E water
%先算ε，水的介电常数
%ε=1+v1ht^1/4 +v2ht+v3ht^10/4 +v4h^2t^6/4 +v5h^3t6/4
%+v6h^3t^10/4
% 25度---ε =78.36 F/m
% density c = 0.276 g/cm3 , Tc = 640.25 K and pc = 164.37 bar
% h= density/density c; t= Tc /T
clc;clear;
v=[0.1295308;0.5766912;1.703666;2.181501;-0.09539024;-0.1498977];
%h(1,1) 1g/cm3; h(2,1) 0.6g/cm3; h(3,1) 0.33g/cm3;h(4,1) 0.1g/cm3
PI= [1 0.6 0.3 0.1];
TI= [298; 653; 873; 1273];
pc=0.276;
tc=640.25;
P(1,1)=0.712/pc;
P(2,1)=0.6/pc;
P(3,1)=0.3/pc;
P(4,1)=0.1/pc;
%t(1,1) 25;t(2,1) 380;t(3,1) 1000
T(1,1)=tc/573;
T(2,1)=tc/653;
T(3,1)=tc/873;
T(4,1)=tc/1273;
%t=25,p=1%e(h(i),t(j))h 密度 t温度
for i=1:4
    for j=1:4
       e(i,j)=1+v(1)*P(i)*T(j)^(1/4)+v(2)*P(i)*T(j)+v(3)*P(i)*T(j)^(10/4)+v(4)*P(i)^2*T(j)^(6/4) +v(5)*P(i)^3*T(j)^(6/4)+v(6)*P(i)^3*T(j)^(10/4);
    end
end
%W(r0)=[-q^2/(4*pi*e(i,j)*r0)        ||+4*eLJ(k){(aLJ(k)/r0)^12-(aLJ(k)/r0)^6}]
r0=8.0*10^(-10);
q=1.6*10^(-19);
%eLJ(1,1) aLJ(1,1) nacl...eLJ(2,1) aLJ(2,1) kcl...||eLJ(3,1) aLJ(3,1) licl
%不要LiCl
eLJ(1)=0.161245;aLJ(1)=2.759*10^(-10);eLJ(2,1)=0.1;aLJ(2,1)=3.8655*10^(-10);
%LiCl eLJ(3,1)=0.1288;aLJ(3,1)=2.95*10^(-10);
%W(r0)=[-q^2/(4*pi*e(i,j)*r0)+4*eLJ(k)((aLJ(k)/r0)^12-(aLJ(k)/r0)^6)];%k:na k li%l=(i,j) e  1,1 1,2 1,3 2,1 2,2 2,3  3,1 3,2 3,3 


  for i=1:4
    for j=1:4
          test(i,j)=-2*q^2/(4*3.1415926*e(i,j)*r0)/4.184/1000*6.022*10^23/8.8541/10^-12;%+b(k);
    end
  end
for k=1:2
   b(k)=4*eLJ(k)*((aLJ(k)/r0)^12-(aLJ(k)/r0)^6);  
end
wroconstantna=test+ones(4,4).*b(1);
wroconstantk=test+ones(4,4).*b(2);
%-q^2/(4*3.1415926*e(2,1)*r0)/4.2/1000*6.62*10^23

save dielectric_wr0 wroconstantna wroconstantk PI TI