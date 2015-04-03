function [ autoc ] = autocorrelation( x, N_corr )
% This function returns ACS of a signal x as defined in Le Boudec.
% N_corr is the number of desired samples for the ACS
x = x - mean(x);
K = length(x);
autoc = zeros(N_corr + 1, 1);
for n = 1:(N_corr + 1)
    d = x(n:K);
    b = conj(x(1:(K - n + 1)));
    c = K; % - n + 1 for the unbiased estimator
    autoc(n) = d.' * b / c;
end

% rescale
autoc = autoc/autoc(1);

end