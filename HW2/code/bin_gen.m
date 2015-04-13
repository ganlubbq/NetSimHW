clear all;
close all;
clc;

%% Implement the generation of a Binomial rv in the three ways we saw in
% class (CDF inversion, using a sequence of n Bernoulli variables,
% using geometric strings of zeros), and then compare the time
% it takes to produce a large number of iid variates

%% BIN(n, p)

n = 20;
p = 0.3;
experiments = 1000000;
profile on

%% CDF Inversion

rng('default');
X_inv = bin_inv_generator(n, p, experiments);
err_inv = mean(X_inv) - n*p;

%% Series of Bernoulli

rng('default');
X_ber = bin_ber_generator(n, p, experiments);
err_ber = mean(X_ber) - n*p;


%% Strings of zeros of length G(p)

rng('default');
X_geo = bin_geo_generator(n, p, experiments);
err_geo = mean(X_geo) - n*p;


