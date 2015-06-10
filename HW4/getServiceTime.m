function [ serviceTime ] = getServiceTime( service_mode, varargin )
% Interarrival times for the DEqueue function
switch service_mode
    case 'geometric'
        if (length(varargin) < 2)
            disp('Error in creating the interarrival time, for the geom')
            return;
        end
        slot_size = varargin{1};
        b = varargin{2};
        serviceTime = slot_size * (1 + floor(log(rand())/log(1-b))); % geometric RV
    case 'exp'
        if (isempty(varargin))
            disp('Error in creating the interarrival time, for the exp')
            return;
        end
        lambda_dep = varargin{1};
        serviceTime = - log(rand())/lambda_dep;
    case 'bernoulli12'
        if (length(varargin) < 2)
            disp('Error in creating the interarrival time, for the bernoulli12')
            return;
        end
        slot_size = varargin{1};
        b = varargin{2};
        pr = rand();
        if pr < b
            serviceTime = slot_size;
        else
            serviceTime = 2*slot_size;
        end
end

end

