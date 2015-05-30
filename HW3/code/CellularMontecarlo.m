%% Montecarlo Simulation of capture probability in cellular networks

%clear
close all
clc
rng default


% Data
numsim = 1000000;
sigma_dB = 8; %std dev of lognormal shadowing in dB
sigma_sh = sigma_dB * 0.1 * log(10);
eta = 4; % free space
n = 6; % max number of possible interferers in a reuse-3 scheme
N_factor = [1, 3, 4, 7];
% angle of an interfering cell (note that they are symmetric)
angle_cell = [0, pi/6, 0, acos(5/(2*sqrt(7)))];
b_vec = [6, 10];
alpha = linspace(0.00001, 1, 50); % activity of the users in interfering cells
p_out_alpha = zeros(length(alpha), length(b_vec), length(N_factor));
ci_out_alpha = zeros(length(alpha), length(b_vec), length(N_factor));
for reuse_index = 1:length(N_factor)
    N = N_factor(reuse_index);
    fprintf('Reuse factor = %d \n', N);
    D = sqrt(3.*N); % distance between the center of 2 interfering cells in a reuse-3 scheme
    ang = angle_cell(reuse_index);
    xD = D*cos(ang);
    yD = D*sin(ang);
    
    for b_index = 1:length(b_vec)
        poutagealpha = zeros(numsim, length(alpha));
        % The SIR is given by R0e^xi0 / (sum Rie^xii (r0/ri)^eta)
        b = b_vec(b_index);
        fprintf('Threshold = %d \n', b);
        b_lin = 10^(b/10);
        poutage = zeros(numsim, n+1);
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
        p_out_alpha(:, b_index, reuse_index) = mean(poutagealpha, 1);
        ci_out_alpha(:, b_index, reuse_index) = 1.96*std(poutagealpha, 0, 1)/sqrt(numsim);
        
    end
end

save('cellular_monte', 'p_out_alpha', 'ci_out_alpha', 'b_vec', 'N_factor');

% for b_index = 1:length(b_vec)
%     figure, hold on
%     title(strcat('b= ', num2str(b_vec(b_index)), ' dB'))
%     for reuse_index = 1:length(N_factor)
%         errorbar(alpha, p_out_alpha(:, b_index, reuse_index), ci_out_alpha(:, b_index, reuse_index),'DisplayName', strcat('N = ', num2str(N_factor(reuse_index))))
%         hold on
%         legend('-DynamicLegend')
%         hold on
%     end
%     grid on, xlabel(strcat('Average activity of the interfering users \alpha, for b = ', num2str(b_vec(b_index)))),
%     ylabel('P_{outage}')
% end
