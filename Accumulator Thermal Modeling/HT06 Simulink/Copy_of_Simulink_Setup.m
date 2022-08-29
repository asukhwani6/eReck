load Result_254272161.mat;
%Result.currentAcc(:,1) = Result.currentAcc(:,1)./1000;
current = abs(Result.currentAcc);
current = current;
time = Result.t;
timeNew = [time];
currentNew = [current];
for i = 1:21
    timeNew = [timeNew; time + timeNew(end) + 1];
    currentNew = [currentNew; current];
end
current = currentNew;
time = timeNew;
figure(1)
plot(time, current)

%figure(2)
%temp = S.BMS_average_temperature;
%amTemp = S.average_temperature;
%plot(temp(:,1), temp(:,2),'.', amTemp(:,1), amTemp(:,2),'.');


tabResis = 0.00009; %Ohm
cellInternalResis = .0018; %Ohm

mInterconnect = 0.0034; %kg
mInterconnectBolt = 0.00092; %kg
mInterconnectNut = 0.00058; %kg
mInterconnectBoltTotal = mInterconnectBolt * 2;
mInterconnectNutTotal = mInterconnectNut * 2;

cAl = 904; %J/kg*K
cSt = 500; %J/kg*K
% C_t = cAl*mInterconnect + 2*cSt*(mInterconnectBolt + mInterconnectNut) + cellTabThermalMass; %J/K
% cellTabThermalMass = pCu*cellTabVolume*cCu;
cCell = 900; %J/kg*K
mCell = 0.253; %kg
mFin = 0.0247; %kg

tabLength = 0.02; %m
tabThickness = 0.0002; %m
tabWidth = 0.025; %m
tabArea = tabWidth*tabThickness; %m^2
kCopper = 386; %W/m*K
R_tc = tabLength/(2*tabArea*kCopper); %K/W

pCu = 8960; %kg/m^3
cellTabVolume = tabLength*tabArea;
cellTabThermalMass = pCu*cellTabVolume;
cCu = 387; %J/kg*K

interfacialResistance = 0.01; %m^2*K/W LOW CONFIDENCE
contactArea = 0.002; %m^2
R_cb = interfacialResistance/contactArea; %K/W

baseplateArea = 0.29645; %m^2
convectionArea = baseplateArea/126; %m^2


ambientTempF = 74.3;
%time = linspace(51.3,1914,100000);
startTempC = 23.5;


for i = 1:length(current(:,1))

    current(i,1) = current(i,1) + i/100000000;

end
%currentInterp = interp1(current(:,1),time)
%hold on
%figure(3)
%time1 = linspace(0,2500,100000)
%plot(time,currentInterp)
% plot(S.dc_bus_current(:,1), S.dc_bus_current(:,2))
%figure(4)
% 
% S.BMS_average_temperature(:,1) = S.BMS_average_temperature(:,1)./1000;
% for i = 1:length(S.BMS_average_temperature(:,1))
% 
%     S.BMS_average_temperature(i,1) = S.BMS_average_temperature(i,1) + i/100000000;
% 
% end
% temp = S.BMS_average_temperature;
% tempInterp = interp1(temp(:,1),temp(:,2),time)
% plot(time,tempInterp)
% adjustedTime = time - time(1);
% figure(5)
% plot(adjustedTime,tempInterp)

