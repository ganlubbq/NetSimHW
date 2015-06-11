function [ avg_total_dl, rho_est, i, renewal_instant ] = MM1queue_func( rho, number_of_events, number_of_desired_renewals )
% Function that simulates a DE queue. 
dep_time = 1;
interarr_time = dep_time/rho;
%dep_time = rho*interarr_time;

% INIT
% Useful counters
server_status = 0;
server_status_vec = zeros(number_of_events, 1); % 0 idle or 1 busy
number_in_queue = 0;
number_in_queue_vec = zeros(number_of_events, 1);
times_of_arrival = zeros(ceil(number_of_events/10), 1); % FIFO structure
first_pos_free = 1;

time_of_last_event = 0;
clock = 0; % keeps current time
clock_vec = zeros(number_of_events, 1);
next_arr = 0; %#ok<NASGU> % keeps the time for next arrival
next_dep = 0; %#ok<NASGU> % I need to store only the next departure since events are if, moreover
% the service time is the time spent by the user in service, therefore it
% has to be counted only when the user enters in service

renewal_instant = 0;
number_delayed = 0;
total_delay = 0;
integral_queue_occupancy = 0;
integral_server_status = 0;

% Initialize the first arrival
inter_arr = getInterarrivalTime('exp', 1/interarr_time);
next_arr = inter_arr;
next_dep = inter_arr+1; % as like as infinite if a comparison has to be done
% at the first event, then departure will be scheduled immediately

i = 1;
while (i  <= number_of_events && renewal_instant <= number_of_desired_renewals)
    %  check if I have a departure or an arrival
    if next_arr <= next_dep %arrival
        clock = next_arr;
        next_arr = clock + getInterarrivalTime('exp', 1/interarr_time);
        % start measuring delay
        times_of_arrival(first_pos_free) = clock; % push
        first_pos_free = first_pos_free + 1; % push
        
        % check if there was someone in the queue before putting someone new,
        % if positive update the queue_occ metric
        if number_in_queue >= 1
            integral_queue_occupancy = integral_queue_occupancy + ...
                number_in_queue * (clock - time_of_last_event);
        end
        
        if server_status == 0    % I can serve the user immediately
            % schedule departure
            next_dep = clock + getServiceTime('exp', 1/dep_time);
            server_status = 1;
            renewal_instant = renewal_instant + 1;
        else % place the new user in the queue
            number_in_queue = number_in_queue + 1;
            % update the following, if the user is queued it means that
            % someone else was in service
            integral_server_status = integral_server_status + clock - time_of_last_event;
        end
        
    else % departure
        clock = next_dep;
        if number_in_queue >= 1 % if there is someone waiting schedule next_departure
            next_dep = clock + getServiceTime('exp', 1/dep_time);
            number_in_queue = number_in_queue - 1;
            server_status = 1; % it doesn't change
        else % if the queue is empty, don't do anything
            next_dep = next_arr + 1; % as at the beginning
            server_status = 0; % the server is free
        end
        
        % check if there was someone in the queue before putting someone new,
        % if positive update the queue_occ metric
        if number_in_queue >= 1
            integral_queue_occupancy = integral_queue_occupancy + ...
                number_in_queue * (clock - time_of_last_event);
        end
        
        % extract the user in service from the queue
        arr_time = times_of_arrival(1); % front
        % pop
        times_of_arrival = times_of_arrival(2:first_pos_free - 1);
        first_pos_free = first_pos_free - 1; % it must be at least 1
        % compute total delay
        user_total_delay = clock - arr_time;
        total_delay = total_delay + user_total_delay;
        number_delayed = number_delayed + 1; %% Number of departed users
        
        % in case of departures always update this metrics, because the
        % server was serving someone
        integral_server_status = integral_server_status + clock - time_of_last_event;
    end
    % sample
    time_of_last_event = clock;
    server_status_vec(i) = server_status;
    clock_vec(i) = clock;
    number_in_queue_vec(i) = number_in_queue;
    i = i + 1;
end

% Process stats
avg_total_dl = total_delay/number_delayed;
rho_est = integral_server_status/clock;
end

