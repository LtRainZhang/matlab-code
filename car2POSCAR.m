clear all;
n = 72;  %定义原子个数
pi = 3.1415926;
c =num2str(n);
path = '.\quart-1980 (2).car';%更改坐标文件名
fid = fopen(path,'r');
B = cell2mat(textscan(fid,'%*s %f %f %f %f %f %f %*s',1,'HeaderLines',4));
A = textscan(fid,'%*s %f %f %f %*s %d %*s %s %*f',n,'HeaderLines',1);
[a1,a2,a3] = A{:,1:3};
fclose(fid);
aa = B(1,1);
bb = B(1,2);
cc = B(1,3);
alfa = B(1,4);
beta = B(1,5);
gama = B(1,6);
lattice_vector = lattice_const2vect(aa,bb,cc,alfa,beta,gama);

Siatoms = zeros(n/3,3);
Oatoms = zeros(2*n/3,3);
num_Si = 0;
num_O = 0;
for i=1:n
    x = A{1}(i);
    y = A{2}(i);
    z = A{3}(i);
    cart_coor = [x;y;z];
    frac_coor = cart2frac(cart_coor,lattice_vector);
    
    
   if strcmp(A{5}{i},'Si')
       num_Si = num_Si + 1;
       Siatoms(num_Si,1) = frac_coor(1);
       Siatoms(num_Si,2) = frac_coor(2);
       Siatoms(num_Si,3) = frac_coor(3);
   else
       num_O = num_O + 1;
       Oatoms(num_O,1) = frac_coor(1);
       Oatoms(num_O,2) = frac_coor(2);
       Oatoms(num_O,3) = frac_coor(3);
   end
end

fp = fopen('POSCAR2','w');
fprintf(fp,'SYSTEM alfa-quart\r\n');
fprintf(fp,'      1.00000000000\r\n');
fprintf(fp,'      %14.12f        0.000000000000       0.000000000000\r\n',aa);
fprintf(fp,'      %14.12f      %14.12f        0.000000000000\r\n',-1*bb*cos(60/180*pi),bb*cos(30/180*pi));
fprintf(fp,'      0.000000000000       0.000000000000       %14.12f\r\n',cc);
fprintf(fp,'      Si O\r\n');
fprintf(fp,'      %d %d\r\n',num_Si,num_O);
fprintf(fp,'Direct\r\n');

for i =1:n
    if i <= num_Si
        fprintf(fp,'%-14.9f',Siatoms(i,1));
        fprintf(fp,'     %-14.9f',Siatoms(i,2));
        fprintf(fp,'     %12.9f\r\n',Siatoms(i,3));
    else
        fprintf(fp,'%-14.9f',Oatoms(i-num_Si,1));
        fprintf(fp,'     %-14.9f',Oatoms(i-num_Si,2));
        fprintf(fp,'     %12.9f\r\n',Oatoms(i-num_Si,3));  
    end
end
fclose(fp);

function lattice_vector = lattice_const2vect(aa,bb,cc,alfa,beta,gama)
    alfa = alfa/180*pi;%degree converted to radia
    beta = beta/180*pi;
    gam = gama/180*pi;
    aa_v = aa * [ 1, 0, 0];
    bb_v = bb * [cos(gam),sin(gam),0];
    cc_v = cc * [cos(beta),(cos(alfa)-cos(beta)*cos(gam))/sin(gam), sqrt(1+2 * cos(alfa)*cos(beta)*cos(gam)-(cos(alfa))^2-(cos(beta))^2-(cos(gam))^2)/sin(gam)];
    lattice_vector = [aa_v;bb_v;cc_v];
    
end

function frac_coor = cart2frac(coor_cart,lattice_vector)

    frac_coor = inv(lattice_vector)*coor_cart;
    
end

















