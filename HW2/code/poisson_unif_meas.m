%% Poisson(lambda)
lambda = 100;
%profile on

experiments = 100;
begin = 20;
step = 10;
limit = 740;
time_prod = zeros(limit/step, 1);
iter_prod = zeros(limit/step, 1);
i = 1;
for lambda = begin:step:limit

%% The same as before, note that sum(exp(lambda))<1 <=> sum(-1/lambda * ln(U))<1 <=>  ln(prod(U)) > -lambda <=> prod(U) > exp(-lambda)
    
    
    rng('default');
    
    iter = 0;
    bound = exp(-lambda);
    X_prod = zeros(experiments, 1);
    for j = 1:experiments
        
        X_prod(j) = 0;
        prod = rand();
        while (prod >= bound)
            tic;
            X_prod(j) = X_prod(j) + 1;
            prod = prod*rand();
            time_prod(i) = toc;
            i = i + 1;
            iter = iter + 1;
        end 
        
    end
    iter_prod(lambda/step) = iter;
   
    
    disp(strcat('Iteration with lambda=', num2str(lambda), ' time prod= ', num2str(time_prod(lambda/step))))
    
end