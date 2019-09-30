clear all;
path = './test.xyz';
file = fopen(path,'r');
num = 186; % total atom number
timestep = 0.25; % MD time step
n1 = 5000;  % initial position
n2 = 11000;  % final position equal to max tryjectory    n2 >=2 && n2 >=n1
for hh = n1:n2
    if hh == n1
        B = textscan(file,'%s %f %f %f',num,'HeaderLines',2+(n1-1)*(num+2));
        p = 1;
        for i = 1:num
            if strcmp(B{1}{i},'Si')~=0
                A{p,1}=B{1}{i};
                A{p,2}=B{2}(i);
                A{p,3}=B{3}(i);
                A{p,4}=B{4}(i);
                p = p + 1;
            end
        end
        num_Si = p-1;
        for i = 1:num
            if strcmp(B{1}{i},'O')~=0
                A{p,1}=B{1}{i};
                A{p,2}=B{2}(i);
                A{p,3}=B{3}(i);
                A{p,4}=B{4}(i);
                p = p + 1;
            end
        end
        num_O = p - 1 - num_Si;
        for i = 1:num
            if strcmp(B{1}{i},'H')~=0
                A{p,1}=B{1}{i};
                A{p,2}=B{2}(i);
                A{p,3}=B{3}(i);
                A{p,4}=B{4}(i);
                p = p + 1;
            end
        end
        num_H = p - 1 - num_Si - num_O;
        eval(['cor_',num2str(hh),'=A',';'])
    else
        B = textscan(file,'%s %f %f %f',num,'HeaderLines',3);
         p = 1;
        for i = 1:num
            if strcmp(B{1}{i},'Si')~=0
                A{p,1}=B{1}{i};
                A{p,2}=B{2}(i);
                A{p,3}=B{3}(i);
                A{p,4}=B{4}(i);
                p = p + 1;
            end
        end
        for i = 1:num
            if strcmp(B{1}{i},'O')~=0
                A{p,1}=B{1}{i};
                A{p,2}=B{2}(i);
                A{p,3}=B{3}(i);
                A{p,4}=B{4}(i);
                p = p + 1;
            end
        end
        for i = 1:num
            if strcmp(B{1}{i},'H')~=0
                A{p,1}=B{1}{i};
                A{p,2}=B{2}(i);
                A{p,3}=B{3}(i);
                A{p,4}=B{4}(i);
                p = p + 1;
            end
        end
        eval(['cor_',num2str(hh),'=A',';'])
    end
end

fclose(file);
%  eval(['num_', species{i}, ' = ' num2str(0)]);



t = 1;
for i = 1:(n2-n1)
    init = n1;
    autocorr = n1 + t;
    msd_Si = 0;
    msd_O = 0;
    msd_H = 0;
    for j = 1:n2-n1-t+1
        %  define initial atom position
        eval(['init_cor','=','cor_',num2str(init),';'])
        %  define autocorrelate atom position
        eval(['final_cor','=','cor_',num2str(autocorr),';'])
        for k = 1:num_Si       % msd_Si
            x1 = init_cor{k,2};
            x2 = final_cor{k,2};
            y1 = init_cor{k,3};
            y2 = final_cor{k,3};
            z1 = init_cor{k,4};
            z2 = final_cor{k,4};
            msd_Si = msd_Si + msd(x1,x2,y1,y2,z1,z2);
        end
        
        for k = (1+num_Si):(num_Si+num_O)  %msd_O
            x1 = init_cor{k,2};
            x2 = final_cor{k,2};
            y1 = init_cor{k,3};
            y2 = final_cor{k,3};
            z1 = init_cor{k,4};
            z2 = final_cor{k,4};
            msd_O = msd_O + msd(x1,x2,y1,y2,z1,z2);
        end
        
        for k = (1+num_Si+num_O):num   %msd_H
            x1 = init_cor{k,2};
            x2 = final_cor{k,2};
            y1 = init_cor{k,3};
            y2 = final_cor{k,3};
            z1 = init_cor{k,4};
            z2 = final_cor{k,4};
            msd_H = msd_H + msd(x1,x2,y1,y2,z1,z2);
        end
        
        init = init + 1;
        autocorr = autocorr + 1;
    end
    msd_Siconvert = msd_Si/(num_Si * (n2-n1-t+1));
    msd_Oconvert = msd_O/(num_O * (n2-n1-t+1));
    msd_Hconvert = msd_H/(num_H * (n2-n1-t+1));
    msd_Sifinal(t,1) = t * timestep * 100;
    msd_Sifinal(t,2) = msd_Siconvert;
    msd_Ofinal(t,1) = t * timestep * 100;
    msd_Ofinal(t,2) = msd_Oconvert;
    msd_Hfinal(t,1) = t * timestep * 100;
    msd_Hfinal(t,2) = msd_Hconvert;
    t = t + 1;
    disp(t);
end
path1 = './msd.data';
fp1 = fopen(path1,'w');
fprintf(fp1,'time   MSD-Si   MSD-O   MSD-H\r\n');
for i = 1:(t-1)
    
   fprintf(fp1,'%8.6f   %8.6f   %8.6f   %8.6f\r\n',msd_Sifinal(i,1), msd_Sifinal(i,2),msd_Ofinal(i,2),msd_Hfinal(i,2));
end
% define function for calculatioh of MSD
function eachmsd = msd(x1,x2,y1,y2,z1,z2)
eachmsd = (x1-x2)^2+(y1-y2)^2+(z1-z2)^2;
end








