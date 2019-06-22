clear all;
n = 12;  %定义原子个数

b = 296;%跳过前n行
path2 = ['.\','all.xyz'];
fida = fopen(path2,'r');
    E =textscan(fida,'%s %f %f %f',n,'HeaderLines',b);    %[^\n]
    b1 = E{1,1};    b2 = E{1,2};
    b3 = E{1,3};
    b4 = E{1,4};

fp = fopen('cor.gjf','w');
a = '%chk=E:\Rexxff-forcefile-test\clay-reaxff-Si(OH)4\???\Si(OH)3O-.chk';
fprintf(fp,'%s\r\n',a);
fprintf(fp,'# hf/3-21g\r\n\n');
fprintf(fp,'Title Card Required\r\n\n');
fprintf(fp,'0 2\r\n');

for i =1:n
    fprintf(fp,'    %3s',b1{i,1});
    fprintf(fp,' %15.9f',b2(i,1));
    fprintf(fp,' %15.9f',b3(i,1));
    fprintf(fp,' %15.9f\r\n',b4(i,1));
   % fprintf(fp,'  %s\r\n',b12{i,1});

end
fprintf(fp,' \r\n\n');
fclose(fp);


