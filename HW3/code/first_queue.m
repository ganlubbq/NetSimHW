%% SlottedQueue main class

close all
clear
clc
% Simulation length
sim_len = 1000; % in number of slots
iterations = 100; % number of iterations of each s

% Arrival and service processes specifications
service_time = 10; % 1 slot, fixed
p_vec = 0.01:0.01:0.05;


m_delay = zeros(1, length(p_vec));
free_server_perc = zeros(1, length(p_vec));
for k = 1:length(p_vec)
    p_arr = p_vec(k);
    disp(p_arr);
    m_delay_iter = zeros(1, iterations);
    free_server_iter = zeros(1, iterations);
    for i = 1:iterations
        disp(i);
        [nUsers, delay] = SlottedQueueFunc2arr(sim_len, p_arr, 'fixed', service_time);
        free_server_iter(i) = length(find(nUsers == 0))/sim_len;
        m_delay_iter(i) = mean(delay);
    end
    m_delay(k) = mean(m_delay_iter);
    free_server_perc(k) = mean(free_server_iter); 
end

figure, plot(p_vec(1:end-1), m_delay(1:end-1))
figure, plot(p_vec, free_server_perc)


