%% Exercise 1c

% for the only stable b
b = 2/3;
n_sim = 96;
sim_len = 5*10^6;
size_vec = 11:15;
p_drop_geo = zeros(length(size_vec), n_sim);

parpool(6);
for sindex = 1:length(size_vec)
    size = size_vec(sindex);
    parfor i = 1:n_sim
        disp(i);
        [nUsers, delay] = SlottedQueueFunc(sim_len, p_arr, 'geometric', b);
        [droppedUsers, nArrivals] = SlottedQueueFuncFixedSize(sim_len, p_arr, b, size);
        p_drop_geo(sindex, i) = droppedUsers/nArrivals;
    end
end

delete(gcp);

pmean = mean(p_drop_geo, 2);