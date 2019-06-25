clear all;
path = './Albig.xyz';
file = fopen(path,'r');
num = 944; % total atom number
timestep = 0.5; % MD time step
n1 = 1;  % initial position
n2 = 200;  % final position equal to max tryjectory    n2 >=2 && n2 >=n1
A = textscan(file,'%s %f %f %f',num,'HeaderLines',2+(n1-1)*(num+2));
%fclose(file);

BB = [887,863,708,857,890,729,684,869,881,866,696,672,678,675,756,878,624,591,603,615,621,600,597,612,770,806,836,827,839,809,761,824,794,800,785,938,788,845,779,773,606,585,582,618,594,588,642,669,693,711,702,681,705,690,842,687,854,908,872,851,935,848,884,860];
BC = ones(1,64);
BB = BB+BC;
%  define initial atom position
    p=1;     
for i = 1:num
    if strcmp(A{1}{i},'Na')~=0
        iniNa{p,1}=A{1}{i};
        iniNa{p,2}=A{2}(i);
        iniNa{p,3}=A{3}(i);
        iniNa{p,4}=A{4}(i);
        p = p + 1;
    end
end 
j1 = p-1;  %Na atom number
p=1;

for i = (591-9):num
    flag = 1;
    for jj=1:64
        if i == BB(jj) 
           flag = 0; 
           break
        end
        
    end
    if flag ~= 0
            if strcmp(A{1}{i},'O')~=0
                iniO{p,1}=A{1}{i};
                iniO{p,2}=A{2}(i);
                iniO{p,3}=A{3}(i);
                iniO{p,4}=A{4}(i);
                p = p + 1;
            end
    end
end 
j2 = p-1;  %O atom number

p=1;

for i = (591-9):num
    flag = 0;
    for jj=1:64
        if i == BB(jj) 
           flag = 1; 
           break
        end
        
    end
    if flag ~= 0
            if strcmp(A{1}{i},'O')~=0
                inifixO{p,1}=A{1}{i};
                inifixO{p,2}=A{2}(i);
                inifixO{p,3}=A{3}(i);
                inifixO{p,4}=A{4}(i);
                p = p + 1;
            end
    end
end 
j3 = p-1;  %fixO atom number


%file = fopen(path,'r');

ka = 1;
kb = 1;
kc = 1;

% define final atom position and calculate MSD
for j = n1:n2
    
B = textscan(file,'%s %f %f %f',num,'HeaderLines',3);
p=1;
for i = 1:num
    if strcmp(B{1}{i},'Na')~=0
        finNa{p,1}=B{1}{i};
        finNa{p,2}=B{2}(i);
        finNa{p,3}=B{3}(i);
        finNa{p,4}=B{4}(i);
        p = p + 1;
    end
end 

p=1;
for i = (591-9):num
    flag = 1;
    for jj=1:64
        if i == BB(jj) 
           flag = 0; 
           break
        end
        
    end
    if flag ~= 0
            if strcmp(B{1}{i},'O')~=0
                finO{p,1}=B{1}{i};
                finO{p,2}=B{2}(i);
                finO{p,3}=B{3}(i);
                finO{p,4}=B{4}(i);
                p = p + 1;
            end
    end
end

p=1;

for i = (591-9):num
    flag = 0;
    for jj=1:64
        if i == BB(jj) 
           flag = 1; 
           break
        end
        
    end
    if flag ~= 0
            if strcmp(A{1}{i},'O')~=0
                finfixO{p,1}=B{1}{i};
                finfixO{p,2}=B{2}(i);
                finfixO{p,3}=B{3}(i);
                finfixO{p,4}=B{4}(i);
                p = p + 1;
            end
    end
end



msd_Na = 0;
for i=1:j1
    
   x1 = iniNa{i,2};
   x2 = finNa{i,2};
   y1 = iniNa{i,3};
   y2 = finNa{i,3};
   z1 = iniNa{i,4};
   z2 = finNa{i,4};
   msd_Na = msd_Na + msd(x1,x2,y1,y2,z1,z2);
end

msd_Nafinal(ka,1)=ka*20000/1000*timestep;    % *100 means thermo frequency equal 100;  /1000 means converted to ps
msd_Nafinal(ka,2) = msd_Na/j1;
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

msd_Ofinal(kb,1)=kb*20000/1000*timestep;    % *100 means thermo frequency equal 100;  /1000 means converted to ps
msd_Ofinal(kb,2) = msd_O/j2;
kb = kb + 1;

msd_fixO = 0;
for i=1:j3
    
   x1 = inifixO{i,2};
   x2 = finfixO{i,2};
   y1 = inifixO{i,3};
   y2 = finfixO{i,3};
   z1 = inifixO{i,4};
   z2 = finfixO{i,4};
   msd_fixO = msd_fixO + msd(x1,x2,y1,y2,z1,z2);
end

msd_fixOfinal(kc,1)=kc*20000/1000*timestep;    % *100 means thermo frequency equal 100;  /1000 means converted to ps
msd_fixOfinal(kc,2) = msd_fixO/j3;
kc = kc + 1;

end



% define function for calculatioh of MSD
function eachmsd = msd(x1,x2,y1,y2,z1,z2)
eachmsd = (x1-x2)^2+(y1-y2)^2+(z1-z2)^2;
end













