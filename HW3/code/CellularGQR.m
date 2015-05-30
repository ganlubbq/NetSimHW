% CellularGQR

load('GQR.mat');
gh = gaussher20;
gl = gaussleg60;

R0 = 0.91;
sigma_dB = 8; %std dev of lognormal shadowing in dB
sigma_sh = sigma_dB * 0.1 * log(10);
eta = 4; % free space
n = 6; % max number of possible interferers in a reuse-3 scheme
N_factor = [1, 3, 4, 7];
% angle of an interfering cell (note that they are symmetric)
R1_vec = [R0, 2, 2 + sqrt(3)/2, sqrt(13)];
R2_vec = R1_vec + 2;
b_vec = [6, 10];
alpha = linspace(0.00001, 1, 50); % activity of the users in interfering cells
p_succ_alphaGQR = zeros(length(alpha), length(b_vec), length(N_factor));

for reuse_index = 1:length(N_factor)
    N = N_factor(reuse_index);
    fprintf('Reuse factor = %d \n', N);
    R1 = R1_vec(reuse_index);
    R2 = R2_vec(reuse_index);
    Rs = (R2+R1)/2;
    Rd = (R2-R1)/2;
    for b_index = 1:length(b_vec)
        b_lin = 10^(b_vec(b_index)/10);
        ps = zeros(1, length(alpha));
        for i1 = 1:length(gh)
            x1 = gh(i1, 1);
            w1 = gh(i1, 2);
            for i2 = 1:length(gl)
                x2 = gl(i2, 1);
                w2 = gl(i2, 2);
                inner_int = 0;
                inner_int2 = 0;
                for i3 = 1:length(gh)
                    x3 = gh(i3, 1);
                    w3 = gh(i3, 2);
                    for i4 = 1:length(gl)
                        x4 = gl(i4, 1);
                        w4 = gl(i4, 2);
                        int1 = w3/sqrt(pi);
                        numint2 = 2*w4*(Rd*x4+Rs)*Rd;
                        squarediff = R2^2 - R1^2;
                        etaratio = ((Rd*x4+Rs)/(R0/2*x2 + R0/2))^(-eta);
                        denint2 = squarediff * (1 + b_lin*exp(sqrt(2)*sigma_sh*(x3-x1))*etaratio);
                        inner_int2 = inner_int2 + int1*numint2/denint2;
                        inner_int = inner_int + int1* ... % first integral
                            2*w4*(Rd*x4 + Rs) * Rd / ... % numerator of second integral
                            ( ... % denominator of second integral
                            (R2^2-R1^2)*...
                            (1+b_lin*exp(sqrt(2)*sigma_sh*(x3-x1))* ...
                            ((Rd*x4 + Rs)/(R0/2*x2+R0/2))^(-eta)) ...
                            );
                    end
                end
                bino_part = (alpha.*inner_int + 1-alpha).^6;
                ps = ps + w1/sqrt(pi)*...
                    w2 * 0.5*(x2+1).*...
                    bino_part;
            end
        end
        p_succ_alphaGQR(:, b_index, reuse_index) = ps;
    end
    
end

%% Plot

for b_index = 1:length(b_vec)
    figure, hold on
    title(strcat('b= ', num2str(b_vec(b_index)), ' dB'))
    for reuse_index = 1:length(N_factor)
        plot(alpha, 1 - p_succ_alphaGQR(:, b_index, reuse_index), 'DisplayName', strcat('GQR, N = ', num2str(N_factor(reuse_index))))
        hold on
        errorbar(alpha, p_out_alpha(:, b_index, reuse_index), ci_out_alpha(:, b_index, reuse_index),'DisplayName', strcat('N = ', num2str(N_factor(reuse_index))));
        hold on
        legend('-DynamicLegend')
        hold on
    end
    grid on, xlabel(strcat('Average activity of the interfering users \alpha, for b = ', num2str(b_vec(b_index)))),
    ylabel('P_{outage}')
end