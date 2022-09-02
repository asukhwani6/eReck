load MichiganEnduranceOutput.mat;
S.dc_bus_current(:,1) = S.dc_bus_current(:,1)./1000;
current = S.dc_bus_current;
% figure(1)
% plot(S.dc_bus_current(:,1), S.dc_bus_current(:,2))
% figure(2)
temp = S.BMS_average_temperature;
amTemp = S.average_temperature;
% plot(temp(:,1), temp(:,2),'.', amTemp(:,1), amTemp(:,2),'.');

load energyMeterEnduranceTimeAdjusted.mat;
current = emCurrent;

tabResis = 0.00009; %Ohm
cellInternalResis = .0018; %Ohm



cAl = 904; %J/kg*K
cSt = 500; %J/kg*K
% C_t = cAl*mInterconnect + 2*cSt*(mInterconnectBolt + mInterconnectNut) + cellTabThermalMass; %J/K
% cellTabThermalMass = pCu*cellTabVolume*cCu;
cCell = 700; %J/kg*K
cCu = 387; %J/kg*K

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

tabLength = 0.03; %m
tabThickness = 0.0002; %m
tabWidth = 0.025; %m
tabArea = tabWidth*tabThickness; %m^2
kCopper = 386; %W/m*K
R_tc = tabLength/(2*tabArea*kCopper); %K/W

pCu = 8960; %kg/m^3
cellTabVolume = tabLength*tabArea;
cellTabThermalMass = pCu*cellTabVolume;

interfacialResistance = 0.01; %m^2*K/W LOW CONFIDENCE
contactArea = 0.002; %m^2
R_cb = interfacialResistance/contactArea; %K/W

baseplateArea = 0.25; %m^2
convectionArea = baseplateArea/84; %m^2
thermistorContactArea = 3E-05; %m^2
boltedJointThermalRes = 10000; %W/m^2-K
thermistorContactRes = 1/(thermistorContactArea*boltedJointThermalRes); %K/W



% ambientTempF = 74.3;
Tstart = 44.5; 
Tend = 2200;
time = linspace(Tstart,Tend,100000);
startTempC = 23.3;

% Tstart = 15640; 
% Tend = 17300;
% time = linspace(Tstart,Tend,100000);
% startTempC = 28.5;



for i = 1:length(current(:,1))

    current(i,1) = current(i,1) + i/100000000;

end
% currentInterp = interp1(current(:,1),current(:,2),time)
% hold on
% figure(3)
%time1 = linspace(0,2500,100000)
% plot(time,currentInterp)
% plot(S.dc_bus_current(:,1), S.dc_bus_current(:,2))
% figure(4)

S.BMS_average_temperature(:,1) = S.BMS_average_temperature(:,1)./1000;
for i = 1:length(S.BMS_average_temperature(:,1))

    S.BMS_average_temperature(i,1) = S.BMS_average_temperature(i,1) + i/100000000;

end
temp = S.BMS_average_temperature;
tempInterp = interp1(temp(:,1),temp(:,2),time);
% plot(time,tempInterp)
adjustedTime = time - time(1);
figure(5)
% plot(adjustedTime,tempInterp)
AH = 18.7;
SOC0 = 1;
dOCVdT = [-0.15, -0.025, 0.025, 0.175, .175, 0.15, 0.04, 0.03, 0.03, 0, -0.1]/1000;
SOC = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];

load('IRvsCellTempFitMichiganEndurance2022.mat','IRvsCellTemp')
% tempVec = linspace(20,70,50)
% IRVec = IRvsCellTemp(tempVec)'/1000
tempVec = [20.0000,24.4444,28.8889,33.3333,37.7778,42.2222,46.6667,51.1111,55.5556,60.0000];
IRVec = [2.3466,1.9787,1.6894,1.4706,1.3142,1.2120,1.1558,1.1376,1.1493,1.1826] / 1000;