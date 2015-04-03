function [ s_2 ] = var_est( data, option )
% Unbiased or biased estimator for variance
m = mean_est(data);
diff = (data - m).^2;
if option == 0 % unbiased estimator
    s_2 = sum(diff)/(length(data) - 1);
elseif option == 1 % biased estimator
    s_2 = sum(diff)/(length(data));
else
    disp('Error, option is in [0, 1]');
    
end

