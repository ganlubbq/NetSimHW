function [ quant ] = qquant_est( data, q )
% Estimator of the median
data = sort(data);
n = length(data);
kl = floor(q*n + (1 - q));
ku = ceil(q*n + (1-q));
quant = (data(kl)+data(ku))*0.5;
end

