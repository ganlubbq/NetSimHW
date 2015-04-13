function [ X_geo ] = bin_geo_generator( n, p, experiments )
% Generates "experiments" binomial(n, p) random variables by CDF inversion

X_geo = zeros(experiments, 1);
for j = 1:experiments
    % Generation of a geometric rv
    G = floor(log(rand())/log(1-p));
    i = G + 1; % G zeros and a 1 
    X = 0;
    % if the string of zeros and the last 1 are longer less than n
    % then there's at least one success in the n trials
    while(i <= n)
        X = X + 1; 
        G = floor(log(rand())/log(1-p));
        i = i + G + 1; % another string of G zeros and a 1
    end
    X_geo(j) = X;
end


end

