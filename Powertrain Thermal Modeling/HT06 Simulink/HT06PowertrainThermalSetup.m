clear

%% Environment and properties
Tamb = 26; % C
cAl = 904; %J/kg*K
waterKinematicViscosity40C = 0.0000010533; % m^2 / s
waterDensity = 997; % kg / m^3

%% Pump Initialization

load EBP40_Pump_Data.mat
% Scale pump capacity to adjust for experimental data vs pump curve given
% by manufacturer: "Pump Max Flowrate Test"​ slide in shorturl.at/BOU46
pumpCapacity = pumpCapacity/2.5;

%% Radiator Initialization

radiator.aerodynamicFactor = 0.45; % HT07 AERODYNAMIC SIMULATIONS ESTIMATE 50% IMPROVEMENT IN AIR MASS FLOW THROUGH RADIATOR
radiator.Mass = 1.1; % kg
radiator.SurfaceRoughness = 3.2e-6;
radiator.CoreHeight = (6.5 * 25.4 / 1000);
radiator.CoreWidth = (5.125 * 25.4 / 1000); % m
radiator.finHeight = .0046; % m
radiator.finWidth = 0.042; % m HT07 RADIATOR PLANNED TO USE 55 mm CORE THICKNESS INSTEAD OF 42 mm
radiator.finDepth = 0.0018; % m
radiator.waterChannelOuterHeight = 0.0017; % m
radiator.waterVolumeL = 0.54; % L
radiator.wallThermalResistance = 5e-6;

radiator = dualPassRadiatorInit(radiator);

%% Vehicle Initialization
load FSAEMichigan2022_HT06Data.mat
effData = load('graphDataEmrax208.mat');
gearRatio = 4.4; % rpm/rpm
tireRadius = 0.2; % m

% Extract Data
motorTorque = S.torque_feedback;
motorSpeedRPM = S.motor_speed;
modTempA = S.module_a_temperature;
gateTemp = S.gate_driver_board_temperature;

% Convert Data
motorTorque(:,1) = motorTorque(:,1)/1000;
motorSpeedRPM(:,1) = motorSpeedRPM(:,1)/1000;
motorSpeedRPM(:,2) = -motorSpeedRPM(:,2);
motorTorque(:,2) = -motorTorque(:,2);
modTempA(:,1) = modTempA(:,1)/1000;
gateTemp(:,1) = gateTemp(:,1)/1000;
motorTorque = uniqueData(motorTorque);
motorSpeedRPM = uniqueData(motorSpeedRPM);
modTempA = uniqueData(modTempA);
gateTemp = uniqueData(gateTemp);

% Interpolate to common time vector
time = linspace(min(motorTorque(:,1)),max(motorTorque(:,1))-100,30000);
timeEnd = time(end);
interpTorque = interp1(motorTorque(:,1),motorTorque(:,2),time);
interpSpeedRPM= interp1(motorSpeedRPM(:,1),motorSpeedRPM(:,2),time);
interpSpeedRadS = interpSpeedRPM * 0.10472;

% Emrax 208 efficiency model
for i = 1:length(interpTorque)
[efficiency(i)] = efficiencyEmrax208(interpSpeedRPM(i), interpTorque(i), effData, 0);
end

% More initialization
motorPower = interpTorque.*interpSpeedRadS;
motorAirCooledRadius = 0.104; % m
motorArea = 0.075; %m^2
motorSurfaceVelocity = interpSpeedRadS*motorAirCooledRadius;
motorHeatGen = (1-efficiency).*motorPower;
mcuHeatGen = (1-0.97)*interpTorque.*interpSpeedRadS;
velocity = (interpSpeedRadS./gearRatio).*tireRadius;

% Set minimum modeled speed to 0.25 m/s - simulates some airflow during
% driver change from natural convection and wind
mask = velocity < 0.25;
velocity(mask) = 0.25;

% Motor Emrax 208
massMotor = 4.5; %kg (100% Stated Mass)
% MCU
moduleBoardMassMCU = 0.1; %kg (TUNED VARIABLE - EQUIVALENT MASS OF COOLED COMPONENTS)
massMCU = 1.5; %kg (TUNED VARIABLE - EQUIVALENT MASS OF COOLED COMPONENTS)

%% Tubing
d = 0.00914; % AR-06-HTP hose inner diameter m
A = pi * (d / 2) .^ 2;
% Minor loss https://www.engineeringtoolbox.com/minor-loss-coefficients-pipes-d_626.html
K90 = 0.5; % CHECK AGAIN
KStraight = 0.08;% CHECK AGAIN
tubeRoughness = 3.2e-6; %m% CHECK AGAIN

volumeFlowRate = 5; % L/min CHECK AGAIN
volumeFlowRate = volumeFlowRate/60000; % m^3/s
velocityFlowRate = volumeFlowRate/A; % m/s
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

tubeLengthRadiatorToPump = 0.3; % m 

% ?examples
% sscfluids_ev_battery_cooling
% sscfluids_ev_thermal_management