%% SlottedQueue main class

close all
clear
clc

% Simulation length
sim_len = 10000; % in number of slots
iterations = 1000; % number of iterations of each s

% Arrival and service processes specifications
p_arr = 0.5;
% in a bernoulli arrival
arr_rate = p_arr;

% Geometric queue
rho_vec = 0.1:0.1:1;
m_delay = zeros(1, length(rho_vec));
free_server_perc = zeros(1, length(rho_vec));
for rho = 1:length(rho_vec)
    disp(rho);
    service_rate = arr_rate/rho_vec(rho);
    % with geometric departures
    p_serv = service_rate;
    m_delay_iter = zeros(1, iterations);
    free_server_iter = zeros(1, iterations);
    for i = 1:iterations
        disp(i);
        [nUsers, delay] = SlottedQueueFunc(sim_len, p_arr, 'geometric', p_serv);
        free_server_iter(i) = length(find(nUsers == 0))/sim_len;
        m_delay_iter(i) = mean(delay);
    end
    m_delay(rho) = mean(m_delay_iter);
    free_server_perc(rho) = mean(free_server_iter); 
end

figure, plot(rho_vec, m_delay)
figure, plot(rho_vec, free_server_perc)


