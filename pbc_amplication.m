clear all;
path = './nvt.dump';
file =fopen(path,'r');
num = 944;
n1 = 1;  % initial position
n2 = 200;  % final position equal to max tryjectory
%{26.571600 17.847601 20.967600 90.000000 107.559998 90.000000}
BB = [887,863,708,857,890,729,684,869,881,866,696,672,678,675,756,878,624,591,603,615,621,600,597,612,770,806,836,827,839,809,761,824,794,800,785,938,788,845,779,773,606,585,582,618,594,588,642,669,693,711,702,681,705,690,842,687,854,908,872,851,935,848,884,860];
BC = ones(1,64);
BB = BB+BC;
fid = fopen('lin.lammpstrj','w');
aa = 26.571600;
bb = 17.847601;
cc = 20.967600;
alfa = 90.000000;
beta = 107.559998;
gama = 90.000000;
lattice_vector = lattice_const2vect(aa,bb,cc,alfa,beta,gama);



for hh = n1:n2
    p = 0;
    if hh == n1
        A = textscan(file,'%d %d %s %f %f %f',num,'HeaderLines',9+(n1-1)*(num+2));
    else
        A = textscan(file,'%d %d %s %f %f %f',num,'HeaderLines',10);
    end
    ini =[];
    for i = 1:num
        p = p+1;
        x = A{4}(i);
        y = A{5}(i);
        z = A{6}(i);
        cart_coor = [x;y;z];
        frac_coor = cart2frac(cart_coor,lattice_vector);
        ini{p,1}=A{1}(i);
        ini{p,2}=A{2}(i);
        ini{p,3}=A{3}{i};
        ini{p,4}=frac_coor(1);
        ini{p,5}=frac_coor(2);
        ini{p,6}=frac_coor(3);
        
    end        

     
    j1 = num;  

    for i = 1:j1
       finele(i,:) = [ini{i,4},ini{i,5},ini{i,6},double(ini{i,2})];
    end

    

    tot_j1 = 0;
    
    tot_j1 = tot_j1 + j1;
    tot_ele = finele;
    tot_ele(tot_j1+1:tot_j1+j1,:) = finele+[ones(j1,1),zeros(j1,1),zeros(j1,1),zeros(j1,1)] ;
    
    
    tot_j1 = tot_j1 + j1;
    tot_ele(tot_j1+1:tot_j1+j1,:) = finele-[ones(j1,1),zeros(j1,1),zeros(j1,1),zeros(j1,1)];
    tot_j1 = tot_j1 + j1;
    tot_y = tot_ele;
    j1 = j1 *3;
    
    tot_ele(tot_j1+1:tot_j1+j1,:)= tot_y + [zeros(j1,1),ones(j1,1),zeros(j1,1),zeros(j1,1)] ;
    tot_j1 = tot_j1 + j1;
    tot_ele(tot_j1+1:tot_j1+j1,:)= tot_y - [zeros(j1,1),ones(j1,1),zeros(j1,1),zeros(j1,1)] ;
    tot_j1 = tot_j1 + j1;
    tot_z = tot_ele;
    j1 = j1 *3;
    tot_ele(tot_j1+1:tot_j1+j1,:)= tot_z + [zeros(j1,1),zeros(j1,1),ones(j1,1),zeros(j1,1)] ;
    tot_j1 = tot_j1 + j1;
    tot_ele(tot_j1+1:tot_j1+j1,:)= tot_z - [zeros(j1,1),zeros(j1,1),ones(j1,1),zeros(j1,1)] ;
    tot_j1 = tot_j1 + j1;
    
    for i =1:tot_j1
        u = tot_ele(i,1);
        v = tot_ele(i,2);
        w = tot_ele(i,3);
        frac_coor = [u;v;w];
        cart_coor = frac2cart(frac_coor,lattice_vector);
        
        ele_final(i,1)=cart_coor(1);
        ele_final(i,2)=cart_coor(2);
        ele_final(i,3)=cart_coor(3);
        ele_final(i,4)=tot_ele(i,4);
        
    end
    %{
    fprintf(fid,'%d\r\n',tot_j1);
    fprintf(fid,'ITEM: BOX BOUNDS xy xz yz pp pp pp\r\n');
    for i = 1:tot_j1
        if ele_final(i,4) == 1
            fprintf(fid,'Si %f %f %f \r\n',ele_final(i,1),ele_final(i,2),ele_final(i,3));
        elseif ele_final(i,4) == 2 || ele_final(i,4) == 3  || ele_final(i,4) == 5 || ele_final(i,4) == 6 || ele_final(i,4) == 9 || ele_final(i,4) == 12
             fprintf(fid,'O %f %f %f \r\n',ele_final(i,1),ele_final(i,2),ele_final(i,3));
        elseif ele_final(i,4) == 4 || ele_final(i,4) == 7
             fprintf(fid,'Al %f %f %f \r\n',ele_final(i,1),ele_final(i,2),ele_final(i,3));
        elseif ele_final(i,4) == 8
             fprintf(fid,'Mg %f %f %f \r\n',ele_final(i,1),ele_final(i,2),ele_final(i,3)); 
        elseif ele_final(i,4) == 10 || ele_final(i,4) == 13
             fprintf(fid,'H %f %f %f \r\n',ele_final(i,1),ele_final(i,2),ele_final(i,3)); 
        elseif ele_final(i,4) == 11
             fprintf(fid,'Na %f %f %f \r\n',ele_final(i,1),ele_final(i,2),ele_final(i,3));
        end

    end
    %}
    

    fprintf(fid,'ITEM: TIMESTEP\r\n');
    fprintf(fid,'%d\r\n',2000000+(hh-1)*20000);
    fprintf(fid,'ITEM: NUMBER OF ATOMS\r\n');
    fprintf(fid,'%d\r\n',tot_j1);
    fprintf(fid,'ITEM: BOX BOUNDS xy xz yz pp pp pp\r\n');
    fprintf(fid,'-8.5574977790000002e+00 2.4340118654000001e+01 0.0000000000000000e+00\r\n');
    fprintf(fid,'-8.4576727799999996e-01 1.7001832722000000e+01 -6.3260164330000004e+00\r\n');
    fprintf(fid,'2.3601948500000000e-01 2.0226561395000001e+01 0.0000000000000000e+00\r\n');
    fprintf(fid,'ITEM: ATOMS id type element x y z\r\n');
    for i = 1:tot_j1
        if ele_final(i,4) == 1
            fprintf(fid,'%d %d Si %f %f %f \r\n',i,ele_final(i,4),ele_final(i,1),ele_final(i,2),ele_final(i,3));
        elseif ele_final(i,4) == 2 || ele_final(i,4) == 3  || ele_final(i,4) == 5 || ele_final(i,4) == 6 || ele_final(i,4) == 9 || ele_final(i,4) == 12
             fprintf(fid,'%d %d O %f %f %f \r\n',i,ele_final(i,4),ele_final(i,1),ele_final(i,2),ele_final(i,3));
        elseif ele_final(i,4) == 4 || ele_final(i,4) == 7
             fprintf(fid,'%d %d Al %f %f %f \r\n',i,ele_final(i,4),ele_final(i,1),ele_final(i,2),ele_final(i,3));
        elseif ele_final(i,4) == 8
             fprintf(fid,'%d %d Mg %f %f %f \r\n',i,ele_final(i,4),ele_final(i,1),ele_final(i,2),ele_final(i,3)); 
        elseif ele_final(i,4) == 10 || ele_final(i,4) == 13
             fprintf(fid,'%d %d H %f %f %f \r\n',i,ele_final(i,4),ele_final(i,1),ele_final(i,2),ele_final(i,3)); 
        elseif ele_final(i,4) == 11
             fprintf(fid,'%d %d Na %f %f %f \r\n',i,ele_final(i,4),ele_final(i,1),ele_final(i,2),ele_final(i,3));
        end

    end
    
    %}
    
end


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

    frac_coor = inv(lattice_vector')*coor_cart;   %注意使用转置矩阵的逆矩阵 inv(lattice_vector')*coor_cart;
    
end

function coor_frac = frac2cart(frac_cart,lattice_vector)

    coor_frac = lattice_vector'*frac_cart;   
    
end
