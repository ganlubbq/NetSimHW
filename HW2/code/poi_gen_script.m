clear all;
close all;
clc;

%% Implement the generation of a Poisson(lambda) rv in the three ways we saw in
% class (CDF inversion, using exp until sum > 1,
% using uniforms until product > e^(-lambda)), and then compare the time
% it takes to produce a large number of iid variates

%% Poisson(lambda)
lambda = 100;
experiments = 1000000;
%profile on

%% CDF Inversion
rng('default');

tic;

X_inv = zeros(experiments, 1);
for j = 1:experiments
    
    U = rand();
    pr = exp(-lambda);
    F = pr;
    i = 0;
    while(U >= F)
        pr = lambda * pr / (i+1);
        F = F + pr;
        i = i + 1;
    end
    X_inv(j) = i;
    
end
err_inv = mean(X_inv) - lambda;

time_inv = toc;

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
err_exp = mean(X_exp) - lambda;

time_exp = toc;

%% The same as before, note that sum(exp(lambda))<1 <=> sum(-1/lambda * ln(U))<1 <=>  ln(prod(U)) > -lambda <=> prod(U) > exp(-lambda) 

rng('default');

tic;

X_prod = zeros(experiments, 1);
for j = 1:experiments
    
    X = 0;
    prod = rand();
    while (prod >= exp(-lambda))
        X = X + 1;
        prod = prod*rand();
    end
    X_prod(j) = X;
    
end
err_prod = mean(X_prod) - lambda;

time_prod = toc;
