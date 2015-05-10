function [ D_step ] = GeRaFstep( D, M )
% Function that simulates a step in GeRaF protocol

% The number of nodes in half of the circle is a Poisson of mean M pi/2
nnodes = poisson_cdfinv(M*pi/2);
if (nnodes > 0)
    position = halfCircleUni(nnodes);
    distance = sqrt((D - position(:, 1)).^2 + position(:, 2).^2);
    D_step = min(distance);
else
    D_step = D;
end

end

