function [ interArrTime ] = getInterarrivalTime( inter_mode, varargin )
% Interarrival times for the DEqueue function
switch inter_mode
    case 'geometric'
        if (length(varargin) < 2)
            disp('Error in creating the interarrival time, for the geom')
            return;
        end
        slot_size = varargin{1};
        b = varargin{2};
        interArrTime = slot_size * (1 + floor(log(rand())/log(1-b))); % geometric RV
    case 'exp'
        
        if (isempty(varargin))
            disp('Error in creating the interarrival time, for the exp')
            return;
        end
        lambda_arr = varargin{1};
        interArrTime = - log(rand())/lambda_arr;
end

end

