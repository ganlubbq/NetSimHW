clear all;
close all;
clc;

%% Poisson(lambda)
lambda = 100;

experiments = 100000;
begin = 740;
step = 1;
limit = 2000;
time_inv = zeros(limit/step, 1);
time_exp = zeros(limit/step, 1);
time_prod = zeros(limit/step, 1);
k = 1;

for lambda = begin:step:limit
    
    %% CDF Inversion
    rng('default');
    
    tic;
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
        end
        X_inv(j) = i;
    end
    time_inv(k) = toc;
    disp(strcat('Iteration with lambda=', num2str(lambda), ' time inv=', num2str(time_inv(k))))
    
    %% Poisson as number of arrivals in [0,1] with exp(lambda) interarrival time
    
    rng('default');
    
    tic;
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
           
        end
        X_exp(j) = X;
    end
    time_exp(k) = toc;
    disp(strcat('Iteration with lambda=', num2str(lambda), ' time exp= ', num2str(time_exp(k))))
    
    
    %% The same as before, note that sum(exp(lambda))<1 <=> sum(-1/lambda * ln(U))<1 <=>  ln(prod(U)) > -lambda <=> prod(U) > exp(-lambda)
    
    rng('default');
    tic;
    bound = exp(-lambda);
    X_prod = zeros(experiments, 1);
    for j = 1:experiments
        X_prod(j) = 0;
        prd = rand();
        while prd >= bound
            X_prod(j) = X_prod(j) + 1;
            prd = prd*rand();
        end 
    end
    time_prod(k) = toc;
    
    disp(strcat('Iteration with lambda=', num2str(lambda), ' time prod= ', num2str(time_prod(k))))
    
    k = k+1;
end

figure
scatter(begin:step:limit, time_inv, 10)
hold on
scatter(begin:step:limit, time_exp, 10)
hold on
scatter(begin:step:limit, time_prod, 10)
xlabel('lambda')
ylabel('execution time [s]')
legend('CDF inv', 'Exponential interarrivals', 'Uniform product')
title('Time required to generate N = 10^5 Poisson rv')


