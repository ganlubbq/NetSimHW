%% Montecarlo Simulation of capture probability in ALOHA networks

clear
close all
clc
rng default

% Data
sigma_dB = 8; %std dev of lognormal shadowing in dB
sigma_sh = sigma_dB * 0.1 * log(10);
eta = 4; % indoor?

% The SIR is given by R0e^xi0 / (sum Rie^xii (r0/ri)^eta)
max_user = 30;
numsim = 10^6;
G = linspace(0.1, 30, 50).';
b = [6, 10];
cn = zeros(max_user, numsim, length(b));
throughput = zeros(length(G), numsim, length(b));

% create poisson probabilities
poipr = zeros(length(G), max_user);
for n = 1:max_user
    poipr(:, n) = G.^n .* exp(-G) ./ factorial(n);
end

for b_ind = 1:length(b)
    b_lin = 10^(b(b_ind)/10);
    for i = 1:numsim
        if (mod(i, 1000) == 0)
            fprintf('b = %d, iter = %d \n', b_lin, i);
        end
        % Random variables generation for the channel
        shd_complete = exp(randn(1, max_user)*sigma_sh); % n lognormal shadowing
        R2_complete = 1*sqrt(-2*log(rand(1, max_user))); % n rayleigh with sigma = 1
        % Random distance from the BS of n users
        % CDF inversion
        r_complete = sqrt(rand(1, max_user));
        cn(1, i, b_ind) = 1;
        for j = 2:max_user
            shd = datasample(shd_complete, j, 'Replace', false);
            R2 = datasample(R2_complete, j, 'Replace', false);
            r = datasample(r_complete, j, 'Replace', false);
            % Compute SIR
            SIR = (shd(1)*R2(1)^2)/(sum(R2(2:end).^2.*shd(2:end).*(r(1)./r(2:end)).^eta));
            cn(j, i, b_ind) = j*(SIR >= b_lin);
        end
        for k = 1:length(G)
            throughput(k, i, b_ind) = poipr(k, :)*cn(:, i, b_ind);
        end
        
    end
    % average and ci
    cnmean(b_ind, :) = sum(cn(:, :, b_ind), 2)/numsim;
    Smean(b_ind, :) = sum(throughput(:, :, b_ind), 2)/numsim;
end

save(strcat('completeAlohaMatrix', num2str(b)), 'cn', 'numsim', 'b', 'Smean', 'cnmean');

%% Plot 
load('completeAlohaMatrix6  8.mat')

cnmean6 = cnmean(1, :);
Smean6 = Smean(1, :);
cnstd6 = std(cn(:, :, 1), 0, 2);

load('completeAlohaMatrix10.mat')
cnmean10 = cnmean;
Smean10 = Smean;
cnstd10 = std(cn(:, :, 1), 0, 2);

figure, errorbar(1:30, cnmean6, 1.96*cnstd6/sqrt(numsim)), hold on,
errorbar(1:30, cnmean10, 1.96*cnstd10/sqrt(numsim)),
legend('b = 6', 'b = 10'), xlabel('n'), ylabel('C_n'), grid on,
xlim([0, 31])

figure, plot(G, Smean6, G, Smean10), legend('b = 6', 'b = 10'),
xlabel('G'), ylabel('S'), grid on,
xlim([0, 31])

%figure, plot(1:max_user, cnmean)
%figure, plot(G, Smean)
