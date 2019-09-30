clear all;
path = './test.xyz';
file = fopen(path,'r');
num = 1536; % total atom number
timestep = 0.05; % MD time step
n1 = 1;  % initial position
n2 = 4000;  % final position equal to max tryjectory    n2 >=2 && n2 >=n1
A = textscan(file,'%s %f %f %f',num,'HeaderLines',2+(n1-1)*(num+2));
%fclose(file);

%  define initial atom position
p=1;     
for i = 1:num
    if strcmp(A{1}{i},'Si')~=0
        iniSi{p,1}=A{1}{i};
        iniSi{p,2}=A{2}(i);
        iniSi{p,3}=A{3}(i);
        iniSi{p,4}=A{4}(i);
        p = p + 1;
    end
end 
j1 = p-1;  %Si atom number
p=1;
for i = 1:num
    if strcmp(A{1}{i},'O')~=0
        iniO{p,1}=A{1}{i};
        iniO{p,2}=A{2}(i);
        iniO{p,3}=A{3}(i);
        iniO{p,4}=A{4}(i);
        p = p + 1;
    end
end 
j2 = p-1;  %O atom number
p=1;
for i = 1:num
    if strcmp(A{1}{i},'H')~=0
        iniH{p,1}=A{1}{i};
        iniH{p,2}=A{2}(i);
        iniH{p,3}=A{3}(i);
        iniH{p,4}=A{4}(i);
        p = p + 1;
    end
end 
j3 = p-1;  %H atom number
%file = fopen(path,'r');

ka = 1;
kb = 1;
kc = 1;

% define final atom position and calculate MSD
for j = n1:n2
    
B = textscan(file,'%s %f %f %f',num,'HeaderLines',3);
p=1;
for i = 1:num
    if strcmp(B{1}{i},'Si')~=0
        finSi{p,1}=B{1}{i};
        finSi{p,2}=B{2}(i);
        finSi{p,3}=B{3}(i);
        finSi{p,4}=B{4}(i);
        p = p + 1;
    end
end 

p=1;
for i = 1:num
    if strcmp(B{1}{i},'O')~=0
        finO{p,1}=B{1}{i};
        finO{p,2}=B{2}(i);
        finO{p,3}=B{3}(i);
        finO{p,4}=B{4}(i);
        p = p + 1;
    end
end 

p=1;
for i = 1:num
    if strcmp(B{1}{i},'H')~=0
        finH{p,1}=B{1}{i};
        finH{p,2}=B{2}(i);
        finH{p,3}=B{3}(i);
        finH{p,4}=B{4}(i);
        p = p + 1;
    end
end 
msd_Si = 0;
for i=1:j1
    
   x1 = iniSi{i,2};
   x2 = finSi{i,2};
   y1 = iniSi{i,3};
   y2 = finSi{i,3};
   z1 = iniSi{i,4};
   z2 = finSi{i,4};
   msd_Si = msd_Si + msd(x1,x2,y1,y2,z1,z2);
end

msd_Sifinal(ka,1)=ka*100/1000*timestep;    % *100 means thermo frequency equal 100;  /1000 means converted to ps
msd_Sifinal(ka,2) = msd_Si/j1;
ka = ka + 1;


msd_O = 0;
for i=1:j2
    
   x1 = iniO{i,2};
   x2 = finO{i,2};
   y1 = iniO{i,3};
   y2 = finO{i,3};
   z1 = iniO{i,4};
   z2 = finO{i,4};
   msd_O = msd_O + msd(x1,x2,y1,y2,z1,z2);
end

msd_Ofinal(kb,1)=kb*100/1000*timestep;    % *100 means thermo frequency equal 100;  /1000 means converted to ps
msd_Ofinal(kb,2) = msd_O/j2;
kb = kb + 1;


msd_H = 0;
for i=1:j3
    
   x1 = iniH{i,2};
   x2 = finH{i,2};
   y1 = iniH{i,3};
   y2 = finH{i,3};
   z1 = iniH{i,4};
   z2 = finH{i,4};
   msd_H = msd_H + msd(x1,x2,y1,y2,z1,z2);
end

msd_Hfinal(kc,1)=kc*100/1000*timestep;    % *100 means thermo frequency equal 100;  /1000 means converted to ps
msd_Hfinal(kc,2) = msd_H/j3;
kc = kc + 1;

end



% define function for calculatioh of MSD
function eachmsd = msd(x1,x2,y1,y2,z1,z2)
eachmsd = (x1-x2)^2+(y1-y2)^2+(z1-z2)^2;
end













