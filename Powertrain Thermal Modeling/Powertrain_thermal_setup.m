load Result_254272161.mat
motorHeatGen = Result.qMotor(:,4);
mcuHeatGen = motorHeatGen;
timeEnd = length(motorHeatGen);
time = (1:timeEnd);
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
plateFrictionFactor = 3.2e-6; %m
Kcorner = 1.1;
Kin = .2;
Kout = .2;
Ktot = 6 * Kcorner + Kin + Kout;
leq = Ktot * coldPlateDiameter ./ plateFrictionFactor
coldPlateFlowArea = lengthPlateFlow * pi * coldPlateDiameter;
coldPlateFlowVol = pi * (coldPlateDiameter ./ 2) .^ 2 .* lengthPlateFlow;
% Tubing
d = 0.008636
A = pi * (d / 2) .^ 2;

% Environment 
Tambient =  33; % C
% Radiator
areaRadiator = .1; %m


% ?examples
% sscfluids_ev_battery_cooling
% sscfluids_ev_thermal_management