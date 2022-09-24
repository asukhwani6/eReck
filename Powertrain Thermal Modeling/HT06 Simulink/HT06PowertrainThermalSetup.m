% load Result_1800679663.mat
% motorHeatGen = Result.qMotor(:,4);
% mcuHeatGen = Result.qInverter(:,4);
% velocity = Result.v;
% time = Result.t;
% mask = diff(time) == 0;
% time(mask) = [];
% motorHeatGen(mask) = [];
% velocity(mask) = [];
% timeEnd = time(end);
% mcuHeatGen(mask) = [];
Tamb = 33; % C

% Motor Emrax 208
% Datasheet pressure drop and flow rate 0,6 bar 7 L/min
massMotor = 9.4; %kg
cAl = 904; %J/kg*K
% 


% MCU
massMCU = 6.75; %kg

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

% NEED THIS MEASURE THIS ESTIMATE
tubeLengthRadiatorToPump = 0.3; % m 


% Environment 
Tambient =  33; % C
% Radiator
radiatorSurfaceRoughness = 3.2e-6;
radiatorCoreHeight = 6.5 * 25.4 / 1000; % m
radiatorCoreWidth = 5.1 * 25.4 / 1000; % m
radiatorArea = radiatorCoreWidth .* radiatorCoreHeight; % m
finHeight = .0045; % m
finWidth = 0.0508; % m
finDepth = 0.0015; % m
waterChannelOuterHeight = 0.002; % m
finRowNumber = radiatorCoreHeight / (finHeight + waterChannelOuterHeight);
finColumnNumber = radiatorCoreWidth / finDepth;
airChannelNumber = finRowNumber * finColumnNumber;
coldFluidSA = airChannelNumber * (2 * finDepth * finWidth + 2 * finHeight * finWidth); % m ^ 2
airChannelHydraulicDiameter = 2 * finDepth * finHeight / (finDepth + finHeight); % m


waterChannelInnerHeight = 0.0015; % m
waterChannelInnerWidth = finWidth - 0.0005; % m
waterChannelArea = waterChannelInnerHeight * waterChannelInnerWidth; % m ^ 2
waterChannelHydraulicDiameter = 2 * waterChannelInnerWidth * waterChannelInnerHeight / (waterChannelInnerHeight + waterChannelInnerWidth); % m
waterChannelRowNumber = finRowNumber + 1; 
waterChannelLength = radiatorCoreWidth; % m
waterChannelVolumeTot = waterChannelArea * waterChannelLength * waterChannelRowNumber; % m ^ 3
waterChannelSA = waterChannelLength * 2 * (waterChannelInnerHeight + waterChannelInnerWidth); % m ^ 2
waterChannelSATot = waterChannelSA * waterChannelRowNumber; % m ^ 2

% ?examples
% sscfluids_ev_battery_cooling
% sscfluids_ev_thermal_management