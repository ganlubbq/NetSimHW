% First script for network simulation HW1

close all
clear all
clc

%% Uniform random variables

% reset RNG to Mersenne Twister with seed 0. MT periodicity is higher than
% the number of random variables needed in this experiment.
rng('default'); 
% Create a vector of 48 iid uniform(0,1) RV
lrv = 48;
v = rand(lrv, 1);

% Compute mean, std_dev and 95% ci for the mean
gamma = 0.95;
eta_u = norminv((1+gamma)/2, 0, 1);
m = mean_est(v);
s = sqrt(var_est(v, 0));
ci = m + [-eta_u*s/sqrt(lrv), eta_u*s/sqrt(lrv)];

N = 1000; % iterations

% generate indipendently 48*1000 random variables
step_sim = 1;
v_big = rand(N/step_sim, lrv);
data_matrix = zeros(N/step_sim, 4);
for i = step_sim:step_sim:N
    vi = v_big(i/step_sim, :);
    mi = mean_est(vi);
    % store mean
    data_matrix(i/step_sim, 1) = mi;
    si_2 = var_est(vi, 0);
    % store variance
    data_matrix(i/step_sim, 2) = si_2;
    % store lower and upper 95% ci
    data_matrix(i/step_sim, 3) = mi - eta_u*sqrt(si_2/lrv);
    data_matrix(i/step_sim, 4) = mi + eta_u*sqrt(si_2/lrv);
end

% sort according to the lower bound of ci intervals
data_matrix = sortrows(data_matrix, 3);

% find how many times the value of the true mean isn't in the 95% ci
true_mean = 0.5; % since random variables are U(0, 1)
lbover = find(data_matrix(:, 3) >= true_mean); % the lower bound is greater than the true mean
upbelow = find(data_matrix(:, 4) <= true_mean); % the upper bound is lower than the true mean
err_perc = (length(lbover) + length(upbelow))/N;
disp(err_perc*100);

figure
plot(step_sim:step_sim:N, data_matrix(:, 1), step_sim:step_sim:N, data_matrix(:, 3), step_sim:step_sim:N, data_matrix(:, 4))
hold on
plot(step_sim:step_sim:N, true_mean*ones(1, length(step_sim:step_sim:N)))
title('95 % confidence interval for 1000 iid U(0, 1)');
xlabel('Iterations')
ylabel('Probability')
legend('Sample mean', 'Lower bound of 95% ci', 'Upper bound of 95% ci', 'True mean', 'Location', 'NorthWest')


clear mi number_exp v_big vi si i

%% Normal random variables

% reset RNG to Mersenne Twister with seed 0. MT periodicity is higher than
% the number of random variables needed in this experiment.
rng('default'); 
% Create a vector of 48 iid normal(0,1) RV
lrv = 48;
v = randn(lrv, 1);
gamma = 0.95;
eta_n = tinv((1+gamma)/2, lrv-1);
% Compute mean, std_dev and 95% ci for the mean
m = mean_est(v);
s = sqrt(var_est(v, 0));
ci = m + [-eta_n*s/sqrt(lrv), eta_n*s/sqrt(lrv)];


% generate indipendently 48*1000 random variables
step_sim = 1;
v_big = randn(N/step_sim, lrv); 
data_matrix = zeros(N/step_sim, 4);
for i = step_sim:step_sim:N
    vi = v_big(i/step_sim, :);
    mi = mean_est(vi);
    % store mean
    data_matrix(i/step_sim, 1) = mi;
    si_2 = var_est(vi, 0);
    % store variance
    data_matrix(i/step_sim, 2) = si_2;
    % store lower and upper 95% ci
    data_matrix(i/step_sim, 3) = mi - eta_n*sqrt(si_2/lrv);
    data_matrix(i/step_sim, 4) = mi + eta_n*sqrt(si_2/lrv);
end

% sort according to the lower bound of ci intervals
data_matrix = sortrows(data_matrix, 3);

% find how many times the value of the true mean isn't in the 95% ci
true_mean = 0; % since random variables are U(0, 1)
lbover = find(data_matrix(:, 3) >= true_mean); % the lower bound is greater than the true mean
upbelow = find(data_matrix(:, 4) <= true_mean); % the upper bound is lower than the true mean
err_perc = (length(lbover) + length(upbelow))/N;
disp(err_perc*100);

figure
plot(step_sim:step_sim:N, data_matrix(:, 1), step_sim:step_sim:N, data_matrix(:, 3), step_sim:step_sim:N, data_matrix(:, 4))
hold on
plot(step_sim:step_sim:N, true_mean*ones(1, length(step_sim:step_sim:N)))
hold off
title('95 % confidence interval for 1000 iid N(0, 1)');
xlabel('Iterations')
ylabel('Probability')
legend('Sample mean', 'Lower bound of 95% ci', 'Upper bound of 95% ci', 'True mean', 'Location', 'NorthWest')


clear mi number_exp v_big vi si i
