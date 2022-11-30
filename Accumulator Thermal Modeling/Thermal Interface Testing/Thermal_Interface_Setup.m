%% HT06/07 Thermal Interface Testing Simulink Setup Script

% load finInterfaceTest.mat
load Sample3Test1.mat;

timeEnd = time(end);

cAl = 904; %J/kg*K
cSt = 500; %J/kg*K
g = 9.81;

massAlSubstrate = 1.52/1000; % kg
massSteelWeight = 0.728; % kg

alSubstrateWidth = 0.030;
alSubstrateLength = 0.0385;
alSubstrateArea = alSubstrateLength*alSubstrateWidth; % m^2

% TUNED VARIABLE
thermalInterfaceResFlux = 0.0030; % K-m^2/W
thermalInterfaceRes = thermalInterfaceResFlux/alSubstrateArea;

capDiameter = 0.0265; % m
capThickness = 0.0015; % m
capHeight = 0.014; % m
capInnerDiameter = capDiameter - 2*capThickness; % m
capArea = (pi/4)*(capDiameter^2 - capInnerDiameter^2); % m^2
capThermalConductivity = 0.1; % W/m-K

capThermalResistance = capHeight/(capThermalConductivity*capArea);

compressionPressure = ((massSteelWeight*g)/alSubstrateArea)*1e-6