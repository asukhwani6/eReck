clear
load MichiganEnduranceOutput.mat;
S.dc_bus_current(:,1) = S.dc_bus_current(:,1)./1000;
current = S.dc_bus_current;
temp = S.BMS_average_temperature;
amTemp = S.average_temperature;

load energyMeterEnduranceTimeAdjusted.mat;
current = emCurrent;

% Convert motor RPM to linear speed:
nGear = 4.4;
rTire = 0.2; %m
S.vehicle_speed(:,1) = S.motor_speed(:,1)./1000;
rpm2rads = 0.10472;
S.vehicle_speed(:,2) = (S.motor_speed(:,2)./nGear)*rpm2rads*rTire; %m/s

% Cell tab bolted joint electrical resistance - TUNED VARIABLE REASONABLE
% CONFIDENCE
tabResis = 0.00010; %Ohm

cAl = 904; %J/kg*K
cSt = 500; %J/kg*K
cCu = 387; %J/kg*K

% Cell specific heat capacity - TUNED VARIABLE REASONABLE CONFIDENCE FOR
% HT06 CELL
cCell = 970; %J/kg*K 

mCell = 0.325; %kg
mFin = 0.0247; %kg
mInterconnect = 0.0034; %kg
mInterconnectBolt = 0.00092; %kg
mInterconnectNut = 0.00058; %kg
mInterconnectBoltTotal = mInterconnectBolt * 2;
mInterconnectNutTotal = mInterconnectNut * 2;
mCover = 1.5; %kg
mCoverAdj = mCover/84; %kg/cell
mContainer = 4; %kg
mContainerAdj = mContainer/84; %kg/cell

% Cell Tab Length of Copper - TUNED VARIABLE REASONABLE CONFIDENCE
tabLength = 0.03; %m
tabThickness = 0.0002; %m
tabWidth = 0.025; %m
tabArea = tabWidth*tabThickness; %m^2
kCopper = 386; %W/m*K
R_tc = tabLength/(2*tabArea*kCopper); %K/W

pCu = 8960; %kg/m^3
cellTabVolume = tabLength*tabArea;
cellTabThermalMass = pCu*cellTabVolume;

% TUNED VARIABLE REASONABLE CONFIDENCE
% interfacialResistance = 0.004; %m^2*K/W
interfacialResistance = 0.004;
contactArea = 0.002; %m^2
R_cb = interfacialResistance/contactArea; %K/W

baseplateArea = 0.25; %m^2
convectionArea = baseplateArea/84; %m^2
thermistorContactArea = 1.5E-05; %m^2
boltedJointThermalRes = 100000; %W/m^2-K
thermistorContactRes = 1/(thermistorContactArea*boltedJointThermalRes); %K/W


Tstart = 44.5; 
Tend = 2200;
time = linspace(Tstart,Tend,100000);
startTempC = 23.3;

for i = 1:length(current(:,1))

    current(i,1) = current(i,1) + i/100000000;

end

for i = 1:length(S.vehicle_speed(:,1))
    S.vehicle_speed(i,1) = S.vehicle_speed(i,1) + i/100000000;
end

S.BMS_average_temperature(:,1) = S.BMS_average_temperature(:,1)./1000;
for i = 1:length(S.BMS_average_temperature(:,1))
    S.BMS_average_temperature(i,1) = S.BMS_average_temperature(i,1) + i/100000000;
end
temp = S.BMS_average_temperature;
tempInterp = interp1(temp(:,1),temp(:,2),time);
S.average_temperature(:,1) = S.average_temperature(:,1)./1000;
for i = 1:length(S.average_temperature(:,1))
    S.average_temperature(i,1) = S.average_temperature(i,1) + i/100000000;
end
accAirTemp = S.average_temperature;
accAirTempInterp = interp1(accAirTemp(:,1),accAirTemp(:,2),time);

adjustedTime = time - time(1);

AH = 18;
SOC0 = 1;
dOCVdT = [-0.5346   -0.7334   -0.6375   -0.3737   -0.2813   -0.2087   -0.1267   -0.2182    0.2900   -0.3980   -0.2292]/1000;
% dOCVdT = [-1.0310   -0.6949   -0.5932   -0.5002   -0.2754   -0.1447   -0.3493   -0.1393    0.3828   -0.4839]/1000;
SOC = [0    0.1000    0.2000    0.3000    0.4000    0.5000    0.6000    0.7000    0.8000    0.9000, 1.0000];

% load('IRvsCellTempFitMichiganEndurance2022.mat','IRvsCellTemp')
% tempVec = linspace(20,70,50)
% IRVec = IRvsCellTemp(tempVec)'/1000
tempVec = [20.0000,24.4444,28.8889,33.3333,37.7778,42.2222,46.6667,51.1111,55.5556,60.0000];
IRVec = [2.3466,1.9787,1.6894,1.4706,1.3142,1.2120,1.1558,1.1376,1.1493,1.1826] / 1000;