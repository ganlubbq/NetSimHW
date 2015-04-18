clear all;
close all;
clc;

%% Iteration counter for Poisson(lambda), performed in a separated script since 
% it would affect the computation of execution times

experiments = 100000;
begin = 10;
step = 10;
limit = 740;
iter_inv = zeros(limit/step, 1);
iter_exp = zeros(limit/step, 1);
iter_prod = zeros(limit/step, 1);
k = 1;

for lambda = begin:step:limit
    
    %% CDF Inversion
    rng('default');
    
    iter = 0;
    X_inv = zeros(experiments, 1);
    for j = 1:experiments
        pr = exp(-lambda);
        U = rand();
        F = pr;
        i = 0;
        while(U >= F)
            pr = lambda * pr / (i+1);
            F = F + pr;
            i = i + 1;
            iter = iter + 1;
        end
        X_inv(j) = i;
    end
    iter_inv(k) = iter;
    disp(strcat('Iteration with lambda=', num2str(lambda), ' time inv=', num2str(iter_inv(k))))
    
    %% Poisson as number of arrivals in [0,1] with exp(lambda) interarrival time
    
    rng('default');
    iter = 0;
    X_exp = zeros(experiments, 1);
    for j = 1:experiments
        % Generation of an exp(lambda) rv
        E = -1/lambda * log(rand()); % interarrival times
        i = E; % time of last arrival
        X = 0; % number of arrivals (which is the poisson of intensity lambda*t, I set t = 1)
        % if the time of last arrival is greater than 1 we're done
        
        while(i <= 1)
            X = X + 1;
            E = -1/lambda * log(rand());
            i = i + E; % next arrival time
            iter = iter + 1;
        end
        X_exp(j) = X;
    end
    iter_exp(k) = iter;
    disp(strcat('Iteration with lambda=', num2str(lambda), ' iter exp= ', num2str(iter_exp(k))))
    
    
    %% The same as before, note that sum(exp(lambda))<1 <=> sum(-1/lambda * ln(U))<1 <=>  ln(prod(U)) > -lambda <=> prod(U) > exp(-lambda)
    
    rng('default');
    iter = 0;
    bound = exp(-lambda);
    X_prod = zeros(experiments, 1);
    for j = 1:experiments
        X_prod(j) = 0;
        prd = rand();
        while prd >= bound
            X_prod(j) = X_prod(j) + 1;
            prd = prd*rand();
            iter = iter + 1;
        end 
    end
    iter_prod(k) = iter;
    
    disp(strcat('Iteration with lambda=', num2str(lambda), ' iter prod= ', num2str(iter_prod(k))))
    
    k = k+1;
end

figure
scatter(begin:step:limit, iter_inv, 5)
hold on
scatter(begin:step:limit, iter_exp, 10)
hold on
scatter(begin:step:limit, iter_prod, 20)
xlabel('lambda')
ylabel('execution time [s]')
legend('CDF inv', 'Exponential interarrivals', 'Uniform product')
title('Time required to generate N = 10^5 Poisson rv')


