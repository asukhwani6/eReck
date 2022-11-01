clear
load EnduranceLapSim-9-15-22.mat;

current = Result.currentAcc;
time = Result.t;
velocity = Result.v;
current(diff(time)==0) = [];
velocity(diff(time)==0) = [];
time(diff(time)==0) = [];

% Concatenate data for full endurance run
for i = 1:10
    current = [current;Result.currentAcc];
    velocity = [velocity;Result.v];
    time = [time;time(end) + Result.t + 0.001];
end
current = [current;0;0];
velocity = [velocity;0;0];
time = [time; time(end) + 0.001; time(end) + 300];
for i = 1:11
    current = [current;Result.currentAcc];
    velocity = [velocity;Result.v];
    time = [time;time(end) + Result.t + 0.001];
end
time = [time;time(end) + 0.001];
velocity = [velocity;0];
current = [current;0];

% Cell tab bolted joint electrical resistance - TUNED VARIABLE REASONABLE
% CONFIDENCE
tabResis = 0.00010; %Ohm

nCell = 21*6;
cAl = 904; %J/kg*K
cSt = 500; %J/kg*K
cCu = 387; %J/kg*K

% Cell specific heat capacity - TUNED VARIABLE REASONABLE CONFIDENCE FOR
% HT06 CELL
cCell = 970; %J/kg*K 

mCell = 0.252; %kg
mFin = 0.0195; %kg
mInterconnect = 0.0034; %kg
mInterconnectBolt = 0.00092; %kg
mInterconnectNut = 0.00058; %kg
mInterconnectBoltTotal = mInterconnectBolt * 2;
mInterconnectNutTotal = mInterconnectNut * 2;
mCover = 2; %kg
mCoverAdj = mCover/nCell; %kg/cell
mContainer = 4.2; %kg
mContainerAdj = mContainer/nCell; %kg/cell

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
interfacialResistance = 0.004; %m^2*K/W LOW CONFIDENCE
contactArea = 0.002; %m^2
R_cb = interfacialResistance/contactArea; %K/W

baseplateArea = 0.32; %m^2
convectionArea = baseplateArea/nCell; %m^2
% UNCOMMENT FOR ADIABATIC BASEPLATE
% convectionArea = 0.000000001;
tabConvectionArea = 2.619E-04; %m^2
tabConvectionCoefficient = 100; %W/m^2-K
% UNCOMMENT FOR ADIABATIC CELL TAB
% tabConvectionCoefficient = 0.000000001;
thermistorContactArea = 1.5E-05; %m^2
boltedJointThermalRes = 100000; %W/m^2-K
thermistorContactRes = 1/(thermistorContactArea*boltedJointThermalRes); %K/W


Tstart = 0; 
Tend = 2200;
timeBase = linspace(Tstart,Tend,100000);
startTempC = 25;
adjustedTime = timeBase - timeBase(1);

AH = 13.5;
SOC0 = 1;
dOCVdT = [-0.5346   -0.7334   -0.6375   -0.3737   -0.2813   -0.2087   -0.1267   -0.2182    0.2900   -0.3980   -0.2292]/1000;
% dOCVdT = [-1.0310   -0.6949   -0.5932   -0.5002   -0.2754   -0.1447   -0.3493   -0.1393    0.3828   -0.4839]/1000;
SOC = [0    0.1000    0.2000    0.3000    0.4000    0.5000    0.6000    0.7000    0.8000    0.9000, 1.0000];

% load('IRvsCellTempFitMichiganEndurance2022.mat','IRvsCellTemp')
% tempVec = linspace(20,70,50)
% IRVec = IRvsCellTemp(tempVec)'/1000
tempVec = [20.0000,24.4444,28.8889,33.3333,37.7778,42.2222,46.6667,51.1111,55.5556,60.0000];
IRVec = [2.3466,1.9787,1.6894,1.4706,1.3142,1.2120,1.1558,1.1376,1.1493,1.1826] / 1000;