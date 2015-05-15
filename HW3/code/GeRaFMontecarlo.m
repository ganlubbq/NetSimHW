%% GeRaF Montecarlo simulation

%clear
close all
clc
rng default

% number of simulations
numsim = 10000;

% every length is normalized to the coverage radius
D_vec = [5, 10, 20]; % distance to the dst
M_max = 50;
hops = zeros(numsim, M_max, length(D_vec));

for i = 1:length(D_vec)
    D = D_vec(i);
    for N = 1:M_max % sensors phisically deployed in an unit area
        disp(N);
        d = 1; % duty cycle
        M = N*d; % average number of active users per unit area
        
        for iter = 1:numsim
            step = 0;
            D_st = D;
            while D_st > 1 % until we get to a node which is in reach of the dst
                D_st = GeRaFstep(D_st, M);
                step = step + 1;
            end
            hops(iter, N, i) = step + 1;
        end
    end
end

m_hops = mean(hops, 1);
stddev_hops = std(hops, 1);

GeRaFIterative;

for i = 1:length(D_vec)
    figure, 
    %errorbar(1:M_max, m_hops(:, :, i), stddev_hops(:, :, i)), hold on, 
    plot(1:M_max, hops_ub(i, :), 1:M_max, hops_lb(i, :)), hold on,
    stem(1:M_max, m_hops(:, :, i), 'LineStyle', 'none', 'Marker', '^', 'MarkerSize', 8)
    legend('monte', 'ub', 'lb')
end
