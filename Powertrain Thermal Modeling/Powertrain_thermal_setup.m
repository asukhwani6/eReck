load Endurance9-3-22.mat
motorHeatGen = Result.qMotor(:,4);
mcuHeatGen = Result.qInverter(:,4);
velocity = Result.v;
time = Result.t;
mask = diff(time) == 0;
time(mask) = [];
motorHeatGen(mask) = [];
velocity(mask) = [];
timeEnd = time(end);
mcuHeatGen(mask) = [];
Tamb = 33; % C

% Motor
massMotor = 3.55; %kg
cAl = 904; %J/kg*K
% Minimum requirements:
% The specified rated data (see: Motor_data_sheet_A2370DD_DD5) are only under the following conditions:
% l Maximum flow temperature: 40 °C (104 °F) (derating: from 40 °C (104 °F) to 60 °C (140 °F)1% per 1K)
% l The minimum flow rate 4 l/min (1.06 Oz/min)
% l The maximum temperature increase of the coolant <5K


% MCU
massMCUColdPlate = 2.942; %kg
% Flow rate = 1.5 bar / 10 l/min
% AlMgSi 0.5 aluminum alloy
% The surface temperature of the liquid-cooled cooling plate must be < 40 °C (104 °F).
% Minimum requirements:
% The specified rated data (see: chapter 'Technical data - inverter') are only under the following conditions:
% l Maximum flow temperature: 25 °C (77 °F)
% l The minimum flow rate: 10 l/min (2.64 Oz/min)
% l Pressure: 1.5 bar (21.76 psi)
% l The maximum temperature increase of the coolant <5K

% Technical data for the FSE cold plate:x
% Maximum power that can be dissipated 1) 2,000 watts
% Water flow 1.5 bar (21.76 psi); 10 l/min (2.64 Oz/min)
% Ambient temperature during operation +5 °C (41 °F) to +40 °C (104 °F)
% Relative humidity 5% to 85%, non-condensing
% Coolant pipe material AlMgSi 0.5
% Dimensions 339 x 180 mm
% Coolant connection G 1/4" internal thread
% Test pressure 8 bar (116 psi)
% Internal thread G1/4"
% Pg 27 diagram
lengthPlateFlow = .339 * 4 + .030 * 3; % m
coldPlateDiameter = 10E-3; %m
plateRoughness = 3.2e-6; %m
plateRelRoughness = plateRoughness/coldPlateDiameter;
ReGuess = 3000;
plateFrictionFactor = 64/ReGuess;
Kcorner = 1.1; % estimated from Page 440 fundamentals-of-fluid-mechanics-8th-edition
Kin = .2; % need to check against valve specifications
Kout = .2; % need to check against valve specifications
Ktot = 6 * Kcorner + Kin + Kout;
leq = Ktot * coldPlateDiameter ./ plateFrictionFactor;
coldPlateFlowArea = lengthPlateFlow * pi * coldPlateDiameter;
coldPlateFlowVol = pi * (coldPlateDiameter ./ 2) .^ 2 .* lengthPlateFlow;
% Tubing
d = 0.008636
A = pi * (d / 2) .^ 2;

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