%% Montecarlo Simulation of capture probability in cellular networks

%clear
close all
clc
rng default

% TODO numerical integration, vary the reuse scheme and the relative
% distance


% Data
sigma_dB = 8; %std dev of lognormal shadowing in dB
sigma_sh = sigma_dB * 0.1 * log(10);
eta = 4; % free space
n = 6; % max number of possible interferers in a reuse-3 scheme
N = 3;
D = sqrt(3*N); % distance between the center of 2 interfering cells in a reuse-3 scheme
xD = D * cos(pi/6);
yD = D * sin(pi/6);
b = 6; %dB
b_lin = 10^(b/10);
alpha = linspace(0.00001, 1, 50); % activity of the users in interfering cells

% The SIR is given by R0e^xi0 / (sum Rie^xii (r0/ri)^eta)

numsim = 1000;
poutage = zeros(numsim, n+1);
poutagealpha = zeros(numsim, length(alpha));

for i = 1:numsim
    % Compute quantities for n+1 users
    % Random variables generation for the channel
    shd_complete = exp(randn(1, n+1)*sigma_sh); % n lognormal shadowing
    R2_complete = 1*sqrt(-2*log(rand(1, n+1))); % n rayleigh with sigma = 1
    
    % Random distance from the BS of the first users
    point1 = hexauni(1);
    r(1) = sqrt(point1(1)^2+point1(2)^2);
    
    % Random distance from the BS of the interferers
    pointn = hexauni(n);
    r_complete = sqrt((xD+pointn(:, 1)).^2 + (yD+pointn(:, 2)).^2);
    
    % Compute SIR for n from 0 to 6
    for numinter = 1:6
        shd = datasample(shd_complete, numinter+1, 'Replace', false);
        R2 = datasample(R2_complete, numinter+1, 'Replace', false);
        r(2:numinter+1) = datasample(r_complete, numinter, 'Replace', false);
        SIR = (shd(1)*R2(1)^2)/(sum(R2(2:numinter+1).^2.*shd(2:numinter+1).*(r(1)./r(2:numinter+1)).^eta));
        poutage(i, numinter+1) = (SIR < b_lin);
    end
    poutage(i, 1) = 0; % no outage if just 1 user
    
    % Compute mean poutage for each alpha
    po = 0;
    max_fac = factorial(n);
    for numinter = 0:6
        po = po + (max_fac/(factorial(n-numinter)*factorial(numinter))).* ...
            (1 - alpha).^(n - numinter).*alpha.^(numinter).*poutage(i, numinter+1);
    end
    poutagealpha(i, :) = po;
    
end

pmeanout = mean(poutage, 1);
pmeanoutalpha = mean(poutagealpha, 1);

figure, plot(alpha, pmeanoutalpha), grid on, xlabel('Average activity of the interfering users \alpha'),
ylabel('P_{outage}')

% SIR_sorted = sort(SIR);
% percentile = 99;
% SIR_sorted = SIR_sorted(1:round(percentile/100*length(SIR_sorted)));
% %figure, histogram(SIR_sorted)
% disp(median(SIR));

