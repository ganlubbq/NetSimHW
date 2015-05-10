%% Montecarlo Simulation of capture probability in cellular networks

clear
close all
clc
rng default

% Data
sigma_dB = 1; %std dev of lognormal shadowing in dB
sigma_sh = sigma_dB * 0.1 * log(10);
eta = 2; % free space
n = 6; % max number of possible interferers in a reuse-3 scheme
D = 3; % distance between the center of 2 interfering cells in a reuse-3 scheme
xD = 3 * cos(pi/6);
yD = 3 * sin(pi/6);
b = 6; %dB
b_lin = 10^(b/10);

% The SIR is given by R0e^xi0 / (sum Rie^xii (r0/ri)^eta)

numsim = 200000;
SIR = zeros(numsim, n+1);

for i = 1:numsim
    % Compute quantities for n+1 users
    % Random variables generation for the channel
    shd = exp(randn(1, n+1)*sigma_sh); % n lognormal shadowing
    R2 = 1*sqrt(-2*log(rand(1, n+1))); % n rayleigh with sigma = 1
    
    % Random distance from the BS of the first users
    point1 = hexauni(1);
    r(1) = sqrt(point1(1)^2+point1(2)^2);
    
    % Random distance from the BS of the interferers
    pointn = hexauni(n);
    r(2:n+1) = sqrt((xD+pointn(:, 1)).^2 + (yD+pointn(:, 2)).^2);
    
    % Compute SIR for n from 0 to 6
    for numinter = 1:6
        SIR(i, numinter+1) = (shd(1)*R2(1)^2)/(sum(R2(2:numinter+1).^2.*shd(2:numinter+1).*(r(1)./r(2:numinter+1)).^eta));
    end
    SIR(i, 1) = b_lin + 1; % this should be obviously infinite, but since we are
    % interested in the probability of being greater than a threshold set
    % it in such a way that the comparison yields 1 in every case
    
end

SIR_sorted = sort(SIR);
percentile = 99;
SIR_sorted = SIR_sorted(1:round(percentile/100*length(SIR_sorted)));
%figure, histogram(SIR_sorted)
disp(median(SIR));

