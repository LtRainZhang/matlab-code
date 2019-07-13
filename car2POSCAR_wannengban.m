clear all;
%%%%%%%%%%%%%%%  something you need change

n = 76;  % input atom numbers
systemname='melt-NaCl';             % enter the name of system
path = '.\sio2.car';% change filename

%%%%%%%%%%
pi = 3.1415926;
c =num2str(n);
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
%species = unique(A{:,5});    %adjust the order
[~,i,~]=unique(A{:,5});
species=A{:,5}(sort(i));      %not adjust the order
spe_num = size(species);

for i = 1:spe_num(1)
    eval(['num_', species{i}, ' = ' num2str(0)]);
 %   eval([species{i}, '_atoms', '=', 'zeros(2,3)']);
 %   eval([species{i}, '_atoms','(1,2)', '=', num2str(2)]);
end

for i=1:n
    x = A{1}(i);
    y = A{2}(i);
    z = A{3}(i);
    cart_coor = [x;y;z];
    frac_coor = (cart2frac(cart_coor,lattice_vector))';
    
   for s=1:spe_num(1)
      if strcmp(A{5}{i},species{s})
          eval(['num_', species{s},'=','num_', species{s},'+',num2str(1)]);
          hhh = eval(['num_', species{s}]);
          eval([species{s}, '_atoms', '(',num2str(hhh),',',num2str(1),':',num2str(3),')', '=', 'frac_coor','(:)']);
      end
   end
   
end

fp = fopen('POSCAR','w');
fprintf(fp,'SYSTEM %s\r\n',systemname);
fprintf(fp,'      1.00000000000\r\n');
fprintf(fp,'      %14.12f        %14.12f       %14.12f\r\n',lattice_vector(1,1),lattice_vector(1,2),lattice_vector(1,3));

fprintf(fp,'      %14.12f        %14.12f       %14.12f\r\n',lattice_vector(2,1),lattice_vector(2,2),lattice_vector(2,3));
fprintf(fp,'      %14.12f        %14.12f       %14.12f\r\n',lattice_vector(3,1),lattice_vector(3,2),lattice_vector(3,3));
for s = 1:spe_num(1)
    
    if s == 1
        fprintf(fp,'   %s',species{s});
    elseif s == spe_num(1)
        fprintf(fp,'  %s\r\n',species{s});
    else
        fprintf(fp,'  %s',species{s});
    end
    
end
for s = 1:spe_num(1)
    
    if s == 1
        fprintf(fp,'   %d',eval(['num_',species{s}]));
    elseif s == spe_num(1)
        fprintf(fp,'  %d\r\n',eval(['num_',species{s}]));
    else
        fprintf(fp,'  %d',eval(['num_',species{s}]));
    end
    
end
fprintf(fp,'Direct\r\n');

for s = 1:spe_num(1)
    
    for i=1:eval(['num_',species{s}])
        fprintf(fp,'%-14.9f',eval([species{s},'_atoms','(', num2str(i),',1)']));
        fprintf(fp,'     %-14.9f',eval([species{s},'_atoms','(', num2str(i),',2)']));
        fprintf(fp,'     %12.9f\r\n',eval([species{s},'_atoms','(', num2str(i),',3)']));
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


