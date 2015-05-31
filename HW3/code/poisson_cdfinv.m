function [ X ] = poisson_cdfinv( lambda )
% Generates a Poisson random variable of mean lambda with CDF inversion
pr = exp(-lambda);
U = rand();
F = pr;
X = 0;
while(U >= F)
    pr = lambda * pr / (X+1);
    F = F + pr;
    X = X + 1;
end

end

