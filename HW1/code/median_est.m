function [ median ] = median_est( data )
% Estimator of the median
data = sort(data);
if mod(length(data), 2) == 0
    median = data(length(data)/2)/2 + data(length(data)/2 + 1)/2;
else
    median = data((length(data) + 1)/2);
end

end

