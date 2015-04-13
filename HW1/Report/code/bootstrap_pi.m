function [ pi_boot ] = bootstrap_pi( data, gamma, r0 )
% Bootstrap algorithm for prediction intervals

alpha = 1 - gamma;
R = ceil(2*r0/(1-gamma)) - 1;
pi = zeros(R, 2);
n = length(data);
for r = 1:R
    x_r = datasample(data, length(data)); % draw n number with replacement
    x_r = sort(x_r);
    pi(r, 1) = x_r(floor((n+1)*alpha/2));
    pi(r, 2) = x_r(ceil((n+1)*(1 - alpha/2)));
    
end
pi_boot = [mean_est(pi(:, 1)), mean_est(pi(:, 2))];

end

