load Endurance9-3-22.mat;

current = Result.currentAcc;
time = Result.t;
velocity = Result.v;
current(diff(time)==0) = [];
velocity(diff(time)==0) = [];
time(diff(time)==0) = [];


% for i = 1:10
%     current = [current;Result.currentAcc];
%     time = [time;time(end) + Result.t + 0.001];
% end
% current = [current;0;0];
% time = [time; time(end) + 0.001; time(end) + 300];
% for i = 1:11
%     current = [current;Result.currentAcc];
%     time = [time;time(end) + Result.t + 0.001];
% end
% time = [time;time(end) + 0.001];
% current = [current;0];

tabResis = 0.00009; %Ohm

nCell = 21*6;
cAl = 904; %J/kg*K
cSt = 500; %J/kg*K
% C_t = cAl*mInterconnect + 2*cSt*(mInterconnectBolt + mInterconnectNut) + cellTabThermalMass; %J/K
% cellTabThermalMass = pCu*cellTabVolume*cCu;
cCell = 900; %J/kg*K
cCu = 387; %J/kg*K

mCell = 0.252; %kg
mFin = 0.0195; %kg
mInterconnect = 0.0034; %kg
mInterconnectBolt = 0.00092; %kg
mInterconnectNut = 0.00058; %kg
mInterconnectBoltTotal = mInterconnectBolt * 2;
mInterconnectNutTotal = mInterconnectNut * 2;
mCover = 2; %kg
mCoverAdj = mCover/nCell; %kg/cell
mContainer = 6; %kg
mContainerAdj = mContainer/nCell; %kg/cell

tabLength = 0.025; %m
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

baseplateArea = 0.32; %m^2
convectionArea = baseplateArea/nCell; %m^2
tabConvectionArea = 2.619E-04; %m^2
thermistorContactArea = 1.5E-05; %m^2
boltedJointThermalRes = 100000; %W/m^2-K
thermistorContactRes = 1/(thermistorContactArea*boltedJointThermalRes); %K/W


Tstart = 0; 
Tend = 2200;
timeBase = linspace(Tstart,Tend,100000);
startTempC = 25;
adjustedTime = timeBase - timeBase(1);

AH = 14;
SOC0 = 1;
% dOCVdT = [-0.15, -0.025, 0.025, 0.175, .175, 0.15, 0.04, 0.03, 0.03, 0, -0.1]/1000;
dOCVdT = [-0.52, -0.97, -0.4, -0.4, -0.2, 0, 0, 0, -0.1, -0.4, 0]/1000;
SOC = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];

load('IRvsCellTempFitMichiganEndurance2022.mat','IRvsCellTemp')
% tempVec = linspace(20,70,50)
% IRVec = IRvsCellTemp(tempVec)'/1000
tempVec = [20.0000,24.4444,28.8889,33.3333,37.7778,42.2222,46.6667,51.1111,55.5556,60.0000];
IRVec = [2.3466,1.9787,1.6894,1.4706,1.3142,1.2120,1.1558,1.1376,1.1493,1.1826] / 1000;