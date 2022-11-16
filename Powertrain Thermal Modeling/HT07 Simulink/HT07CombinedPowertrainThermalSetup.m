% clear
%% Accumulator Thermal Model Setup
HT07_Simulink_Setup;

%% Environment and properties
Tamb = 26; % C
cAl = 904; %J/kg*K
waterKinematicViscosity40C = 0.0000010533; % m^2 / s
waterDensity = 997; % kg / m^3

%% Radiator Initialization

radiator.aerodynamicFactor = 0.45;
radiator.Mass = 1.1; % kg
radiator.SurfaceRoughness = 3.2e-6;
radiator.CoreHeight = (6.5 * 25.4 / 1000);
radiator.CoreWidth = (5.125 * 25.4 / 1000); % m
radiator.finHeight = .0046; % m
radiator.finWidth = 0.042; % m
radiator.finDepth = 0.0018; % m
radiator.waterChannelOuterHeight = 0.0017; % m
radiator.waterVolumeL = 0.54; % L
radiator.wallThermalResistance = 5e-6;

radiator = dualPassRadiatorInit(radiator);

%% Pump Initialization

load EBP40_Pump_Data.mat
% Scale pump capacity to adjust for experimental data vs pump curve given
% by manufacturer: "Pump Max Flowrate Test"​ slide in shorturl.at/BOU46
pumpCapacity = pumpCapacity/2.5;

load EnduranceLapSim-9-15-22.mat

%% Data Initialization

Result.qMotor(:,1) = mean(Result.qMotor(:,1))*ones(length(Result.qMotor(:,1)),1);
motorRearHeatGen = 0;
Result.qMotor(:,3) = mean(Result.qMotor(:,3))*ones(length(Result.qMotor(:,3)),1);
motorFrontHeatGen = 0;
Result.qInverter(:,1) = mean(Result.qInverter(:,1))*ones(length(Result.qInverter(:,1)),1);
mcuHeatGen = 0;
velocity = 0;
time = 0;

for i = 1:11
    motorRearHeatGen = [motorRearHeatGen;Result.qMotor(:,1)];
    motorFrontHeatGen = [motorFrontHeatGen;Result.qMotor(:,3)];
    mcuHeatGen = [mcuHeatGen;Result.qInverter(:,1)];
    velocity = [velocity;Result.v];
    time = [time;time(end) + Result.t + 0.001];
end
motorRearHeatGen = [motorRearHeatGen;0;0];
motorFrontHeatGen = [motorFrontHeatGen;0;0];
mcuHeatGen = [mcuHeatGen;0;0];
velocity = [velocity;0;0];
time = [time; time(end) + 0.001; time(end) + 300];
for i = 1:11
    motorRearHeatGen = [motorRearHeatGen;Result.qMotor(:,1)];
    motorFrontHeatGen = [motorFrontHeatGen;Result.qMotor(:,3)];
    mcuHeatGen = [mcuHeatGen;Result.qInverter(:,1)];
    velocity = [velocity;Result.v];
    time = [time;time(end) + Result.t + 0.001];
end
time = [time;time(end) + 0.001];
velocity = [velocity;0];
motorRearHeatGen = [motorRearHeatGen;0];
motorFrontHeatGen = [motorFrontHeatGen;0];
mcuHeatGen = [mcuHeatGen;0];
timeEnd = time(end);

mask = velocity < 0.25;
velocity(mask) = 4/radiator.aerodynamicFactor;

motorHeatEnergyRear = cumtrapz(time,motorRearHeatGen);
motorHeatEnergyFront = cumtrapz(time,motorFrontHeatGen);

%% Tubing

d = 0.00914; % AR-06-HTP hose inner diameter m
A = pi * (d / 2) .^ 2;
% Minor loss https://www.engineeringtoolbox.com/minor-loss-coefficients-pipes-d_626.html
K90 = 0.5; % CHECK AGAIN
KStraight = 0.08;% CHECK AGAIN
tubeRoughness = 3.2e-6; %m% CHECK AGAIN
volumeFlowRateGuess = 5; % L/min CHECK AGAIN
volumeFlowRateGuess = volumeFlowRateGuess/60000; % m^3/s
velocityFlowRate = volumeFlowRateGuess/A; % m/s
tubeReGuess = velocityFlowRate*d/waterKinematicViscosity40C;
tubeFrictionFactor = 64/tubeReGuess; % CHECK AGAIN

tubeLengthPumpToMCU =  17.33 * 25.4 / 1000; %m BMRS 1x right angle, 1x straight
KtotLengthPumpToMCU = K90 + KStraight;
leqPumpToMCU = KtotLengthPumpToMCU * d ./ tubeFrictionFactor;

tubeLengthMCUToMotor =  4  * 25.4 / 1000;% m BMRS 2x right angle connector
KtotMCUToMotor = K90 * 2;
leqMCUToMotor = KtotMCUToMotor * d ./ tubeFrictionFactor;

tubeLengthMotorToRadiator = 27.6875  * 25.4 / 1000; % m BMRS 1x right angle, 1x straight​
KtotMotorToRadiator = K90 + KStraight;
leqMotorToRadiator = KtotMotorToRadiator * d ./ tubeFrictionFactor;

% ESTIMATE - NEED TO MEASURE AGAIN
tubeLengthRadiatorToPump = 0.3; % m 

%% Accumulator
accChannel.Num = 3;
accChannel.Width = 0.008; % m
accChannel.Height = 0.01; % m
accChannel.Length = 1.3; % m
accChannel.AbsoluteRoughness = 3.2e-6;

accChannel = accChannelInit(accChannel);

%% Motor AMK
motor.Mass = 3.5; %kg (50% stated mass)
motor.CoolingJacketHalfCircleDiameter = 0.015; % m
motor.CoolingJacketLength = 1; % m
motor.CoolingJacketAbsoluteRoughness = 15e-6; % LOW CONFIDENCE

motor = motorJacketInit(motor);

%% Inverters AMK
coldPlateMassMCU = 2.94; %kg (COOLING PLATE MASS PER DOUBLE INVERTER SET)
mcuColdPlateDiameter = 0.01; % m
mcuColdPlateFlowArea = (mcuColdPlateDiameter^2)*pi/4; % m^2
mcuColdPlateLength = 1.2; % m
kTotMCUColdPlate = K90*6;
leqMCU = kTotMCUColdPlate * mcuColdPlateDiameter./tubeFrictionFactor;

% ?examples
% sscfluids_ev_battery_cooling
% sscfluids_ev_thermal_management