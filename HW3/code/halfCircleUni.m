function [ point ] = halfCircleUni( n )
% Generates n uniform points in half a circle
point = zeros(n, 2);
for i = 1:n
    xy = 2*rand(1, 2)-1;
    while (sqrt(xy(1)^2 + xy(2)^2) > 1 || xy(1) < 0)
        xy = 2*rand(1, 2)-1;
    end
    point(i, :) = xy;
end

end

