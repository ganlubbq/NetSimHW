function [ ci_boot ] = bootstrap_var( data, gamma, r0 )
% Bootstrap algorithm for ci for the mean
% gamma is the confidence level
% r0 is a level of accuracy of the algorithm, tipically r0 = 50 for gamma = 0.95

R = ceil(2*r0/(1-gamma)) - 1;
var_R = zeros(R, 1);
for r = 1:R
    x_r = datasample(data, length(data)); % draw n number with replacement
    var_R(r) = var_est(x_r, 0);
end
var_R = sort(var_R);
ci_boot = [var_R(r0), var_R(R+1-r0)];

end
