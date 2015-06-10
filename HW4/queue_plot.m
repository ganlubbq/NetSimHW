% Plot queue results
clear
load('demg1.mat')

mean_dl = mean(avg_total_dl, 1);
mean_rho = mean(rho_est, 1);
ci_dl = 1.96*std(avg_total_dl, 0, 1)/sqrt(10);
ci_rho = 1.96*std(rho_est, 0, 1)/sqrt(10);

figure, errorbar(rho_vec(1:end-1), mean_dl(1:end-1), ci_dl(1:end-1))
grid on, title('Case b'), xlabel('\rho'),
ylabel('mean total delay in time units')

figure, errorbar(rho_vec, mean_rho, ci_rho), grid on, title('Case b'), xlabel('\rho'),
ylabel('Estimated \rho')
