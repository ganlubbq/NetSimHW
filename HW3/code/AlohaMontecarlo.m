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
numsim = 10^7;
pcap = zeros(max_user, numsim);

for b = [6, 8]
    disp(b)
    b_lin = 10^(b/10);
    for i = 1:numsim
        % Random variables generation for the channel
        shd_complete = exp(randn(1, max_user)*sigma_sh); % n lognormal shadowing
        R2_complete = 1*sqrt(-2*log(rand(1, max_user))); % n rayleigh with sigma = 1
        % Random distance from the BS of n users
        % CDF inversion
        r_complete = sqrt(rand(1, max_user));
        pcap(1, i) = 1;
        for j = 2:max_user
            shd = datasample(shd_complete, j, 'Replace', false);
            R2 = datasample(R2_complete, j, 'Replace', false);
            r = datasample(r_complete, j, 'Replace', false);
            % Compute SIR
            SIR = (shd(1)*R2(1)^2)/(sum(R2(2:end).^2.*shd(2:end).*(r(1)./r(2:end)).^eta));
            pcap(j, i) = (SIR >= b_lin);
        end
    end
    % average and ci
    % pcmean = sum(pcap, 2)/numsim;
    pcmean2 = pcmean.*(1:1:max_user).';
    save(strcat('completeAlohaMatrix', num2str(b)), 'pcap', 'numsim', 'b');
    save(strcat('pmean', num2str(b)), 'pcmean2');
end

