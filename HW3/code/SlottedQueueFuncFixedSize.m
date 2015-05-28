function [droppedUsers, nArrivals] = SlottedQueueFuncFixedSize(sim_len, p_arr, serv_param, size)
% DT Slotted Queue (1 server, FIFO) with fixed size
% Bernoulli arrivals, geometric service time

% Useful counters
nUsers = 0;
nArrivals = 0; % a sort of unique SN

droppedUsers = 0;
p_serv = serv_param;

% Simulate the process
for t = 1:sim_len
    % Service
    if (nUsers > 0)
        % draw a geometric RV every slot
        if (rand() < p_serv)
            nUsers = nUsers - 1;
        end  
    end
    % Arrivals
    if (rand() < p_arr)
        if(nUsers - 1 > size)
            % drop the packet
            droppedUsers = droppedUsers + 1;
            nArrivals = nArrivals + 1;
        else
            nUsers = nUsers + 1;
            nArrivals = nArrivals + 1;
        end
    end
end
end
