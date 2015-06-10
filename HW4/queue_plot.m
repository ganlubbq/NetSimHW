% Plot queue results
clear
load('demm1.mat')
rho_vec = 0.1:0.1:0.9;

mean_dl = mean(avg_total_dl, 2);
mean_rho = mean(rho_est, 2);
ci_dl = 1.96*std(avg_total_dl, 0, 2)/sqrt(10);
ci_rho = 1.96*std(rho_est, 0, 2)/sqrt(10);

figure, errorbar(rho_vec(1:end-1), mean_dl(1:end-1), ci_dl(1:end-1)), hold on, plot(rho_vec, rho_vec./(1-rho_vec)), grid on, title('Case b'), xlabel('\rho'),
ylabel('mean total delay in time units')

figure, errorbar(rho_vec, mean_rho, ci_rho), grid on, title('Case b'), xlabel('\rho'),
ylabel('Estimated \rho')
