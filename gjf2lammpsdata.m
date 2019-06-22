clear all;
n = 12;  %定义原子个数
c =num2str(n);
path = ['.\2.8.gjf'];%更改坐标文件名
fid = fopen(path,'r');
A = textscan(fid,'%s %f %f %f',n,'HeaderLines',6);   %更改跳过的行数
[a2,a3,a4] = A{:,2:4};
a1 = A{:,1};
fclose(fid);

path2 = ['.\','I-beta.data'];
fida = fopen(path2,'r');
    E =textscan(fida,'%d %d %d %f %f %f %f %d %d %d %s %s',n,'HeaderLines',18);
    b1 = E{1,1};
    b2 = E{1,2};
    b3 = E{1,3};
    b4 = E{1,4};
    b5 = E{1,5};
    b6 = E{1,6};
    b7 = E{1,7};
    b8 = E{1,8};
    b9 = E{1,9};
    b10 = E{1,10};
    b11 = E{1,11};
    b12 = E{1,12};
    b5 = a2;
    b6 = a3;
    b7 = a4;  
    b12 = a1;
fclose(fid);
fp = fopen('output.data','w');

fprintf(fp,'LAMMPS data file. msi2lmp v3.9.8 / 06 Oct 2016 / CGCMM for I-beta\r\n\n');
fprintf(fp,'   %d atoms\r\n\n',n);
fprintf(fp,'   3 atom types\r\n\n');
fprintf(fp,'   -20.000000000    20.000000000 xlo xhi\r\n');
fprintf(fp,'   -20.000000000    20.000000000 ylo yhi\r\n');
fprintf(fp,'   -20.000000000    20.000000000 zlo zhi\r\n\n');
fprintf(fp,'Masses\r\n\n');
fprintf(fp,'   1  28.086000 # Si\r\n');
fprintf(fp,'   2  15.999400 # o\r\n');
fprintf(fp,'   3   1.007970 # h\r\n\n');
fprintf(fp,'Atoms # full\r\n\n');

c1 = 'Si';
c2 = 'O';
c3 = 'H';
for i =1:n
    fprintf(fp,'    %3d',b1(i,1));
    fprintf(fp,'    %3d',b2(i,1));
    if c1 == b12{i,1}
        b3(i,1)=1;
    elseif c2 == b12{i,1}
        b3(i,1)=2;
    else
        b3(i,1)=3;
    end
    fprintf(fp,' %3d',b3(i,1));
    fprintf(fp,'  %8.6f',b4(i,1));
    fprintf(fp,' %15.9f',b5(i,1));
    fprintf(fp,' %15.9f',b6(i,1));
    fprintf(fp,' %15.9f',b7(i,1));
    fprintf(fp,' %2d',b8(i,1));
    fprintf(fp,' %2d',b9(i,1));
    fprintf(fp,' %2d',b10(i,1));
    fprintf(fp,' %s',b11{i,1});
    fprintf(fp,' %s\r\n',b12{i,1});
   % fprintf(fp,'  %s\r\n',b12{i,1});

end
fclose(fp);
