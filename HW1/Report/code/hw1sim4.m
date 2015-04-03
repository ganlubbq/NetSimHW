% Script for ex 4 HW1 Network Simulation

close all;
clear all;
clc;

%% Uniform random variables 

% reset RNG to Mersenne Twister with seed 0. MT periodicity is higher than
% the number of random variables needed in this experiment.
rng('default');

% true mean and std_dev for a U[0, 1] rv
true_mean = 0.5;
true_var = ((1 - 0)^2/12);

N = 10000; % n upper limit

step = 5; 
data_matrix = zeros(N/step, 4);
% 
for n = step:step:N
    % generate indipendently n random variables
    v = rand(n, 1);
    % Compute mean, std_dev and 95% ci for the mean
    m = mean_est(v);
    s_2 = var_est(v, 0);
    % this formula holds if the dataset is big enough (CLT), not for small
    % n
    ci_mean = m + [-1.96, 1.96] *sqrt(s_2/n);
    % store data
    data_matrix(n/step, :) = [m, s_2, ci_mean];
end

% compare true mean and estimated one
figure
subplot(2, 1, 1)
plot(step:step:N, data_matrix(:, 1))
hold on
plot(step:step:N, true_mean, 'r', 'LineWidth', 1.5)
hold off
legend('Sample mean', 'True mean')
xlabel('Dataset size')
ylabel('Mean')
subplot(2, 1, 2)
plot(step:step:N, data_matrix(:, 2))
hold on
plot(step:step:N, true_var, 'r', 'LineWidth', 1.5)
hold off
legend('Sample variance', 'True variance')
xlabel('Dataset size n')
ylabel('Variance')

% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)


% bootstrap estimation of variance c.i. as a function of n
% reset RNG to Mersenne Twister with seed 0. MT periodicity is higher than
% the number of random variables needed in this experiment.
rng('default');
N = 10000;
step = 10;
gamma = 0.95;
r0 = 50; %1000 cycles for each bootstrap estimate

data_matrix_boot = zeros(N/step, 2);
for n = step:step:N
   data = rand(n, 1);
   ci_var = bootstrap_var(data, gamma, r0);
   data_matrix_boot(n/step, :) = ci_var;
end

true_var = 1/12;
figure
plot(step:step:N, data_matrix_boot(:, 1), step:step:N, data_matrix_boot(:, 2), step:step:N, true_var*ones(1, length(step:step:N)))
legend('Lower value of c.i. for variance, bootstrap', 'Upper value of c.i. for variance, bootstrap', 'True variance of U[0, 1]');
xlabel('Dataset size n')
ylabel('Variance')
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)


% Prediction intervals 
% Data is iid but not normal
% Use theorem 2.5, Leboudec - ordered statistics
N = 10000;
step = 10;
gamma = 0.95;
alpha = 1 - gamma;
alpha_vec = alpha * ones(1, 100);
% The theorem holds for n such that 1 - gamma >= 2/(n+1)
figure, plot(1:100, alpha_vec, 1:100, 2./(1:100))
xlabel('Dataset size n')
legend('Alpha = 0.05', '2/(n+1)')
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)
% From this plot it can be seen that for n >= 39 the previous holds

init_step = 40; % since step is 5 use an integer multiple
data_matrix_pred = zeros(N/step, 2);
for n = init_step:step:N
   data = rand(n, 1);
   data = sort(data);
   lb = floor((n+1)*alpha/2);
   ub = ceil((n+1)*(1 - alpha/2));
   data_matrix_pred(n/step, :) = [data(lb), data(ub)];
end

figure
plot(step:step:N, data_matrix_pred(:, 1), step:step:N, data_matrix_pred(:, 2), step:step:N, 0.025*ones(1, length(step:step:N)), step:step:N, 0.975*ones(1, length(step:step:N)))
xlabel('Dataset size n')
ylabel('Prediction interval')
legend('Lower value of p.i.', 'Upper value of p.i.');
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)


%% Normal (0,1) rv

% reset RNG to Mersenne Twister with seed 0. MT periodicity is higher than
% the number of random variables needed in this experiment.
rng('default');

% true mean and std_dev for a N(0, 1) rv
true_mean = 0;
true_var = 1;

N = 10000; % n upper limit

step = 5;
data_matrix = zeros(N/step, 4);
for n = step:step:N
    % generate indipendently n random variables
    v = randn(n, 1);
    % Compute mean, std_dev and 95% ci for the mean
    m = mean_est(v);
    s_2 = var_est(v, 0);
    ci_mean = m + [-1.96, 1.96] *sqrt(s_2/n); %exact value
    % Store data
    data_matrix(n/step, :) = [m, s_2, ci_mean];
end

% compare true mean and estimated one
figure
subplot(2, 1, 1)
plot(step:step:N, data_matrix(:, 1))
hold on
plot(step:step:N, true_mean, 'r', 'LineWidth', 1.5)
hold off
legend('Sample mean', 'True mean')
xlabel('Dataset size')
ylabel('Mean')
subplot(2, 1, 2)
plot(step:step:N, data_matrix(:, 2))
hold on
plot(step:step:N, true_var, 'r', 'LineWidth', 1.5)
hold off
legend('Sample variance', 'True variance')
xlabel('Dataset size n')
ylabel('Variance')

% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)

% bootstrap estimation of variance c.i. as a function of n
% reset RNG to Mersenne Twister with seed 0. MT periodicity is higher than
% the number of random variables needed in this experiment.
rng('default');
N = 10000;
step = 10;
gamma = 0.95;
r0 = 50; % 1000 cycles for each bootstrap estimate

data_matrix_boot = zeros(N/step, 2);
for n = step:step:N
   data = randn(n, 1);
   ci_var = bootstrap_var(data, gamma, r0);
   data_matrix_boot(n/step, :) = ci_var;
end

true_var = 1;
figure
plot(step:step:N, data_matrix_boot(:, 1), step:step:N, data_matrix_boot(:, 2), step:step:N, true_var*ones(1, length(step:step:N)))
legend('Lower value of c.i. for variance', 'Upper value of c.i. for variance', 'True variance of N[0, 1]');
xlabel('Dataset size')
ylabel('Variance')
axis([0, 10000, 0, 4])
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)

% actually, since data are normal, we can theoretically compute confidence
% intervals since they follow a chi-square distribution (Theorem 2.3 leb)
rng('default');
N = 10000;
step = 10;
gamma = 0.95;

data_matrix_chi = zeros(N/step, 2);
for n = step:step:N
   data = randn(n, 1);
   var = var_est(data, 0);
   lbm = chi2inv((1-gamma)/2, n-1)/(n-1);
   ubm = chi2inv((1+gamma)/2, n-1)/(n-1);
   data_matrix_chi(n/step, :) = [var*lbm, var*ubm];
end

true_var = 1;
figure
plot(step:step:N, data_matrix_chi(:, 1), step:step:N, data_matrix_chi(:, 2), step:step:N, true_var*ones(1, length(step:step:N)))
legend('Lower value of c.i. for variance', 'Upper value of c.i. for variance', 'True variance of N[0, 1]');
xlabel('Dataset size')
ylabel('Variance')
axis([0, 10000, 0, 4])
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)

% Prediction intervals 
% Data is normal, apply Theorem 2.6 Leboudec
rng('default');
N = 10000;
step = 10;
gamma = 0.95;
r0 = 50;
alpha = 1 - gamma;
data_matrix_pred = zeros(N/step, 2);

for n = step:step:N
   data = randn(n, 1);
   eta = tinv((1-alpha/2), n-1);
   mean = mean_est(data);
   var = var_est(data, 0);
   data_matrix_pred(n/step, :) = mean + [-eta, eta]*sqrt((1+1/n)*var);
end
figure
plot(step:step:N, data_matrix_pred(:, 1), step:step:N, data_matrix_pred(:, 2), step:step:N, 1.96*ones(1, length(step:step:N)), step:step:N, -1.96*ones(1, length(step:step:N)))
legend('Lower value of p.i.', 'Upper value of p.i.');
xlabel('Dataset size')
ylabel('P')
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)

% Prediction intervals 
% Data is iid but not normal
% Use theorem 2.5, Leboudec - ordered statistics
rng('default');
N = 10000;
step = 10;
gamma = 0.95;
alpha = 1 - gamma;

init_step = 40; % since step is 5 use an integer multiple
data_matrix_pred = zeros(N/step, 2);
for n = init_step:step:N
   data = randn(n, 1);
   data = sort(data);
   lb = floor((n+1)*alpha/2);
   ub = ceil((n+1)*(1 - alpha/2));
   data_matrix_pred(n/step, :) = [data(lb), data(ub)];
end

figure
plot(step:step:N, data_matrix_pred(:, 1), step:step:N, data_matrix_pred(:, 2), step:step:N, -1.96*ones(1, length(step:step:N)), step:step:N, 1.96*ones(1, length(step:step:N)))
xlabel('Dataset size n')
ylabel('Prediction interval')
legend('Lower value of p.i.', 'Upper value of p.i.');
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)
