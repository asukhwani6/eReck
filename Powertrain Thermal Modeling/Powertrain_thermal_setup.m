load Result_254272161.mat
motorHeatGen = Result.qMotor(:,4);
mcuHeatGen = motorHeatGen;
timeEnd = length(motorHeatGen);
time = (1:timeEnd);
Tamb = 33; % C

% Motor
massMotor = 3.55; %kg
cAl = 904; %J/kg*K

% MCU
massMCU = 11 / 4 * .5; %kg
% Flow rate = 1.5 bar / 10 l/min

d = 0.008636
A = pi * (d / 2) .^ 2;