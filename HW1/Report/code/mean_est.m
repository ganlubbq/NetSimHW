function [ mean_es ] = mean_est( data )
% Estimator of the mean
    mean_es = sum(data)/length(data);

end

