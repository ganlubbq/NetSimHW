function [ ci_boot ] = bootstrap_mean( data, gamma, r0 )
% Bootstrap algorithm for ci for the mean

R = ceil(2*r0/(1-gamma)) - 1;
mean_R = zeros(R, 1);
for r = 1:R
    x_r = datasample(data, length(data)); % draw n number with replacement
    mean_R(r) = mean_est(x_r);
end
mean_R = sort(mean_R);
ci_boot = [mean_R(r0), mean_R(R+1-r0)];

end

