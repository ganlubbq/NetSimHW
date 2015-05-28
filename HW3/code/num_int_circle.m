function [ area ] = num_int_circle( r, D, gl )
% r as in GeRaF
% D as in GeRaF
% gl is a matrix with points and weights of GQR

c = (r - D + 1)/2;
m = (r + D - 1)/2;
area = 0;
for i = 1:length(gl)
   x = gl(i, 1);
   w = gl(i, 2);
   a = c*x + m;
   acos_num = a^2 + D^2 - 1;
   acos_den = 2*a*D;
   area = area + 2*c*w*a*acos(acos_num/acos_den);
end
end

