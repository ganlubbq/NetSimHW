function [ beta ] = circle_int_func( x, y )
% GeRaF paper, equation (5), returns beta
beta = 0.5*(pi - 2*asin(x/y) - 2 * x/y * sqrt(1- (x/y)^2));
end

