
close all;
clc;

%% Implement the generation of a Binomial rv in the three ways we saw in
% class (CDF inversion, using a sequence of n Bernoulli variables,
% using geometric strings of zeros), and then compare the time
% it takes to produce a large number of iid variates

%% BIN(n, p)

experiments = 10;
time_inv = zeros(2000/20, 5);
time_ber = zeros(2000/20, 5);
time_geo = zeros(2000/20, 5);


for n = 20:20:2000
    for p = 0.1:0.1:0.5
        %% CDF Inversion
        rng('default');
        
        tic;
        
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
        err_inv = mean(X_inv) - n*p;
        
        time_inv(floor(n/20), floor(p*10)) = toc;
        
        %% Series of Bernoulli
        
        rng('default');
        
        tic;
        
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
        err_ber = mean(X_ber) - n*p;
        
        time_ber(n/20, floor(p*10)) = toc;
        %% Strings of zeros of length G(p)
        
        rng('default');
        
        tic;
        
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
        err_geo = mean(X_geo) - n*p;
        
        time_geo(n/20, floor(p*10)) = toc;
    end
end