%% Exercise 1c

close all
clear 
clc

n_sim = 80;
target = 0.00001;
sim_len = 50/target;

parpool(8);
%% Fixed service time queue

service_time = 1; % slot
a = 0.25;
% say 22
size_vec = 20:25;
p_drop_fixed = zeros(length(size_vec), n_sim);
for sindex = 1:length(size_vec)
    size = size_vec(sindex);
    parfor i = 1:n_sim
        disp(i);
        [droppedUsers, nArrivals] = SlottedQueueFunc2arrFixed(sim_len, a, 1, size);
        p_drop_fixed(sindex, i) = droppedUsers/nArrivals;
    end
end

pmean_fixed = mean(p_drop_fixed, 2);
p_ci_ub_fixed = std(p_drop_fixed, 0, 2)/sqrt(length(p_drop_fixed(1, :)));
figure, errorbar(size_vec, pmean_fixed, 2*p_ci_ub_fixed), hold on, plot(size_vec, target*ones(length(size_vec),1))

return
%% Geometric queue
% for the only stable b
b = 2/3;
p_arr = 0.5;
% try with 13 or 14
size_vec = 13:14;
p_drop_geo = zeros(length(size_vec), n_sim);

for sindex = 1:length(size_vec)
    size = size_vec(sindex);
    parfor i = 1:n_sim
        disp(i);
        [droppedUsers, nArrivals] = SlottedQueueFuncFixedSize(sim_len, p_arr, b, size);
        p_drop_geo(sindex, i) = droppedUsers/nArrivals;
    end
end

delete(gcp);

pmean_geo = mean(p_drop_geo, 2);
p_ci_ub_geo = std(p_drop_geo, 0, 2)/sqrt(length(p_drop_geo(1, :)));
figure, errorbar(size_vec, pmean_geo, 2*p_ci_ub_geo), hold on, plot(size_vec, target*ones(length(size_vec),1))
