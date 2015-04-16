%% Poisson as number of arrivals in [0,1] with exp(lambda) interarrival time
 
%% Poisson(lambda)
lambda = 100;
%profile on

experiments = 100;
begin = 20;
step = 10;
limit = 740;
time_exp = zeros(limit/step, 1);
iter_exp = zeros(limit/step, 1);
m = 1;

for lambda = begin:step:limit

    rng('default');
    
    
    iter = 0;
    X_exp = zeros(experiments, 1);
    for j = 1:experiments
        
        % Generation of an exp(lambda) rv
        E = -1/lambda * log(rand()); % interarrival times
        i = E; % time of last arrival
        X = 0; % number of arrivals (which is the poisson of intensity lambda*t, I set t = 1)
        % if the time of last arrival is greater than 1 we're done
        
        while(i <= 1)
            tic;
            X = X + 1;
            E = -1/lambda * log(rand());
            i = i + E; % next arrival time
            iter = iter + 1;
            time_exp(m) = toc;
        m = m + 1;
        end
        X_exp(j) = X;
        
    end
    iter_exp(lambda/step) = iter;
    time_exp(lambda/step) = toc;
    disp(strcat('Iteration with lambda=', num2str(lambda), ' time exp= ', num2str(time_exp(lambda/step))))
    % The same as before, note that sum(exp(lambda))<1 <=> sum(-1/lambda * ln(U))<1 <=>  ln(prod(U)) > -lambda <=> prod(U) > exp(-lambda)
    
    
end