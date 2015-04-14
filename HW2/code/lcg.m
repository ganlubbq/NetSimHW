%

clear all;
close all;
clc;

profile on;

%% Consider the two LCGs: LCG1: a = 18, m = 101; LCG2: a = 2, m = 101
% a. Check whether they are full period
% b. Plot all pairs (Ui, Ui+1) in a unit square and comment the results

% LCG 1
x0 = 1;
a = 18;
m = 101;

sequence = zeros(m - 1, 1); % note: 0 is a standpoint for a multiplicative LCG,
% it will never be reached. Because of this the period is at most m-1

sequence(1) = x0;
for i = 2:m-1
    sequence(i) = mod(a*sequence(i-1), m);
end

if (size(sequence) == size(unique(sequence)))
    if (sequence == sequence(unique(sequence)))
        disp('LCG1 full period!')
    end
end

figure, scatter(sequence(1:m-2), sequence(2:m-1))


% LCG 2
x0 = 1;
a = 2;
m = 101;

sequence = zeros(m - 1, 1); % note: 0 is a standpoint for a multiplicative LCG,
% it will never be reached. Because of this the period is at most m-1

sequence(1) = x0;
for i = 2:m-1
    sequence(i) = mod(a*sequence(i-1), m);
end

if (size(sequence) == size(unique(sequence)))
    if (sequence == sequence(unique(sequence)))
        disp('LCG2 full period!')
    end
end

figure, scatter(sequence(1:m-2), sequence(2:m-1))


%% Consider the LCG with a = 65539, m = 2^31
% a. Plot all pairs (Ui, Ui+1) in a unit square and comment the results
% b. Plot all triples (Ui, Ui+1, Ui+2) in a unit cube and comment the results

% LCG 3
x0 = 1;
a = 65539;
m = 2^31;

limit = floor(1000);
sequence = zeros(limit - 1, 1); % note: 0 is a standpoint for a multiplicative LCG,
% it will never be reached. Because of this the period is at most m-1

sequence(1) = x0;
for i = 2:limit-1
    sequence(i) = mod(a*sequence(i-1), m);
end

% if (size(sequence) == size(unique(sequence)))
%     if (sequence == sequence(unique(sequence)))
%         disp('LCG2 full period!')
%     end
% end

figure, scatter(sequence(1:limit-2), sequence(2:limit-1))
figure, scatter3(sequence(1:limit-3), sequence(2:limit-2), sequence(3:limit - 1))