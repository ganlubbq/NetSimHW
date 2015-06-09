% DE queue simulator
clear
clc

rho_vec = [0.00001, 0.1, 0.3, 0.5, 0.7, 0.9];
for k = 1:length(rho_vec)
    lambda_arr = rho_vec(k)/1.5; % in seconds
    b = 0.5;
    slot_len = 1; % in seconds
    
    % Useful counters
    number_of_events = 10^5;
    server_status_vec = zeros(number_of_events, 1); % 0 idle or 1 busy
    server_status = 0;
    number_in_queue = 0;
    number_in_queue_vec = zeros(number_of_events, 1);
    times_of_arrival = zeros(number_of_events/4, 1); % FIFO structure
    first_pos_free = 1;
    time_of_last_event = 0;
    
    clock = 0; % keeps current time
    clock_vec = zeros(number_of_events, 1);
    next_arr = 0; %#ok<NASGU> % keeps the time for next arrival
    next_dep = 0; %#ok<NASGU> % I need to store only the next departure since events are if, moreover
    % the service time is the time spent by the user in service, therefore it
    % has to be counted only when the user enters in service
    
    number_delayed = 0;
    total_delay = 0;
    integral_queue_occupancy = 0;
    integral_server_status = 0;
    
    % Initialize the first arrival
    inter_arr = poisson_cdfinv(lambda_arr);
    next_arr = inter_arr;
    next_dep = inter_arr+1; % as like as infinite if a comparison has to be done
    % at the first event, then departure will be scheduled immediately
    the_departed_user_was_queued = false;
    
    for i  = 1:number_of_events
        %  check if I have a departure or an arrival
        if next_arr <= next_dep %arrival
            clock = next_arr;
            next_arr = clock + getInterarrivalTime('exp', lambda_arr);
            
            % check if there was someone in the queue before putting someone new,
            % if positive update the queue_occ metric
            if number_in_queue >= 1
                integral_queue_occupancy = integral_queue_occupancy + ...
                    number_in_queue * (clock - time_of_last_event);
            end
            
            if server_status == 0    % I can serve the user immediately
                % schedule departure
                next_dep = clock + getServiceTime('bernoulli12', slot_len, b);
                the_departed_user_was_queued = false;
                server_status = 1;
            else % place the new user in the queue
                number_in_queue = number_in_queue + 1;
                times_of_arrival(first_pos_free) = clock; % push
                first_pos_free = first_pos_free + 1; % push
                % update the following, if the user is queued it means that
                % someone else was in service
                integral_server_status = integral_server_status + clock - time_of_last_event;
            end
        else % departure
            clock = next_dep;
            if (the_departed_user_was_queued)
                % extract the user in service from the queue
                arr_time = times_of_arrival(1); % front
                % pop
                times_of_arrival = times_of_arrival(2:first_pos_free - 1);
                first_pos_free = first_pos_free - 1; % it must be at least 1
                % compute queueing delay
                user_queueing_delay = clock - arr_time;
                total_delay = total_delay + user_queueing_delay;
            end
            if number_in_queue >= 1 % if there is someone waiting schedule next_departure
                next_dep = clock + getServiceTime('bernoulli12', slot_len, b);
                the_departed_user_was_queued = true;
                number_in_queue = number_in_queue - 1;
                server_status = 1; % it doesn't change
            else % if the queue is empty, don't do anything
                next_dep = next_arr + 1; % as at the beginning
                server_status = 0; % the server is free
            end
            % in case of departures always update this metrics, because the
            % server was serving someone
            integral_server_status = integral_server_status + clock - time_of_last_event;
            number_delayed = number_delayed + 1; %% Number of departed users
        end
        % sample
        time_of_last_event = clock;
        server_status_vec(i) = server_status;
        clock_vec(i) = clock;
        number_in_queue_vec(i) = number_in_queue;
    end
    
    figure, plot(clock_vec, number_in_queue_vec)
    
    % Process stats
    avg_total_dl(k) = total_delay/number_delayed;
end

figure, plot(rho_vec, avg_total_dl), grid on, title('Case b'), xlabel('\rho'),
ylabel('mean total delay in time units')