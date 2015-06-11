% DE queue simulator

clear
clc

%% Ex. 1, case a
number_of_events = 10^5;
number_of_desired_renewals = 10^4;
max_numsim = 500;
load('../HW3/code/queueB.mat') % to make it as in the previous homework
rho_vec_gg = rho_b; %[0.01, 0.1:0.05:0.9, 0.99];
mean_dl_gg = zeros(length(rho_vec_gg), 1);
ci_dl_gg = zeros(length(rho_vec_gg), 1);
mean_rho_gg = zeros(length(rho_vec_gg), 1);
ci_rho_gg = zeros(length(rho_vec_gg), 1);
for k = 1:length(rho_vec_gg)
    delay_gg = zeros(1, max_numsim);
    rho_est_gg = zeros(1, max_numsim);
    run_sum = 0;
    m_run = 0;
    target_ci_reached = false;
    r = 1;
    while (r < max_numsim && target_ci_reached == false)
        fprintf('For rho = %d reached the iteration %d \n', rho_vec_gg(k), r);
        [ delay_gg(r), rho_est_gg(r), ~ ] = ...
            geogeo1queue_func( rho_vec_gg(k), number_of_events, number_of_desired_renewals );
        % compute ci on the go in order to stop the simulation before than
        % needed
        if r > 10
            m_run = mean(delay_gg(1:r));
            std_run = std(delay_gg(1:r));
            ci_run = 1.96*std_run/sqrt(r);
            max_displ = m_run/100;
            if (max_displ >= ci_run)
                target_ci_reached = true;
                fprintf('Target reached for rho = %d \n', rho_vec_gg(k));
            end
        end
        r = r + 1;
    end
    
    % directly save mean and ci
    mean_dl_gg(k) = mean(delay_gg(1:r-1));
    ci_dl_gg(k) = 1.96*std(delay_gg(1:r-1))/sqrt(r-1);
    mean_rho_gg(k) = mean(rho_est_gg(1:r-1));
    ci_rho_gg(k) = 1.96*std(rho_est_gg(1:r-1))/sqrt(r-1);
    
end

save('degg1_short', 'mean_dl_gg', 'ci_dl_gg', 'mean_rho_gg', 'ci_rho_gg', 'rho_vec_gg')
%% Ex. 1, case b

rho_vec_mg = [0.01, 0.1:0.05:0.9, 0.99];
mean_dl_mg = zeros(length(rho_vec_mg), 1);
ci_dl_mg = zeros(length(rho_vec_mg), 1);
mean_rho_mg = zeros(length(rho_vec_mg), 1);
ci_rho_mg = zeros(length(rho_vec_mg), 1);
for k = 1:length(rho_vec_mg)
    delay_mg = zeros(1, max_numsim);
    rho_est_mg = zeros(1, max_numsim);
    run_sum = 0;
    m_run = 0;
    target_ci_reached = false;
    r = 1;
    while (r < max_numsim && target_ci_reached == false)
        fprintf('For rho = %d reached the iteration %d \n', rho_vec_mg(k), r);
        [ delay_mg(r), rho_est_mg(r), ~ ] = ...
            MG1queue_func( rho_vec_mg(k), number_of_events, number_of_desired_renewals );
        % compute ci on the go in order to stop the simulation before than
        % needed
        if r > 10
            m_run = mean(delay_mg(1:r));
            std_run = std(delay_mg(1:r));
            ci_run = 1.96*std_run/sqrt(r);
            max_displ = m_run/30;
            if (max_displ >= ci_run)
                target_ci_reached = true;
                fprintf('Target reached for rho = %d \n', rho_vec_mg(k));
            end
        end
        r = r + 1;
    end
    
    % directly save mean and ci
    mean_dl_mg(k) = mean(delay_mg(1:r-1));
    ci_dl_mg(k) = 1.96*std(delay_mg(1:r-1))/sqrt(r-1);
    mean_rho_mg(k) = mean(rho_est_mg(1:r-1));
    ci_rho_mg(k) = 1.96*std(rho_est_mg(1:r-1))/sqrt(r-1);
    
end

save('demg1_short', 'mean_dl_mg', 'ci_dl_mg', 'mean_rho_mg', 'ci_rho_mg', 'rho_vec_mg')

% number_of_events = 10^5;
% number_of_desired_renewals = 10^4;
% max_numsim = 20;
% rho_vec_mg = [0.01, 0.1:0.05:0.9, 0.99];
% delay_mg = zeros(length(rho_vec_mg), max_numsim);
% rho_est_mg = zeros(length(rho_vec_mg), max_numsim);
% for k = 1:length(rho_vec_mg)
%     for r = 1:max_numsim
%         [ delay_mg(k, r), rho_est_mg(k, r), ~] = ...
%             MG1queue_func( rho_vec_mg(k), number_of_events, number_of_desired_renewals );
%     end
% end
% 
% save('demg1', 'rho_vec_mg', 'delay_mg', 'rho_est_mg')

%% Ex. 1, case MM1

rho_vec_mm = [0.01, 0.1:0.05:0.9, 0.99];
mean_dl_mm = zeros(length(rho_vec_mm), 1);
ci_dl_mm = zeros(length(rho_vec_mm), 1);
mean_rho_mm = zeros(length(rho_vec_mm), 1);
ci_rho_mm = zeros(length(rho_vec_mm), 1);
for k = 1:length(rho_vec_mm)
    delay_mm = zeros(1, max_numsim);
    rho_est_mm = zeros(1, max_numsim);
    run_sum = 0;
    m_run = 0;
    target_ci_reached = false;
    r = 1;
    while (r < max_numsim && target_ci_reached == false)
        fprintf('For rho = %d reached the iteration %d \n', rho_vec_mm(k), r);
        [ delay_mm(r), rho_est_mm(r), ~ ] = ...
            MM1queue_func( rho_vec_mm(k), number_of_events, number_of_desired_renewals );
        % compute ci on the go in order to stop the simulation before than
        % needed
        if r > 10
            m_run = mean(delay_mm(1:r));
            std_run = std(delay_mm(1:r));
            ci_run = 1.96*std_run/sqrt(r);
            max_displ = m_run/30;
            if (max_displ >= ci_run)
                target_ci_reached = true;
                fprintf('Target reached for rho = %d \n', rho_vec_mm(k));
            end
        end
        r = r + 1;
    end
    
    % directly save mean and ci
    mean_dl_mm(k) = mean(delay_mm(1:r-1));
    ci_dl_mm(k) = 1.96*std(delay_mm(1:r-1))/sqrt(r-1);
    mean_rho_mm(k) = mean(rho_est_mm(1:r-1));
    ci_rho_mm(k) = 1.96*std(rho_est_mm(1:r-1))/sqrt(r-1);
    
end

save('demm1_short', 'mean_dl_mm', 'ci_dl_mm', 'mean_rho_mm', 'ci_rho_mm', 'rho_vec_mm')

% number_of_events = 10^5;
% number_of_desired_renewals = 10^4;
% max_numsim = 20;
% rho_vec_mm = [0.01, 0.1:0.05:0.9, 0.99];
% delay_mm = zeros(length(rho_vec_mm), max_numsim);
% rho_est_mm = zeros(length(rho_vec_mm), max_numsim);
% for k = 1:length(rho_vec_mm)
%     for r = 1:max_numsim
%         [ delay_mm(k, r), rho_est_mm(k, r), ~] = ...
%             MM1queue_func( rho_vec_mm(k), number_of_events, number_of_desired_renewals );
%     end
% end
% 
% save('demm1', 'rho_vec_mm', 'delay_mm', 'rho_est_mm')




