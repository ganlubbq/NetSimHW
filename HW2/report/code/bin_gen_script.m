clear all;
close all;
clc;

%% BIN(n, p)

experiments = 100000;
begin = 20;
step = 20;
limit = 1000;
time_inv = zeros(limit/step, 5);
time_ber = zeros(limit/step, 5);
time_geo = zeros(limit/step, 5);

p_vec = [0.1, 0.2, 0.3, 0.4, 0.5];
%p_vec = [10^-9, 10^-8, 10^-7, 10^-6, 10^-5];

for n = begin:step:limit
    for k = 1:5
        p = p_vec(k);
        
        %% CDF Inversion
        rng('default');
        tic;
        X_inv = zeros(experiments, 1);
        for j = 1:experiments
            
            U = rand();
            c = p/(1-p);
            pr = (1-p)^n;
            if (pr == 0)
                return;
            end
            F = pr;
            i = 0;
            while(U >= F)
                pr = c*(n - i)*pr/(i + 1);
                F = F + pr;
                i = i + 1;
            end
            X_inv(j) = i;
            
        end
        time_inv(floor(n/step), k) = toc;
        disp(strcat('Iteration with n=', num2str(n), ' probability =', num2str(p), ' time inv=', num2str(time_inv(floor(n/begin), k))))
        
        %% Series of Bernoulli
        
        rng('default');
        tic;
        X_ber = zeros(experiments, 1);
        for j = 1:experiments
            
            X = 0;
            u_vec = rand(n, 1);
            for i = 1:n
                %u = rand();
                if(u_vec(i) < p)
                    X = X + 1;
                end
            end
            X_ber(j) = X;
            
        end
        time_ber(n/step, k) = toc;
        
        disp(strcat('Iteration with n=', num2str(n), ' probability =', num2str(p), ' time ber=', num2str(time_ber(floor(n/begin), k))))
        
        %% Strings of zeros of length G(p)
        
        rng('default');
        tic
        X_geo = zeros(experiments, 1);
        for j = 1:experiments
            %Generation of a geometric rv
            G = floor(log(rand())/log(1-p));
            i = G + 1; % G zeros and a 1
            X = 0;
            %if the string of zeros and the last 1 are longer less than n
            %then there's at least one success in the n trials
            while(i <= n)
                X = X + 1;
                G = floor(log(rand())/log(1-p));
                i = i + G + 1; % another string of G zeros and a 1
            end
            X_geo(j) = X;
        end
        time_geo(n/step, k) = toc;
        
        disp(strcat('Iteration with n=', num2str(n), ' probability =', num2str(p), ' time geo=', num2str(time_geo(floor(n/begin), k))))
        
    end
end

% some plots
figure, plot(begin:step:limit, time_inv)
title('Time to generate 1000 RV with CDF INV')
legend('0.1', '0.2', '0.3', '0.4', '0.5')
figure, plot(begin:step:limit, time_ber)
title('Time to generate 1000 RV with Bernoullis')
legend('0.1', '0.2', '0.3', '0.4', '0.5')
figure, plot(begin:step:limit, time_geo)
title('Time to generate 1000 RV with geometric strings')
legend('0.1', '0.2', '0.3', '0.4', '0.5')

figure
for i = 1:5
    scatter(time_inv(:, i), time_geo(:, i), 20, 'filled', 'DisplayName', strcat('p = ', num2str(p_vec(i))))
    legend('-DynamicLegend')
    hold on
    ylabel('Time required for Geometric strings method [s]')
    xlabel('Time required for CDF INV method [s]')
    %axis([0.024, 0.032, 0.009, 0.018])
end


figure
for i = 1:5
    scatter(time_inv(:, i), time_ber(:, i), 20, 'filled', 'DisplayName', strcat('p = ', num2str(p_vec(i))));
    legend('-DynamicLegend')
    hold on
    ylabel('Time required for Bernoulli trials method [s]')
    xlabel('Time required for CDF INV method [s]')
end

figure
for i = 1:5
    scatter(time_geo(:, i), time_ber(:, i), 20, 'filled', 'DisplayName', strcat('p = ', num2str(p_vec(i))));
    hold on
    legend('-DynamicLegend')
    hold on
    
end
plot(0:4, 0:4, 'LineWidth', 1.5, 'DisplayName', 'time_{geo} = time_{ber}')
hold on
legend('-DynamicLegend')
ylabel('Time required for Bernoulli trials method [s]')
xlabel('Time required for Geometric strings method [s]')
ylim([0,3.5])



figure, surf(time_ber, time_inv, time_geo)
ylabel('CDF INV method')
xlabel('Bernoulli trials method')
zlabel('Geometric strings method')

