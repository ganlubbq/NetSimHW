function [point] = hexauni(num)
% Generation of uniform samples in an hexagon of ray 1 with rejection
% sampling
point =  zeros(num, 2);
for n = 1:num
    % draw x, y uniform resp in [-sqrt(3)/2, sqrt(3)/2], [-1/2, 1]
    x = sqrt(3)*rand() - sqrt(3)/2;
    y = 3/2*rand() - 1/2;
    
    if (y >= -abs(x)/sqrt(3) + 1)
        y = y - 3/2;
        x = -sign(x)*(sqrt(3)/2 -sign(x)*x);
    end
    
    point(n, :) = [x, y];
end
end

