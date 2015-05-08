%% Montecarlo Simulation of capture probability in ALOHA networks

clear
close all
clc
rng default

% Data
sigma_dB = 1; %std dev of lognormal shadowing in dB
sigma_sh = sigma_dB * 0.1 * log(10);
eta = 2; % free space
n = 10; % total number of users, at least 2
b = 6; %dB
b_lin = 10^(b/10);

% The SIR is given by R0e^xi0 / (sum Rie^xii (r0/ri)^eta)

numsim = 200000;
SIR = zeros(1, numsim);

for i = 1:numsim
    % Random variables generation for the channel
    shd = exp(randn(1, n)*sigma_sh); % n lognormal shadowing
    R2 = 1*sqrt(-2*log(rand(1, n))); % n rayleigh with sigma = 1
    
    % Random distance from the BS of n users
    % CDF inversion
    r = sqrt(rand(1, n));
    
    % Compute SIR
    SIR(i) = (shd(1)*R2(1)^2)/(sum(R2(2:end).^2.*shd(2:end).*(r(1)./r(2:end)).^eta));
    
end

SIR_sorted = sort(SIR);
percentile = 99;
SIR_sorted = SIR_sorted(1:round(percentile/100*length(SIR_sorted)));
%figure, histogram(SIR_sorted)
disp(median(SIR));

captures = length(find(SIR > b_lin));
p_captures = captures/numsim;
disp(p_captures);
