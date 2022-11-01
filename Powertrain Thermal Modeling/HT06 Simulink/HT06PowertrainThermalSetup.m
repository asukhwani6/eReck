load FSAEMichigan2022_HT06Data.mat
effData = load('graphDataEmrax208.mat');
gearRatio = 4.4;
tireRadius = 0.2; % m
load EBP40_Pump_Data.mat

motorTorque = S.torque_feedback;
motorSpeedRPM = S.motor_speed;
modTempA = S.module_a_temperature;
gateTemp = S.gate_driver_board_temperature;

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

time = linspace(min(motorTorque(:,1)),max(motorTorque(:,1))-100,30000);
timeEnd = time(end);

interpTorque = interp1(motorTorque(:,1),motorTorque(:,2),time);
interpSpeedRPM= interp1(motorSpeedRPM(:,1),motorSpeedRPM(:,2),time);
interpSpeedRadS = interpSpeedRPM * 0.10472;
for i = 1:length(interpTorque)
[efficiency(i)] = efficiencyEmrax208(interpSpeedRPM(i), interpTorque(i), effData, 0);
end
motorPower = interpTorque.*interpSpeedRadS;
motorAirCooledRadius = 0.104; % m
motorArea = 0.075; %m^2
motorSurfaceVelocity = interpSpeedRadS*motorAirCooledRadius;
motorHeatGen = (1-efficiency).*motorPower;
mcuHeatGen = (1-0.97)*interpTorque.*interpSpeedRadS;
velocity = (interpSpeedRadS./gearRatio).*tireRadius;

mask = velocity < 0.5;
velocity(mask) = 0.5;

motorHeatEnergy = cumtrapz(time,motorHeatGen);

Tamb = 26; % C

% Motor Emrax 208
% Datasheet pressure drop and flow rate 0,6 bar 7 L/min
massMotor = 4.5; %kg (100% Stated Mass)
cAl = 904; %J/kg*K

radiatorMass = 1.5;

% MCU
moduleBoardMassMCU = 0.1; %kg (TUNED VARIABLE - EQUIVALENT MASS OF COOLED COMPONENTS)
massMCU = 1.5; %kg (TUNED VARIABLE - EQUIVALENT MASS OF COOLED COMPONENTS)

% Tubing
d = 0.00914; % AR-06-HTP hose inner diameter m
A = pi * (d / 2) .^ 2;
% Minor loss https://www.engineeringtoolbox.com/minor-loss-coefficients-pipes-d_626.html
K90 = 0.5; % CHECK AGAIN
KStraight = 0.08;% CHECK AGAIN
tubeRoughness = 3.2e-6; %m% CHECK AGAIN
kinematicViscosity40C = 0.0000010533; % m^2/s
volumeFlowRate = 5; % L/min CHECK AGAIN
volumeFlowRate = volumeFlowRate/60000; % m^3/s
velocityFlowRate = volumeFlowRate/A; % m/s
tubeReGuess = velocityFlowRate*d/kinematicViscosity40C;
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

% Environment 
Tambient =  26; % C
%% Radiator
radiatorSurfaceRoughness = 3.2e-6;
radiatorCoreHeight = 6.5 * 25.4 / 1000; % m
radiatorCoreWidth = 5.1 * 25.4 / 1000; % m
radiatorShroudWidth = radiatorCoreWidth + 0.05; % m
radiatorShroudHeight = radiatorCoreHeight + 0.025; % m
radiatorCoreArea = radiatorCoreWidth * radiatorCoreHeight; % m^2
radiatorShroudArea = radiatorShroudWidth * radiatorShroudHeight; % m^2
finHeight = .0045; % m
finWidth = 0.038; % m
finDepth = 0.0015; % m
waterChannelOuterHeight = 0.002; % m
finRowNumber = radiatorCoreHeight / (finHeight + waterChannelOuterHeight);
finColumnNumber = radiatorCoreWidth / finDepth;
airChannelNumber = finRowNumber * finColumnNumber;
coldFluidSA = airChannelNumber * (2 * finDepth * finWidth + 2 * finHeight * finWidth); % m ^ 2
airChannelHydraulicDiameter = (2 * finDepth * finHeight / (finDepth + finHeight)); % m
airChannelHydraulicDiameterTotal = airChannelNumber*airChannelHydraulicDiameter;

% Water Channels
% waterChannelInnerHeight = 0.0015; % m
waterChannelInnerHeight = 0.0015;
waterChannelInnerWidth = finWidth - 0.002; % m

waterChannelRowNumber = finRowNumber + 1; 
waterChannelArea = waterChannelInnerHeight * waterChannelInnerWidth; % m ^ 2
waterChannelAreaTotal = waterChannelArea*waterChannelRowNumber;
waterChannelHydraulicDiameter = 4 * waterChannelArea / (2*waterChannelInnerHeight + 2*waterChannelInnerWidth); % m
waterChannelHydraulicDiameterTotal = waterChannelHydraulicDiameter*waterChannelRowNumber;
waterChannelLength = radiatorCoreWidth; % m
waterChannelVolumeTotal = waterChannelArea * waterChannelLength * waterChannelRowNumber; % m ^ 3
waterChannelSA = waterChannelLength * 2 * (waterChannelInnerHeight + waterChannelInnerWidth); % m ^ 2
waterChannelSATotal = waterChannelSA * waterChannelRowNumber; % m ^ 2

waterChannelVelTesting = 8.9 * 1.66667e-5 / waterChannelAreaTotal; % m/s
waterDensity = 997; % kg / m ^ 3
waterDynamicViscocityRoom = 0.0010016; % Pa*s
radReGuessTesting = waterDensity * waterChannelVelTesting * waterChannelHydraulicDiameter ./ waterDynamicViscocityRoom;% JUST GUESS
radFrictionFactor = 64/radReGuessTesting; % CHECK AGAIN
KSharpEntrance = 0.5;
KwaterChannelExit = 0.45;
KSlightlyRoundedEntrance = 0.2;

KtotRadiator = ((KSharpEntrance + KwaterChannelExit) + KSlightlyRoundedEntrance * 2);
leqRadiatorMinor = (KtotRadiator * waterChannelHydraulicDiameterTotal ./ radFrictionFactor);


% ?examples
% sscfluids_ev_battery_cooling
% sscfluids_ev_thermal_management