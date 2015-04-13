function [ X_ber ] = bin_ber_generator( n, p, experiments )
% Generates "experiments" binomial(n, p) random variables by generation of
% n bernoulli(p)

X_ber = zeros(experiments, 1);
for j = 1:experiments
    
    X = 0;
    for i = 1:n
        u = rand();
        if(u < p)
            X = X + 1;
        end
    end
    X_ber(j) = X;
    
end


end