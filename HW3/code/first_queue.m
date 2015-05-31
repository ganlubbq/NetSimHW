%% SlottedQueue main class

close all
clear
clc

parpool(16);

%% Exercise 1ai
% Simulation length
sim_len = 1000000; % in number of slots
iterations = 100; % number of iterations of each simulation

% Arrival and service processes specifications
service_time = 1; % 1 slot, fixed
p_vec = (0.1:0.1:0.9)/3;

m_delay = zeros(1, length(p_vec));
free_server_perc = zeros(1, length(p_vec));
std_delay = zeros(1, length(p_vec));
for k = 1:length(p_vec)
    p_arr = p_vec(k);
    disp(p_arr);
    m_delay_iter = zeros(1, iterations);
    free_server_iter = zeros(1, iterations);
    parfor i = 1:iterations
        [nUsers, delay] = SlottedQueueFunc2arr(sim_len, p_arr, 'fixed', service_time);
        free_server_iter(i) = length(find(nUsers == 0))/sim_len;
        m_delay_iter(i) = mean(delay);
    end
    m_delay(k) = mean(m_delay_iter);
    std_delay(k) = std(m_delay_iter);
    free_server_perc(k) = mean(free_server_iter);
end

rho = (3.*p_vec); % since 3a is the mean number of arrivals for each a

save('queueA', 'rho', 'm_delay', 'std_delay');

figure, errorbar(rho, m_delay, std_delay), grid on, title('Delay vs \rho'), xlabel('\rho'), ylabel('Delay')
xlim([0.08, 0.91])
%% Exercise 1aii

p_vec = [1/4, 1/3, 1/2];
service_time = 1; % 1 slot, fixed
sim_len = 10000; % in number of slots
for k = 1:length(p_vec)
    p_arr = p_vec(k);
    disp(p_arr);
    [nUsers, delay] = SlottedQueueFunc2arr(sim_len, p_arr, 'fixed', service_time);
    figure, plot(nUsers), grid on, title(strcat('Realization of the queue, a = ', num2str(p_arr))), xlabel('n'), ylabel('Queue size')
end
%% Exercise 1bi
p_arr = 0.5; % probability of arrivals
b_vec = 0.5:0.05:1;

m_delay_geo = zeros(1, length(b_vec));
free_server_perc_geo = zeros(1, length(b_vec));
std_delay_geo = zeros(1, length(b_vec));
for k = 1:length(b_vec)
    b = b_vec(k);
    disp(b);
    m_delay_iter = zeros(1, iterations);
    free_server_iter = zeros(1, iterations);
    parfor i = 1:iterations
        disp(i);
        [nUsers, delay] = SlottedQueueFunc(sim_len, p_arr, 'geometric', b);
        free_server_iter(i) = length(find(nUsers == 0))/sim_len;
        m_delay_iter(i) = mean(delay);
    end
    m_delay_geo(k) = mean(m_delay_iter);
    std_delay_geo(k) = std(m_delay_iter);
    free_server_perc_geo(k) = mean(free_server_iter);
end
rho_b = p_arr./b_vec;
save('queueB', 'rho_b', 'm_delay_geo', 'std_delay_geo');

figure, errorbar(rho_b(2:end), m_delay_geo(2:end), std_delay_geo(2:end)), grid on, title('Delay vs \rho'), xlabel('\rho'), ylabel('Delay')
xlim([0.48, 0.92])
%
%% Exercise 1bii
p_arr = 0.5; % probability of arrivals
b_vec = [1/3, 1/2, 2/3];

sim_len = 10000; % in number of slots
for k = 1:length(b_vec)
    b = b_vec(k);
    disp(b);
    [nUsers, delay] = SlottedQueueFunc(sim_len, p_arr, 'geometric', b);
    figure, plot(nUsers), grid on, title(strcat('Realization of the queue, b = ', num2str(b))), xlabel('n'), ylabel('Queue size')
end