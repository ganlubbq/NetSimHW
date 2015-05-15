function [nUsers_time, delay_array] = SlottedQueueFunc2arr(sim_len, p_arr, servopt, serv_param)
%% DT Slotted Queue (1 server, FIFO)

% Useful counters
nUsers = 0;
nUsers_time = zeros(1, sim_len);
nArrivals = 0; % a sort of unique SN
nDepartures= 0;
delay_queue = zeros(1, 2); % This array will simulate a FIFO queue that
% hosts the arrival slot of each user, consider preallocation of a useful
% quantity of memory [nPacket, arrival_slot]
first_queue = 1; % first free position in the queue
delay_array = zeros(1, sim_len); % array that hosts the delay of each packet
geometric = 0;
fixed = 0;

switch servopt
    case 'geometric'
        geometric = 1;
        p_serv = serv_param; 
    case 'fixed'
        fixed = 1;
        fixed_st = serv_param;
        inService_slot = 0;
    otherwise
        disp('error')
        return
end

% Simulate the process
for t = 1:sim_len
    % Service
    if (nUsers > 0)
        if (geometric == 1)
            % draw a geometric RV every slot
            if (rand() < p_serv)
                nUsers = nUsers - 1;
                nDepartures = nDepartures + 1;
                %fprintf('Departure, %d users left \n', nUsers);
                dep_pck = delay_queue(1, 1);
                delay_array(dep_pck) = t - delay_queue(1, 2);
                % pop
                delay_queue(1:end-1) = delay_queue(2:end);
                first_queue = first_queue - 1;
                if (first_queue == 0)
                    first_queue = 1;
                end
            end
        elseif (fixed == 1)
            if (inService_slot == fixed_st)
                inService_slot = 1;
                nUsers = nUsers - 1;
                
                nDepartures = nDepartures + 1;
                %fprintf('Departure, %d users left \n', nUsers);
                dep_pck = delay_queue(1, 1);
                delay_array(dep_pck) = t - delay_queue(1, 2);
                % pop
                delay_queue(1:end-1) = delay_queue(2:end);
                first_queue = first_queue - 1;
            else
                inService_slot = inService_slot + 1;
            end
        end
    end
    
    % Arrivals
    if (rand() < 1 - 2*p_arr)
        % do nothing
    elseif (rand() >= 1 - 2*p_arr && rand() < 1-p_arr)
        nUsers = nUsers + 1;
        nArrivals = nArrivals + 1;
        %fprintf('Arrival, now %d users \n', nUsers);
        delay_queue(first_queue, :) = [nArrivals, t]; % push
        first_queue = first_queue + 1;
    else
        nUsers = nUsers + 2;
        nArrivals = nArrivals + 2;
        %fprintf('Arrival, now %d users \n', nUsers);
        delay_queue(first_queue, :) = [nArrivals - 1, t]; % push
        first_queue = first_queue + 1;
        delay_queue(first_queue, :) = [nArrivals, t]; % push
        first_queue = first_queue + 1;
    end
    
    nUsers_time(t) = nUsers;
end

% resize delay array
delay_array = delay_array(1:nDepartures);
end
