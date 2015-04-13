clear all;
close all;
clc;

%% 6.5

x0 = 1;
a = 16807;
m = 2^31 - 1;

limit = 1000;
sequence = zeros(limit, 1); % note: 0 is a standpoint for a multiplicative LCG,
% it will never be reached. Because of this the period is at most m-1

sequence(1) = x0;
for i = 2:limit
    sequence(i) = mod(a*sequence(i-1), m);
end

uni_mat = m*rand(1, 1000); %1000 samples from a unif(0, m)
autoc = autocorrelation(sequence, 30);

figure; 

% axes handling
h(1) = subplot(7, 3, 21);
h(2) = subplot(7, 3, 20);
h(3) = subplot(7, 3, 19);
h(4) = subplot(7, 3, 18);
h(5) = subplot(7, 3, 17);
h(6) = subplot(7, 3, 16);
h(7) = subplot(7, 3, 15);
h(8) = subplot(7, 3, 14);
h(9) = subplot(7, 3, 13);
h(10)= subplot(4, 1, 2);
h(11)= subplot(4, 1, 1);

% plot
qqplot(uni_mat, sequence)
title(h(11), 'QQplot');
axis(h(11), [0, m-1, 0, m-1])

stem(h(10), autoc(2:end))
title(h(10), 'Autocorrelation');


for i = 1:9
    scatter(h(10 - i), sequence(1:100), sequence(i*100+1:(i+1)*100), '.');
    j = 10 - i;
    title(h(10 - i), sprintf('h = %d', i*100));
    axis(h(10 - i), [0, m-1, 0, m-1])
end

%% 6.7
sequence_fromtwo = zeros(limit, 1);
sequence_fromend = zeros(limit, 1); % note: 0 is a standpoint for a multiplicative LCG,
% it will never be reached. Because of this the period is at most m-1

sequence_fromtwo(1) = 2;
sequence_fromend(1) = sequence(end);
for i = 2:limit
    sequence_fromtwo(i) = mod(a*sequence_fromtwo(i-1), m);
    sequence_fromend(i) = mod(a*sequence_fromend(i-1), m);
end

figure, scatter(sequence, sequence_fromtwo)
axis([0, m-1, 0, m-1])
figure, scatter(sequence, sequence_fromend)
axis([0, m-1, 0, m-1])

%% 6.10
rng('default');

% rejection method
samples = 2000;
a = 10;
X_rej = zeros(samples, 1);
for i = 1:samples
    X = 2 * a * rand() - a;
    U = rand();
    while(U > (sin(X)/X)^2)
        X = 2 * a * rand() - a;
        U = rand();
    end
    X_rej(i) = X;
end

X_geom = zeros(samples, 2);
for i = 1:samples
    uni = rand(3, 1); % [X1, X2, U]
    while(uni(3) > abs(uni(1)-uni(2)))
        uni = rand(3, 1);
    end
    X_geom(i, :) = uni(1:2);
end

figure
subplot(1, 2, 1)
histogram(X_rej, 200)
subplot(1, 2, 2)
scatter(X_geom(:, 1), X_geom(:, 2), '.')
    

