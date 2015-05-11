%% GeRaF iterative approach
clear

nu = 10; % number of intervals per unit step
D = 5;
numint = nu*D;
M = 5; % average number of active nodes in the area

P = zeros(numint, numint);

for i = 1:numint - nu - 1 % up to the states that are outside the area of dst
    D_st = D - (i-1)/nu;
    % compute the areas
    area = zeros(1, nu+1);
    for j = 0:nu
        r = D_st - j/nu;
        w = (D_st^2 - r^2 + 1)/(2*D_st);
        area(j+1) = circle_int_func(w, 1) + circle_int_func(D_st - w, r);
    end
    % compute the probabilities
    for j = 1:nu-1 % actually 0:nu-2, but for MATLAB indexing...
        P(i, i + j - 1) = (1-exp(-M/pi * area(j)))*exp(-M/pi * area(j+1));
    end
    P(i, i + nu - 1) = 1-exp(-M/pi * area(nu));
end

for i = numint - nu:numint % absorbing states
    P(i, i) = 1;
end

v = zeros(1, numint);
for r = numint - nu:numint
    v(r) = 1;
end
k = numint - nu - 1;
while k > 0
    v(k) = (1+sum(P(k, k:k+1+nu-1).*v(k:k+1+nu-1)))/(1-P(k, k));
    k = k - 1;
end