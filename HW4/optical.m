close all;
clc;
clear;

load('E0lut015.txt');
load('E0lut04.txt');
load('E0lut219.txt');
Ar =    1.1 * 10^(-6); % 1.1 mm^2
At =    10 * 10^(-6); % 10 mm^2
Beta =  0; % 0 rad, perfect allignment
Theta = 0.5; % 0.5 rad of diverge angle
q =     1.6 * 10^(-19); % electronic charge [C]
K =     1.38 * 10^(-23); % Bolzmann constant
T =     293.15; % = 20°C temperature [K]
S =     0.26; % sensitivity of the photodiode SI PIN [A/W]
Id =    1 * 10^(-9); % dark current = 1 nA
Il =    1 * 10^(-6); % equal to the short circuit current, 1uA
R =     1.43 * 10^9; % shunt resistance
BW =    100*10^3; % bandwidth 100 KHz
SNR = 10^(20/10); % 20dB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                EXERCISE 1                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO1: create LUT of Eo vs z(m) and import it%
% TODO2: plot Eo vs depth z(m)                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure,
semilogy(E0lut015(:, 1), E0lut015(:, 2)), hold on,
semilogy(E0lut04(:, 1), E0lut04(:, 2)), hold on,
semilogy(E0lut219(:, 1), E0lut219(:, 2))
legend('c = 0.15', 'c=0.4', 'c=2.19'),
xlabel('z [m]')
ylabel('E_0')
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                EXERCISE 2                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO1: calcolate Ptx to obtain an SNR = 20 db%
%        @ 10 m range by varying Eo            %
% TODO2: plot Ptc vs z(m)                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d = 10;
SNR_dB = 20;
SNR_lin = 10^(SNR_dB/10);

c = 0.15;
Na015 = (S*E0lut015(:, 2)*Ar).^2;
P_015 = sqrt(SNR*(2*q*(Id+Il)*BW + 4*K*T*BW/R + Na015))/S;
Ptx_015 = P_015.*(pi * d^2*(1-cos(Theta)) + 2*At)*exp(c*d)/(2*Ar*1);

c = 0.4;
Na04 = (S*E0lut04(:, 2)*Ar).^2;
P_04 = sqrt(SNR*(2*q*(Id+Il)*BW + 4*K*T*BW/R + Na04))/S;
Ptx_04 = P_04.*(pi * d^2*(1-cos(Theta)) + 2*At)*exp(c*d)/(2*Ar*1);

c = 2.19;
Na219 = (S*E0lut219(:, 2)*Ar).^2;
P_219 = sqrt(SNR*(2*q*(Id+Il)*BW + 4*K*T*BW/R + Na219))/S;
Ptx_219 = P_219.*(pi * d^2*(1-cos(Theta)) + 2*At)*exp(c*d)/(2*Ar*1);

figure, semilogx(E0lut015(:, 2), 10*log10(Ptx_015)), hold on,
semilogx(E0lut04(:, 2), 10*log10(Ptx_04)), hold on,
semilogx(E0lut219(:, 2), 10*log10(Ptx_219)),
legend('c = 0.15', 'c = 0.4', 'c = 2.19')
xlabel('E_0'), ylabel('Ptx [dB]'), grid on

figure, plot(E0lut015(:, 2), 10*log10(Ptx_015)), hold on,
plot(E0lut04(:, 2), 10*log10(Ptx_04)), hold on,
plot(E0lut219(:, 2), 10*log10(Ptx_219)),
legend('c = 0.15', 'c = 0.4', 'c = 2.19')
xlabel('E_0'), ylabel('Ptx [dB]'), grid on

figure, plot(E0lut015(:, 1), 10*log10(Ptx_015)), hold on,
plot(E0lut04(:, 1), 10*log10(Ptx_04)), hold on,
plot(E0lut219(:, 1), 10*log10(Ptx_219)),
legend('c = 0.15', 'c = 0.4', 'c = 2.19')
xlabel('z [m]'), ylabel('Ptx [dB]'), grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       OPTIONAL: EXERCISE 3                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO1: compute the range to obtain an  SNR %
%        = 20 db with a Ptx = Ptx_max = 100 W  %
%        by varying Eo                         %
% TODO2: plot range vs depth z(m)              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
d = (0:0.001:50).';

c = 0.15;
Ptx_max = 100;
Na015 = (S*E0lut015(:, 2)*Ar).^2;
P_015 = sqrt(SNR*(2*q*(Id+Il)*BW + 4*K*T*BW/R + Na015))/S;
P_015_2 = 2*Ptx_max*Ar./(pi*d.^2*(1-cos(Theta)) + 2*At).*exp(-c.*d);
for i = 1:length(P_015) % cycle on the P given by varying E0
    % find which P_015_2 is closer to the other P, then for that E0 then
    % the corresponding d will be the one used
    [~, ind] = min(abs(P_015_2 - P_015(i)));
    % create vectors
    E0_vec_015(i) = E0lut015(i, 2);
    z_vec_015(i) = E0lut015(i, 1);
    d_vec_015(i) = d(ind);
end

c = 0.4;
Ptx_max = 100;
Na04 = (S*E0lut04(:, 2)*Ar).^2;
P_04 = sqrt(SNR*(2*q*(Id+Il)*BW + 4*K*T*BW/R + Na04))/S;
P_04_2 = 2*Ptx_max*Ar./(pi*d.^2*(1-cos(Theta)) + 2*At).*exp(-c.*d);
for i = 1:length(P_04) % cycle on the P given by varying E0
    % find which P_04_2 is closer to the other P, then for that E0 then
    % the corresponding d will be the one used
    [~, ind] = min(abs(P_04_2 - P_04(i)));
    % create vectors
    E0_vec_04(i) = E0lut04(i, 2);
    z_vec_04(i) = E0lut04(i, 1);
    d_vec_04(i) = d(ind);
end

c = 2.19;
Ptx_max = 100;
Na219 = (S*E0lut219(:, 2)*Ar).^2;
P_219 = sqrt(SNR*(2*q*(Id+Il)*BW + 4*K*T*BW/R + Na219))/S;
P_219_2 = 2*Ptx_max*Ar./(pi*d.^2*(1-cos(Theta)) + 2*At).*exp(-c.*d);
for i = 1:length(P_219) % cycle on the P given by varying E0
    % find which P_219_2 is closer to the other P, then for that E0 then
    % the corresponding d will be the one used
    [~, ind] = min(abs(P_219_2 - P_219(i)));
    % create vectors
    E0_vec_219(i) = E0lut219(i, 2);
    z_vec_219(i) = E0lut219(i, 1);
    d_vec_219(i) = d(ind);
end


figure, plot(E0_vec_015, d_vec_015, E0_vec_04, d_vec_04, E0_vec_219, d_vec_219)
grid on, legend('c = 0.15', 'c = 0.4', 'c = 2.19'), ylabel('d_{max} [m]'),
xlabel('E_0')

figure, semilogx(E0_vec_015, d_vec_015), hold on,
semilogx(E0_vec_04, d_vec_04), hold on,
semilogx(E0_vec_219, d_vec_219)
grid on, legend('c = 0.15', 'c = 0.4', 'c = 2.19'), ylabel('d_{max} [m]'),
xlabel('E_0')

figure, plot(z_vec_015, d_vec_015, z_vec_04, d_vec_04, z_vec_219, d_vec_219)
grid on, legend('c = 0.15', 'c = 0.4', 'c = 2.19'), ylabel('d_{max} [m]'),
xlabel('z [m]')
