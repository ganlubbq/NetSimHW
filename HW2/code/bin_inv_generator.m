function [ X_inv ] = bin_inv_generator( n, p, experiments )
% Generates "experiments" binomial(n, p) random variables by CDF inversion

X_inv = zeros(experiments, 1);
for j = 1:experiments
    
    U = rand();
    c = p/(1-p);
    pr = (1-p)^n;
    F = pr;
    i = 0;
    while(U >= F)
        pr = c*(n - i)*pr/(i + 1);
        F = F + pr;
        i = i + 1;
    end
    X_inv(j) = i;
    
end


end

