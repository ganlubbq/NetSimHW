% Script for question 1 of HW1, Zorzi Simulation

%% First example

clear all;
close all;
clc;

data_old = load('sgbdold.dat');
data_new = load('sgbdnew.dat');
data_old_sorted = sort(data_old);
data_new_sorted = sort(data_new);

% mean and std_dev with unbiased estimators
mean_old = mean_est(data_old);
mean_new = mean_est(data_new);
std_dev_old = sqrt(var_est(data_old, 0));
std_dev_new = sqrt(var_est(data_new, 0));

% median (the other quantiles can be computed with the same estimator)
median_old = qquant_est(data_old, 0.5);
median_new = qquant_est(data_new, 0.5);

% histogram (useless, since there's directly the hist plot)
data_old_hist = hist(data_old, 20*(1:10));
data_new_hist = hist(data_new, 10);

% empirical CDF
[ecdf_old, x_old] = ecdf(data_old);
[ecdf_new, x_new] = ecdf(data_new);

% 95% confidence interval for median, large dataset approximation
j_old = floor(0.5*length(data_old) - 1.96*0.5*sqrt(length(data_old)));
j_new = floor(0.5*length(data_new) - 1.96*0.5*sqrt(length(data_new)));
k_old = ceil(0.5*length(data_old) + 1.96*0.5*sqrt(length(data_old))) + 1;
k_new = ceil(0.5*length(data_new) + 1.96*0.5*sqrt(length(data_new))) + 1;
ci_old_median = [data_old_sorted(j_old), data_old_sorted(k_old)];
ci_new_median = [data_new_sorted(j_new), data_new_sorted(k_new)];

% 95% confidence interval for the mean under iid hypothesis, finite variance and large dataset
ci_old = [mean_old - 1.96*std_dev_old/sqrt(length(data_old)), mean_old + 1.96*std_dev_old/sqrt(length(data_old))];
ci_new = [mean_new - 1.96*std_dev_new/sqrt(length(data_new)), mean_new + 1.96*std_dev_new/sqrt(length(data_new))];

% 95% confidence interval for the mean under gaussian hypothesis - these intervals hold also for a small dataset
gamma = 0.95;
prob = (1 + gamma)/2;
eta = tinv(prob, length(data_new) - 1);
ci_old_normal = [mean_old - eta*std_dev_old/sqrt(length(data_old)), mean_old + eta*std_dev_old/sqrt(length(data_old))];
ci_new_normal = [mean_new - eta*std_dev_new/sqrt(length(data_new)), mean_new + eta*std_dev_new/sqrt(length(data_new))];

% 95% confidence interval for the mean with bootstrap method
gamma = 0.95;
r0 = 100; % precision of the algorithm
ci_old_boot = bootstrap_mean(data_old, gamma, r0);
ci_new_boot = bootstrap_mean(data_new, gamma, r0);

% prediction intervals, as defined in Leboudec pg 25
prediction_int_old = [mean_old - 1.96*std_dev_old, mean_old + 1.96*std_dev_old];
prediction_int_new = [mean_new - 1.96*std_dev_new, mean_new + 1.96*std_dev_new];

% analysis on datasets difference
data_diff = data_old - data_new;
mean_diff = mean_est(data_diff);
std_dev_diff = sqrt(var_est(data_diff, 0));
% 95% ci for the mean
ci_diff = [mean_diff - 1.96*std_dev_diff/sqrt(length(data_diff)), mean_diff + 1.96*std_dev_diff/sqrt(length(data_diff))];
% prediction interval, as defined in Leboudec pg 25
prediction_int_diff = [mean_diff - 1.96*std_dev_diff, mean_diff + 1.96*std_dev_diff];

% fig 2.1
figure
subplot(1, 4, 1)
scatter(1:length(data_old), data_old);
axis([-2, length(data_old) + 2, 0, max(max(data_old), max(data_new)) + 10]);
title('Raw data, old')
subplot(1, 4, 2)
scatter(1:length(data_new), data_new, 'r');
axis([-2, length(data_old) + 2, 0, max(max(data_old), max(data_new)) + 10]);
title('Raw data, new')
subplot(1, 4, 3)
hist(data_old)
title('Histogram, old')
subplot(1, 4, 4)
hist(data_new)
title('Histogram, new')
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)


% fig 2.2
figure
plot(x_old, ecdf_old, 'b', x_new, ecdf_new, 'r');
xlabel('Execution time [ms]')
ylabel('ECDF')
legend('Old', 'New', 'Location', 'SouthEast')
title('Empirical CDFs')
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)


% fig 2.3
figure
h(1) = subplot(1, 2, 1);
b1 = boxplot(h(1), [data_old, data_new], 'notch', 'on', 'labels', {'Old', 'New'});
h(2) = subplot(1, 2, 2);
b2 = boxplot(h(2), [data_old, data_new], 'notch', 'on', 'labels', {'Old', 'New'});
hold on;
line([0.8 1.2], [mean_old, mean_old], 'Color', 'r');
hold on
line([0.75 1.25], [ci_old(1), ci_old(1)], 'LineStyle', ':', 'Color', 'b');
hold on
line([0.75 1.25], [ci_old(2), ci_old(2)], 'LineStyle', ':', 'Color', 'b');
hold on
line([0.5 1.5], [max(prediction_int_old(1), 0), max(prediction_int_old(1), 0)], 'LineStyle', '--', 'Color', 'b');
hold on
line([0.5 1.5], [prediction_int_old(2), prediction_int_old(2)], 'LineStyle', '--', 'Color', 'b');
hold on
line([1.8 2.2], [mean_new, mean_new], 'Color', 'r');
hold on
line([1.75 2.25], [ci_new(1), ci_new(1)], 'LineStyle', ':', 'Color', 'b');
hold on
line([1.75 2.25], [ci_new(2), ci_new(2)], 'LineStyle', ':', 'Color', 'b');
hold on
line([1.5 2.5], [max(prediction_int_new(1), 0), max(prediction_int_new(1), 0)], 'LineStyle', '--', 'Color', 'b');
hold on
line([1.5 2.5], [prediction_int_new(2), prediction_int_new(2)], 'LineStyle', '--', 'Color', 'b');
hold off
% make plot nicer
fig=gcf;

set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
set(findall(fig,'-property','FontSize'),'FontSize',20)

handler = findall(fig, 'Type', 'hggroup');
labels = findall(handler, 'Type', 'text');
for j = 1:length(labels)
    set(labels(j), 'Position', get(labels(j), 'Position') - [0, 10, 0]);
end

% fig 2.7
figure
subplot(1, 3, 1)
scatter(1:length(data_diff), data_diff, 'x');
axis([-2, length(data_diff) + 2, min(data_diff) - 10, max(data_diff) + 10]);
xlabel('Iterations')
ylabel('Difference between execution time (old - new) [ms]')
subplot(1, 3, 2)
hist(data_diff)
xlabel('Histogram')
axis([-100, 200, 0, 30])
subplot(1, 3, 3)
boxplot(data_diff, 'notch', 'on');
set(gca,'XTickLabel',{' '})
xlabel('Boxplot')
hold on;
line([0.8 1.2], [mean_diff, mean_diff], 'Color', 'r');
hold on
line([0.5 1.5], [ci_diff(1), ci_diff(1)], 'LineStyle', ':', 'Color', 'b');
hold on
line([0.5 1.5], [ci_diff(2), ci_diff(2)], 'LineStyle', ':', 'Color', 'b');
hold on
line([0.5 1.5], [prediction_int_diff(1), prediction_int_diff(1)], 'LineStyle', '--', 'Color', 'b');
hold on
line([0.5 1.5], [prediction_int_diff(2), prediction_int_diff(2)], 'LineStyle', '--', 'Color', 'b');
hold off
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)

% fig 2.8
mean_vec = [mean_old, mean_old, mean_old, mean_new, mean_new, mean_new];
U = [ci_old_normal(2), ci_old(2), ci_old_boot(2), ci_new_normal(2), ci_new(2), ci_new_boot(2)] - mean_vec;
color = ['k', 'r', 'b', 'x'];
figure
for i = 1:6
    errorbar(i, mean_vec(i), U(i), strcat(color(mod(i, 3) + 1), color(4)));
    hold on
end
set(gca, 'XTickLabel', {' ', 'Old', 'Old', 'Old', 'New', 'New', 'New', ' '});
xlabel('Data Set');
ylabel('Mean execution time [ms]');
title('Normal, Asymptotic and Bootstrap percentile confidence intervals');
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [1500, 1000]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',20)

%% Example 2.5

% new dataset
joe = load('joe.dat');
% compute autocorrelation, and scale it by r(0) according to Leboudec
% definiton
N_corr = length(joe); %ceil(length(joe)/5); % otherwise estimator variance would be too high
autoc = autocorrelation(joe - mean_est(joe), N_corr);

% fig 2.10
figure;

% axes handling
h(1) = subplot(7, 3, 21);
h(2) = subplot(7, 3, 20);
h(3) = subplot(7, 3, 19);
h(4) = subplot(7, 3, 18);
h(5) = subplot(7, 3, 17);
h(6) = subplot(7, 3, 16);
h(7) = subplot(7, 3, 15);
h(8) = subplot(7, 3, 14);
h(9) = subplot(7, 3, 13);
h(10)=subplot(4, 2, 3);
h(11) = subplot(4, 2, 4);
h(12)=subplot(4, 1, 1);

% plot
plot(h(12), joe, 'r');
title(h(12), 'Data');

probplot(h(10), 'normal', joe)
title(h(10), 'QQ Plot of Sample Data versus Standard Normal')
xlabel(h(10), 'Quantiles of Input Sample')
ylabel(h(10), 'Standard Normal Quantiles')

stem(h(11), autoc(2:length(autoc)), '.')
title(h(11), 'Autocorrelation');


for i = 1:9
    scatter(h(10 - i), joe(1:length(joe) - i), joe(i+1:length(joe)), '.');
    j = 10 - i;
    title(h(10 - i), sprintf('h = %d', i));
end
% make plot nicer
set(gcf, 'PaperUnits', 'points');
set(gcf, 'PaperSize', [700, 1050]);
set(gcf, 'Color', 'w');
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',14)


