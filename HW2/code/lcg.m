%

clear all;
close all;
clc;

profile on;

%% Consider the two LCGs: LCG1: a = 18, m = 101; LCG2: a = 2, m = 101
% a. Check whether they are full period
% b. Plot all pairs (Ui, Ui+1) in a unit square and comment the results

% LCG 1
x0 = 17;
a = 53;
m = 101;

sequence_1 = zeros(m - 1, 1); % note: 0 is a standpoint for a multiplicative LCG,
% it will never be reached. Because of this the period is at most m-1

sequence_1(1) = x0;
for i = 2:m-1
    sequence_1(i) = mod(a*sequence_1(i-1), m);
end

% normalize
sequence_1 = sequence_1/m;

if (size(sequence_1) == size(unique(sequence_1)))
    if (sort(sequence_1) == unique(sequence_1))  % unique sorts the values
        disp('LCG1 full period!')
    end
end



figure, scatter(sequence_1(1:m-2), sequence_1(2:m-1))
title('Lag plot for LCG1, lag = 1')
figure, scatter3(sequence_1(1:m-3), sequence_1(2:m-2), sequence_1(3:m - 1))
title('Lag plot for LCG1 in three dimensions, lag = 1 and lag = 2')


% LCG 2
x0 = 17;
a = 2;
m = 101;

sequence_2 = zeros(m - 1, 1); % note: 0 is a standpoint for a multiplicative LCG,
% it will never be reached. Because of this the period is at most m-1

sequence_2(1) = x0;
for i = 2:m-1
    sequence_2(i) = mod(a*sequence_2(i-1), m);
end

% normalize
sequence_2 = sequence_2/m;

if (size(sequence_2) == size(unique(sequence_2)))
    if (sort(sequence_2) == unique(sequence_2)) % unique sorts the values
        disp('LCG1 full period!')
    end
end


figure, scatter(sequence_2(1:m-2), sequence_2(2:m-1))
title('Lag plot for LCG2, lag = 1')


%% Consider the LCG with a = 65539, m = 2^31
% a. Plot all pairs (Ui, Ui+1) in a unit square and comment the results
% b. Plot all triples (Ui, Ui+1, Ui+2) in a unit cube and comment the results

% LCG 3
x0 = 1;
a = 65539;
m = 2^31;

limit = floor(10000);
sequence_1 = zeros(limit - 1, 1); % note: 0 is a standpoint for a multiplicative LCG,
% it will never be reached. Because of this the period is at most m-1

sequence_1(1) = x0;
for i = 2:limit-1
    sequence_1(i) = mod(a*sequence_1(i-1), m);
end

sequence_1 = sequence_1/m;

% if (size(sequence) == size(unique(sequence)))
%     if (sequence == sequence(unique(sequence)))
%         disp('LCG2 full period!')
%     end
% end

figure, scatter(sequence_1(1:limit-2), sequence_1(2:limit-1), 3)
title('Lag plot for RANDU in two dimensions, lag = 1, x0 = 1')
figure, scatter3(sequence_1(1:limit-3), sequence_1(2:limit-2), sequence_1(3:limit - 1), 1)
title('Lag plot for RANDU in three dimensions, lag = 1 and lag = 2, x0 = 1')