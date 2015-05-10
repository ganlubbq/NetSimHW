%% GeRaF iterative approach
clear 

nu = 10; % number of intervals per unit step
D = 5;
numint = nu*D;
M = 5; % average number of active nodes in the area

P = zeros(numint, numint);

for i = 1:numint-nu - 1 % up to the states that are outside the area of dst
    D_st = D - i/nu;
    % compute the areas
    area = zeros(1, nu);
    for j = 1:nu
        r = D_st - j/nu;
        w = (D_st^2 - r^2 + 1)/(2*D_st);
        area(j) = circle_int_func(w, 1) + circle_int_func(D_st - w, r);
    end
    % compute the probabilities
    for j = 1:nu-1
        P(i, i - 1 + j) = exp(-M/pi * area(j))*(1-exp(-M/pi * area(j+1)));
    end
end

for i = numint - nu:numint % absorbing states
    P(i, i) = 1;
end

v = zeros(1, numint-nu - 1);
for r = 1:numint-nu-1
    k = numint-nu - r;
    v(k) = 0;
end