% DE queue simulator

clear
clc

%% Ex. 1, case a
number_of_events = 10^5;
number_of_desired_renewals = 10^4;
numsim = 2;
load('../HW3/code/queueB.mat') % to make it as in the previous homework
rho_vec_gg = rho_b; %[0.01, 0.1:0.05:0.9, 0.99];
delay_gg = zeros(length(rho_vec_gg), numsim);
rho_est_gg = zeros(length(rho_vec_gg), numsim);
for k = 1:length(rho_vec_gg)
    for r = 1:numsim
        [ delay_gg(k, r), rho_est_gg(k, r), ~ ] = ... 
            geogeo1queue_func( rho_vec_gg(k), number_of_events, number_of_desired_renewals );
    end
end

save('degg1', 'rho_vec_gg', 'delay_gg', 'rho_est_gg')

%% Ex. 1, case b
number_of_events = 10^5;
number_of_desired_renewals = 10^4;
numsim = 2;
rho_vec_mg = [0.01, 0.1:0.05:0.9, 0.99];
delay_mg = zeros(length(rho_vec_mg), numsim);
rho_est_mg = zeros(length(rho_vec_mg), numsim);
for k = 1:length(rho_vec_mg)
    for r = 1:numsim
        [ delay_mg(k, r), rho_est_mg(k, r), ~] = ... 
            MG1queue_func( rho_vec_mg(k), number_of_events, number_of_desired_renewals );
    end
end

save('demg1', 'rho_vec_mg', 'delay_mg', 'rho_est_mg')

%% Ex. 1, case MM1
number_of_events = 10^5;
number_of_desired_renewals = 10^4;
numsim = 2;
rho_vec_mm = [0.01, 0.1:0.05:0.9, 0.99];
delay_mm = zeros(length(rho_vec_mm), numsim);
rho_est_mm = zeros(length(rho_vec_mm), numsim);
for k = 1:length(rho_vec_mm)
    for r = 1:numsim
        [ delay_mm(k, r), rho_est_mm(k, r), ~] = ... 
            MM1queue_func( rho_vec_mm(k), number_of_events, number_of_desired_renewals );
    end
end

save('demm1', 'rho_vec_mm', 'delay_mm', 'rho_est_mm')




