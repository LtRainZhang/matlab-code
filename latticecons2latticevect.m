%matlab convert lattice constants to lattice vector
%convert (a,b,c,alfa,beta,gam) to [Ax, Bx, Cx; Ay, By,Cy; Az, Bz, Cz]=vector(aa  ;   bb;   cc)
pi = 3.1415926;
a = 9.832;
b = 9.832;
c = 10.8108;
alfa = 90;
beta = 90;
gam = 120;
alfa = alfa/180*pi;%degree converted to radia
beta = beta/180*pi;
gam = gam/180*pi;
aa = a * [ 1, 0, 0];
bb = b * [cos(gam),sin(gam),0];
cc = c * [cos(beta),(cos(alfa)-cos(beta)*cos(gam))/sin(gam), sqrt(1+2 * cos(alfa)*cos(beta)*cos(gam)-(cos(alfa))^2-(cos(beta))^2-(cos(gam))^2)/sin(gam)];

lattice_vector =[aa;bb;cc];

%(u,v,w) denoted fractional coordinateds ; (x,y,z) denoted cartesian coordinates

%convert (u,v,w) to (x,y,z)
frac_coor = [0.5;0.5;0.5];
cart_coor = lattice_vector * frac_coor;

%convert (x,y,z) to (u,v,w)
cart_coor2 = [1.376725800;    1.136294958;    0.643783140];
frac_coor2 = inv(lattice_vector) * (cart_coor2);

