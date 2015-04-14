clear all;
close all;
clc;

%% Implement the generation of a Poisson(lambda) rv in the three ways we saw in
% class (CDF inversion, using exp until sum > 1,
% using uniforms until product > e^(-lambda)), and then compare the time
% it takes to produce a large number of iid variates

%% Poisson(lambda)
lambda = 100;
experiments = 10000;
%profile on

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
%err_inv = mean(X_inv) - lambda;

time_inv = toc;
disp(time_inv);
figure, histogram(X_inv);

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
%err_exp = mean(X_exp) - lambda;

time_exp = toc;
disp(time_exp);
figure, histogram(X_exp);
%% The same as before, note that sum(exp(lambda))<1 <=> sum(-1/lambda * ln(U))<1 <=>  ln(prod(U)) > -lambda <=> prod(U) > exp(-lambda)

rng('default');

tic;

bound = exp(-lambda);
X_prod = zeros(experiments, 1);
for j = 1:experiments
    
    %X_prod(j) = 0;
    prod = 1;
    while (prod >= bound)
        prod = prod*rand();
        X_prod(j) = X_prod(j) + 1;
    end
    X_prod(j) = X_prod(j) - 1;
    
end
%err_prod = mean(X_prod) - lambda;

time_prod = toc;
disp(time_prod);
figure, histogram(X_prod);

