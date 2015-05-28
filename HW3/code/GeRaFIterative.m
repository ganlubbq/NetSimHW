%% GeRaF iterative approach
%clear

nu = 50; % number of intervals per unit step
parpool(4);
%% Lower bound

D_vec = [5, 10, 20];
M_max = 30;
hops_ub = zeros(length(D_vec), M_max);
parfor pos = 1:length(D_vec)
    D = D_vec(pos);
    numint = nu*D;
    for M = 1:M_max
        P = zeros(numint, numint);
        for i = 1:numint - nu - 1 % up to the states that are outside the area of dst
            D_st = D - (i-1)/nu;
            % compute the areas©
            area = zeros(1, nu+1);
            for j = 0:nu
                r = D_st - j/nu;
                w = (D_st^2 - r^2 + 1)/(2*D_st);
                area(j+1) = num_int_circle(r, D_st, gl); %circle_int_func(w, 1) + circle_int_func(D_st - w, r);
            end
            % compute the probabilities
            for j = 1:nu % actually 0:nu-1, but for MATLAB indexing...
                P(i, i + j - 1) = abs(exp(-M/pi*area(j+1)) - exp(-M/pi * area(j)));
            end
            % add the probability of no sensor
            P(i, i) = abs(P(i, i) + exp(-M/pi*area(1)));
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
            v(k) = (1+sum(P(k, k:k+nu-1).*v(k:k+nu-1)))/(1-P(k, k));
            k = k - 1;
        end
        hops_ub(pos, M) = v(1);
    end
end

%% Upper bound

hops_lb = zeros(length(D_vec), M_max);
parfor pos = 1:length(D_vec)
    D = D_vec(pos);
    numint = nu*D;
    for M = 1:M_max
        P = zeros(numint, numint);
        for i = 1:numint - nu % up to the states that are outside the area of dst
            D_st = D - (i-1)/nu;
            % compute the areas
            area = zeros(1, nu+1);
            for j = 0:nu
                r = D_st - j/nu;
                w = (D_st^2 - r^2 + 1)/(2*D_st);
                area(j+1) = num_int_circle(r, D_st, gl);%circle_int_func(w, 1) + circle_int_func(D_st - w, r);
            end
            % compute the probabilities
            for j = 2:nu+1 % actually 0:nu-1, but for MATLAB indexing...
                P(i, i + j - 1) = abs(exp(-M/pi*area(j)) - exp(-M/pi * area(j-1)));
            end
            % add the probability of no sensor
            P(i, i) = abs(P(i, i) + exp(-M/pi*area(1)));
        end
        
        for i = numint - nu + 1:numint % absorbing states
            P(i, i) = 1;
        end
        
        v = zeros(1, numint);
        for r = numint - nu + 1:numint
            v(r) = 1;
        end
        k = numint - nu;
        while k > 0
            v(k) = (1+sum(P(k, k:k+nu).*v(k:k+nu)))/(1-P(k, k));
            k = k - 1;
        end
        hops_lb(pos, M) = v(1);
    end
end

%% Plots
for i = 1:length(D_vec)
    figure, plot(1:M_max, hops_ub(i, :), 1:M_max, hops_lb(i, :))
    legend('ub', 'lb')
end