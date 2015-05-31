function [droppedUsers, nArrivals] = SlottedQueueFunc2arrFixed(sim_len, p_arr, serv_param, size)
% DT Slotted Queue (1 server, FIFO), fixed size,
%users_in_system = zeros(length(sim_len), 1);
% Useful counters
nUsers = 0;
nArrivals = 0; % a sort of unique SN
droppedUsers = 0;
fixed_st = serv_param;
inService_slot = 1;

% Simulate the process
for t = 1:sim_len
    % Service
    if (nUsers > 0)
        if (inService_slot == fixed_st)
            inService_slot = 1;
            nUsers = nUsers - 1;
        else
            inService_slot = inService_slot + 1;
        end
    end
    
    % Arrivals
    probabilityOfArrival = rand();
    if (probabilityOfArrival < 1 - 2*p_arr)
        % do nothing
    elseif (probabilityOfArrival >= 1 - 2*p_arr && probabilityOfArrival < 1-p_arr)
        if (nUsers - 1 < size) % nUsers - 1 is the number of users in the queue
            nUsers = nUsers + 1;
            nArrivals = nArrivals + 1;
        else
            nArrivals = nArrivals + 1;
            droppedUsers = droppedUsers + 1;
        end
    else
        if (nUsers - 1 < size - 1)
            nUsers = nUsers + 2;
            nArrivals = nArrivals + 2;
        elseif (nUsers - 1 == size - 1)
            nUsers = nUsers + 1;
            droppedUsers = droppedUsers + 1;
            nArrivals = nArrivals + 2;
        else
            droppedUsers = droppedUsers + 2;
            nArrivals = nArrivals + 2;
        end
    end
end

end
