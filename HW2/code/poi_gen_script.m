clear all;
close all;
clc;

%% Implement the generation of a Poisson(lambda) rv in the three ways we saw in
% class (CDF inversion, using exp until sum > 1,
% using uniforms until product > e^(-lambda)), and then compare the time
% it takes to produce a large number of iid variates

%% Poisson(lambda)
lambda = 100;
%profile on

experiments = 100000;
begin = 100;
step = 1;
limit = 100;
time_inv = zeros(limit/step, 1);
time_exp = zeros(limit/step, 1);
time_prod = zeros(limit/step, 1);
%iter_inv = zeros(limit/step, 1);
%iter_exp = zeros(limit/step, 1);
%iter_prod = zeros(limit/step, 1);

for lambda = begin:step:limit
    
    %% CDF Inversion
    rng('default');
    
    tic;
    
    %iter = 0;
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
            %iter = iter + 1;
        end
        X_inv(j) = i;
    end
    %iter_inv(lambda/step) = iter;
    time_inv(lambda/step) = toc;
    disp(strcat('Iteration with lambda=', num2str(lambda), ' time inv=', num2str(time_inv(lambda/step))))
    
    
    
    %% Poisson as number of arrivals in [0,1] with exp(lambda) interarrival time
    
    rng('default');
    
    tic;
    %iter = 0;
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
            %iter = iter + 1;
        end
        X_exp(j) = X;
    end
    %iter_exp(lambda/step) = iter;
    time_exp(lambda/step) = toc;
    disp(strcat('Iteration with lambda=', num2str(lambda), ' time exp= ', num2str(time_exp(lambda/step))))
    % The same as before, note that sum(exp(lambda))<1 <=> sum(-1/lambda * ln(U))<1 <=>  ln(prod(U)) > -lambda <=> prod(U) > exp(-lambda)
    
    
    rng('default');
    tic;
    %iter = 0;
    bound = exp(-lambda);
    X_prod = zeros(experiments, 1);
    for j = 1:experiments
        X_prod(j) = 0;
        prod = rand();
        
        while (prod >= bound)
            X_prod(j) = X_prod(j) + 1;
            prod = prod*rand();
            %iter = iter + 1;
        end 
    end
    %iter_prod(lambda/step) = iter;
    time_prod(lambda/step) = toc;
    
    disp(strcat('Iteration with lambda=', num2str(lambda), ' time prod= ', num2str(time_prod(lambda/step))))
    
end

figure
scatter(begin:step:limit, iter_inv, 10)
hold on
scatter(begin:step:limit, iter_exp, 20)
hold on
scatter(begin:step:limit, iter_prod, 30)
xlabel('lambda')
ylabel('iterations')
legend('CDF inv', 'Exponential interarrivals', 'Uniform product')
title('Iterations required to generate N = 1000 Poisson rv')


