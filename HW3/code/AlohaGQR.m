%% GQR for Cn
gh = gaussher20;
gl = gaussleg60;

sigma_dB = 8; % std dev of lognormal shadowing in dB
sigma = sigma_dB * 0.1 * log(10);
eta = 4; % indoor?
max_user = 30;
cn_gauss = zeros(30, 2);
i = 1;
for b = 10.^([6, 10]./10)
    for n = 1:30
        temp = 0;
        for i1 = 1:length(gh)
            for i2 = 1:length(gl)
                I = 0;
                for i3 = 1:length(gh)
                    for i4 = 1:length(gl)
                        I =  I + gh(i3, 2)/sqrt(pi) * ... % third integral
                            0.5*(gl(i4, 1)+1)*gl(i4, 2)/... % numerator of fourth integral
                            (1 + b* ...
                            exp(sqrt(2)*sigma*(gh(i3, 1) - gh(i1, 1)))...
                            *((gl(i4, 1)+1)/(gl(i2, 1)+1))^(-eta)); % denominator of fourth integral
                    end
                end
                
                temp = temp + ...
                    gh(i1, 2)/sqrt(pi)* ... % first integral
                    n*0.5*(gl(i2, 1)+1)*gl(i2, 2)* ... %second integral
                    I^(n-1); % last term
            end
        end
        cn_gauss(n, i)  =temp;
    end
    i = i +1;
end

figure, plot(1:30, cn_gauss), hold on, plot(1:30, cnmean1), hold on, plot(1:30, cnmean)

G = linspace(0.1, 30, 50).';
% create poisson probabilities
poipr = zeros(length(G), max_user);
for n = 1:max_user
    poipr(:, n) = G.^n .* exp(-G) ./ factorial(n);
end

for k = 1:length(G)
            throughput(k) = poipr(k, :)*cn_gauss(:, 1);
end

figure, plot(G, throughput)