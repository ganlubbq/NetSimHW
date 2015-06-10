% DE queue simulator
clear
clc
number_of_events = 10^5;
number_of_desired_renewals = 10^4;
numsim = 10;
% For convenience, use poisson arrivals and departures
rho_vec = [0.01, 0.1:0.05:0.9, 0.99];
for k = 1:length(rho_vec)
    for r = 1:numsim
        [ avg_total_dl(r, k), rho_est(r, k), i(r, k), renewal_instant(r, k) ] = MG1queue_func( rho_vec(k), number_of_events, number_of_desired_renewals );
    end
end

save('demg1', 'rho_vec', 'avg_total_dl', 'rho_est')
% figure, plot(rho_vec, avg_total_dl), grid on, title('Case b'), xlabel('\rho'),
% ylabel('mean total delay in time units')
%
% figure, plot(rho_vec, rho_est)
