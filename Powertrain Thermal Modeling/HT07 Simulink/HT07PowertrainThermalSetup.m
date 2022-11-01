load EnduranceLapSim-9-15-22.mat
load INTG8_Pump_Data.mat

motorHeatGen = Result.qMotor(:,1);
mcuHeatGen = Result.qInverter(:,1);
velocity = Result.v;
time = Result.t;

motorHeatGen(diff(time)==0) = [];
mcuHeatGen(diff(time)==0) = [];
velocity(diff(time)==0) = [];
time(diff(time)==0);

for i = 1:10
    motorHeatGen = [motorHeatGen;Result.qMotor(:,1)];
    mcuHeatGen = [mcuHeatGen;Result.qInverter(:,1)];
    velocity = [velocity;Result.v];
    time = [time;time(end) + Result.t + 0.001];
end
motorHeatGen = [motorHeatGen;0;0];
mcuHeatGen = [mcuHeatGen;0;0];
velocity = [velocity;0;0];
time = [time; time(end) + 0.001; time(end) + 300];
for i = 1:11
    motorHeatGen = [motorHeatGen;Result.qMotor(:,1)];
    mcuHeatGen = [mcuHeatGen;Result.qInverter(:,1)];
    velocity = [velocity;Result.v];
    time = [time;time(end) + Result.t + 0.001];
end
time = [time;time(end) + 0.001];
velocity = [velocity;0];
motorHeatGen = [motorHeatGen;0];
mcuHeatGen = [mcuHeatGen;0];
timeEnd = time(end);

mask = velocity < 0.1;
velocity(mask) = 4/0.36;
velocity(~mask) = velocity(~mask) + 2/0.36;

motorHeatEnergy = cumtrapz(time,motorHeatGen);

Tamb = 33; % C

% Motor AMK
massMotor = 3.5; %kg (50% stated mass)
cAl = 904; %J/kg*K

% MCU
massMCU = 2.94; %kg (COOLING PLATE MASS PER DOUBLE INVERTER SET)

% Tubing
d = 0.00914; % AR-06-HTP hose inner diameter m
A = pi * (d / 2) .^ 2;
% Minor loss https://www.engineeringtoolbox.com/minor-loss-coefficients-pipes-d_626.html
K90 = 1.5; % CHECK AGAIN
KStraight = 0.08;% CHECK AGAIN
tubeRoughness = 3.2e-6; %m% CHECK AGAIN
tubeReGuess = 3000;% CHECK AGAIN
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
Tambient =  33; % C
% Radiator
% radiatorSurfaceRoughness = 3.2e-6;
radiatorSurfaceRoughness = 3.2e-6;
radiatorCoreHeight = 6.5 * 25.4 / 1000; % m
radiatorCoreWidth = 5.1 * 25.4 / 1000; % m
radiatorShroudWidth = 0.15; % m
radiatorShroudHeight = 0.15; % m
radiatorArea = radiatorShroudWidth .* radiatorShroudHeight; % m
finHeight = .0045; % m
finWidth = 0.0508; % m
finDepth = 0.0015; % m
waterChannelOuterHeight = 0.002; % m
finRowNumber = radiatorCoreHeight / (finHeight + waterChannelOuterHeight);
finColumnNumber = radiatorCoreWidth / finDepth;
airChannelNumber = finRowNumber * finColumnNumber;
coldFluidSA = airChannelNumber * (2 * finDepth * finWidth + 2 * finHeight * finWidth); % m ^ 2
airChannelHydraulicDiameter = (2 * finDepth * finHeight / (finDepth + finHeight)); % m
airChannelHydraulicDiameterTotal = airChannelNumber*airChannelHydraulicDiameter;

% waterChannelInnerHeight = 0.0015; % m
waterChannelInnerHeight = 0.000035;
waterChannelInnerWidth = finWidth - 0.005; % m

waterChannelRowNumber = finRowNumber + 1; 
waterChannelArea = waterChannelInnerHeight * waterChannelInnerWidth; % m ^ 2
waterChannelAreaTotal = waterChannelArea*waterChannelRowNumber;
waterChannelHydraulicDiameter = 4 * waterChannelInnerWidth * waterChannelInnerHeight / (waterChannelInnerHeight + waterChannelInnerWidth); % m
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

KtotRadiator = (KSharpEntrance + KwaterChannelExit) + KSlightlyRoundedEntrance * 2;
leqRadiatorMinor = (KtotRadiator * waterChannelHydraulicDiameterTotal ./ radFrictionFactor);


% ?examples
% sscfluids_ev_battery_cooling
% sscfluids_ev_thermal_management