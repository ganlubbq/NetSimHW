% CellularGQR

load('GQR.mat');
gh = gaussher20;
gl = gaussleg60;

% Data
sigma_dB = 8; %std dev of lognormal shadowing in dB
sigma_sh = sigma_dB * 0.1 * log(10);
eta = 4; % free space
n = 6; % max number of possible interferers in a reuse-3 scheme
N = 3;
D = sqrt(3*N); % distance between the center of 2 interfering cells in a reuse-3 scheme
b = 6; %dB
b_lin = 10^(b/10);
%alpha = linspace(0.00001, 1, 50); % activity of the users in interfering cells
alpha = 1;
alpha = alpha(:);
R0 = 0.91;
R1 = 2; % reuse-3
R2 = 4;
Rs = (R2+R1)/2;
Rd = (R2-R1)/2;

ps = 0;
for i1 = 1:length(gh)
    x1 = gh(i1, 1);
    w1 = gh(i1, 2);
    for i2 = 1:length(gl)
        x2 = gl(i2, 1);
        w2 = gl(i2, 2);
        inner_int = 0;
        for i3 = 1:length(gh)
            x3 = gh(i3, 1);
            w3 = gh(i3, 2);
            for i4 = 1:length(gl)
                x4 = gl(i4, 1);
                w4 = gl(i4, 2);
                inner_int = inner_int + w3/sqrt(pi)* ... % first integral
                    2*w4*(Rd*x4 + Rs) * Rd/ ... % numerator of second integral
                    ( ... % denominator of second integral
                    (R2-R1)^2*(1+b_lin*exp(sqrt(2)*sigma*(x3-x1)))* ...
                    ((Rd*x4 + Rs)/(R0/2*x2+R0/2))^(-eta) ...
                    );
            end
        end
        bino_part = (alpha.*inner_int + 1-alpha).^6;
        ps = ps + w1/sqrt(pi)*...
            w2 * 0.5*(x2+1).*...
            bino_part;
    end
end