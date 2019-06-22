clear all;
zh = 998; %更改帧数
n = 576;  %定义原子个数
ti = (zh-1)*(n+9)+9; %跳过的行数
ti2 = ti - 4;
file ='solution';%更改文件名        注意原子类型
rcut = 1.9;  %成键距离

path = ['.\',file,'.lammpstrj'];%更改坐标文件名
fid = fopen(path,'r');
A = textscan(fid,'%*d %*d %s %*d %f %f %f',n,'HeaderLines',ti);   %更改跳过的行数
fclose(fid);
fid = fopen(path,'r');
B = cell2mat(textscan(fid,'%f %f',3,'HeaderLines',ti2));

xlo = B(1,1);
xhi = B(1,2); 
ylo = B(2,1);
yhi = B(2,2); 
zlo = B(3,1);
zhi = B(3,2); 

dxx = B(1,2)-B(1,1);
dyy = B(2,2)-B(2,1);
dzz = B(3,2)-B(3,1);
[a2,a3,a4] = A{:,2:4};
a1 = A{:,1};
fclose(fid);
j = 0;% 氧原子数
k = 0;% 硅原子数
for i=1:n
    
    if a1{i,1} == 'O'
        j = j +1;
        oxygen(j,1) = A{2}(i);
        oxygen(j,2) = A{3}(i);
        oxygen(j,3) = A{4}(i);
    else
        k = k +1;
        silicon(k,1) = A{2}(i);
        silicon(k,2) = A{3}(i);
        silicon(k,3) = A{4}(i);
    end
end
oxytotal = oxygen;
num = j;
ja = 0;
for i=1:num
    if oxygen(i,1) <= 5 + xlo
        j=j+1;
        oxygen(i,1)=oxygen(i,1)+dxx;
        oxytotal(j,1:3) = oxygen(i,1:3);
    elseif  oxygen(i,1) >= xhi - 5
        j = j + 1;
        oxygen(i,1)=oxygen(i,1)-dxx;
        oxytotal(j,1:3) = oxygen(i,1:3);
    end
end 
oxyextra = [];
oxyextra = oxytotal;
for i=1:max(size(oxyextra))
    if oxyextra(i,2) <= 5 + ylo
        j = j + 1;
        oxyextra(i,2)=oxyextra(i,2)+dyy;
        oxytotal(j,1:3) = oxyextra(i,1:3);
    elseif  oxyextra(i,2) >= yhi - 5
        j = j + 1;
        oxyextra(i,2)=oxyextra(i,2)-dyy;
        oxytotal(j,1:3) = oxyextra(i,1:3);
    end    
end

oxyextra = [];
oxyextra = oxytotal;
for i=1:max(size(oxyextra))
    if oxyextra(i,3) <= 5 + zlo
        j = j + 1;
        oxyextra(i,3) = oxyextra(i,3)+dzz;
        oxytotal(j,1:3) = oxyextra(i,1:3);
    elseif  oxyextra(i,3) >= zhi - 5
        j = j + 1;
        oxyextra(i,3) = oxyextra(i,3)-dzz;
        oxytotal(j,1:3) = oxyextra(i,1:3);
    end    
end

aa = max(size(silicon));
bb = max(size(oxytotal));

for i=1:aa
    cornum = 0;
    x1 = silicon(i,1);
    y1 = silicon(i,2);
    z1 = silicon(i,3);
    for hh = 1:bb
        x2 = oxytotal(hh,1);
        y2 = oxytotal(hh,2);
        z2 = oxytotal(hh,3);
        distances=dist(x1,x2,y1,y2,z1,z2);
        if distances < rcut
            cornum = cornum +1;
        end
    end
    silicon(i,4) = cornum;
end
cor3 =0;
cor4 =0;
cor5 =0;
cor6=0;
for i=1:aa
   if silicon(i,4) == 3
       cor3 = cor3 + 1;
   elseif silicon(i,4) == 4
       cor4 = cor4 + 1;
   elseif silicon(i,4) ==5
       cor5 = cor5 + 1;
   elseif silicon(i,4) ==6
       cor6 = cor6 + 1;
   end
end 
cortotal = cor3+cor4+cor5+cor6;
perc3 = cor3/cortotal;
perc4 = cor4/cortotal;
perc5 = cor5/cortotal;
perc6 = cor6/cortotal;

path = 'output.xyz';
fad = fopen(path,'w');

    fprintf(fad,'%d\r\n',aa+bb);
    fprintf(fad,'atoms\r\n');
for i=1:aa

    fprintf(fad,'Si   %15.9f %15.9f %15.9f\r\n',silicon(i,1),silicon(i,2),silicon(i,3));
end
for i=1:bb

    fprintf(fad,'O   %15.9f %15.9f %15.9f\r\n',oxytotal(i,1),oxytotal(i,2),oxytotal(i,3));
end

fclose(fad);


function distance =dist(x1,x2,y1,y2,z1,z2)
distance = sqrt((x1-x2)^2+(y1-y2)^2+(z1-z2)^2);
end












