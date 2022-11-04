x = 0:10000;
fx = -0.001379 * x .^ 2 + 3.542 * x + 7.922;
[fxmax, fxmaxI] = max(fx);
plot(x, fx)
hold on
plot(fxmaxI, fxmax, 'x')
title('Tire Fx vs Fz');
xlabel('Fx (N)');
ylabel('Fx (N)');


% ht06
% wheelBase = 1530E-3;
% frontBore = 20.6E-3;% AP Racing CP4400-93 PRM 135 E 
% rearBore = 23.8E-3; % AP Racing CP4400-95 PRM 135 E
% mass = 175;
% pedalRatio = 7.1875;
% rearBrakeRadius = 66.93E-3+ (12.36E-3 ./ 2);
% frontBrakeRadius = (70.52E-3 + 86.43E-3) ./ 2;
% cgHeight = 198E-3;
% frontWeightFrac = .5086;
% totalDownForce = 383.02 + 435.68; 
% CoP = 0.870; 

% Ht07
wheelBase = 1.55; % m
frontBore = 0.6250 * 25.4E-3;  % Tilton 78-Series  5/8"
rearBore = 7/8 * 25.4E-3; % Tilton 78-Series  7/8"
mass = 271;
pedalRatio = 7.1875;
rearBrakeRadius = (70.52E-3 + 86.43E-3) ./ 2; 
frontBrakeRadius = (70.52E-3 + 86.43E-3) ./ 2;
cgHeight = 0.197;
frontWeightFrac = 0.501;%
CLA = 3.8;
% initialVelocity = 29.5; % m /s
initialVelocity = 20.5; % m /s
% initialVelocity = 2.5; % m /s
rhoAir = 1.204;% kg/m^3
totalDownForce = CLA * initialVelocity .^ 2 * .5 .* rhoAir;
CoP = 0.50;

frontCylinderArea = (frontBore ./ 2) .^ 2 .* pi;
rearCylinderArea = (rearBore ./ 2) .^ 2 .* pi;
g = 9.81;
rearBrakeCaliperArea = pi * (1.25 .* 25.4 .* 1E-3) ^ 2 ./ 4;% Wilwood GP200 
frontBrakeCaliperArea = pi * (1.25 .* 25.4 .* 1E-3) ^ 2 ./ 4;% Wilwood GP200 

brakePadFriction = 0.37; % 150-14407k Sintered Metallic
loadedTireRadius = 416.56E-3 ./2 ;

% maxDecel = 2.3141;
% maxDecel = 1.57;
% maxDecel = 2.4765;
maxDecel = 1.9905;

rearWeightTransfer = cgHeight .* mass .* -maxDecel ./ wheelBase;
rearWeightBrake = mass .* g .* (1 - frontWeightFrac) + rearWeightTransfer .* g;
frontWeightBrake = mass .* g .* frontWeightFrac - rearWeightTransfer .* g;
FXrear = (0.5 * (-0.001379*(rearWeightBrake .* 0.224809).^2 + 3.542 * (rearWeightBrake .* 0.224809) + 7.922)) ./ 0.224809; % equation in lbf so convert to lbf and back to N, 0.5 scaling factor to convert the sandpaper roller data to asphalt
FXfront = (0.5 * (-0.001379*(frontWeightBrake .* 0.224809).^2 + 3.542* (frontWeightBrake .* 0.224809) + 7.922)) ./ 0.224809; % equation in lbf so convert to lbf and back to N, 0.5 scaling factor to convert the sandpaper roller data to asphalt



FrontDownforce = totalDownForce * (CoP ./ wheelBase);
RearDownforce = totalDownForce * (1 - (CoP ./ wheelBase));

FXrearAero = (0.5*(-0.001379*((rearWeightBrake + RearDownforce) .* 0.224809).^2 + 3.542* ((rearWeightBrake + RearDownforce) .* 0.224809) + 7.922)) ./ 0.224809  % equation in lbf so convert to lbf and back to N, 0.5 scaling factor to convert the sandpaper roller data to asphalt
FXfrontAero = (0.5*(-0.001379*((frontWeightBrake + FrontDownforce) .* 0.224809).^2 + 3.542* ((frontWeightBrake + FrontDownforce) .* 0.224809) + 7.922)) ./ 0.224809 % equation in lbf so convert to lbf and back to N, 0.5 scaling factor to convert the sandpaper roller data to asphalt
syms idealBias
inputForceAero = FXfrontAero .* (frontCylinderArea .* loadedTireRadius ./ (pedalRatio .* frontBrakeCaliperArea .* 2 .* frontBrakeRadius .* brakePadFriction)) .* (1 ./ idealBias) == FXrearAero .* (rearCylinderArea .* loadedTireRadius ./ (pedalRatio .* rearBrakeCaliperArea .* 2 .* rearBrakeRadius .* brakePadFriction)) .* (1 ./ (1 - idealBias))
inputForce = FXfront .* (frontCylinderArea .* loadedTireRadius ./ (pedalRatio .* frontBrakeCaliperArea .* 2 .* frontBrakeRadius .* brakePadFriction)) .* (1 ./ idealBias) == FXrear .* (rearCylinderArea .* loadedTireRadius ./ (pedalRatio .* rearBrakeCaliperArea .* 2 .* rearBrakeRadius .* brakePadFriction)) .* (1 ./ (1 - idealBias))

Saero = solve(inputForceAero) % ideal bias including aero effects
S = solve(inputForce) % ideal bias w/o aero effects

brakeBias = double(Saero)
% brakeBias = .53
brakeDecel = (FXrearAero + FXfrontAero) ./ (mass .* g)
brakePedalEffortPerGofStoppingForce = (1 ./ pedalRatio) .* (((brakeBias .* frontBrakeCaliperArea .* frontBrakeRadius)  ./  frontCylinderArea) + (((1 - brakeBias) .* rearBrakeCaliperArea .* rearBrakeRadius) ./ rearCylinderArea)) .^ -1 .* loadedTireRadius ./ (4 .* brakePadFriction) .* g .* mass

lockIN = brakeDecel .* brakePedalEffortPerGofStoppingForce
lockINFront = FXfrontAero .* 0.5 .* (frontCylinderArea .* loadedTireRadius ./ (pedalRatio .* frontBrakeCaliperArea .* 2 .* frontBrakeRadius .* brakePadFriction)) .* (1 ./ brakeBias) % 0.5 factor b/c FX for 2 wheel, and rest for 1 wheel
lockINRear = FXrearAero .* 0.5 .* (rearCylinderArea .* loadedTireRadius ./ (pedalRatio .* rearBrakeCaliperArea .* 2 .* rearBrakeRadius .* brakePadFriction)) .* (1 ./ (1 - brakeBias)) % 0.5 factor b/c FX for 2 wheel, and rest for 1 wheel

