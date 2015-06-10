% Plot queue results
clear
load('demg1.mat')

mean_dl = mean(avg_total_dl, 1);
mean_rho = mean(rho_est, 1);
ci_dl = 1.96*std(avg_total_dl, 0, 1)/sqrt(10);
ci_rho = 1.96*std(rho_est, 0, 1)/sqrt(10);

m_y = 1.5;
s_y = 0.25;
b = 0.5;

for i = 1:length(rho_vec)
    lambda_y = rho_vec(i)/m_y; % in seconds
    theo_dl(i) = 0.5*(m_y + (m_y+lambda_y*s_y^2)...
        /(1-lambda_y*m_y));
end
figure, errorbar(rho_vec(1:end-1), mean_dl(1:end-1), ci_dl(1:end-1)), hold on,
plot(rho_vec(1:end-1), theo_dl(1:end-1))
grid on, title('Case b'), xlabel('\rho'),
ylabel('mean total delay in time units')

figure, errorbar(rho_vec, mean_rho, ci_rho), grid on, title('Case b'), xlabel('\rho'),
ylabel('Estimated \rho')
