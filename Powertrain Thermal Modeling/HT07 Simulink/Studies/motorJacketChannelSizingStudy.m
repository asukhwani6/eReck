clear
HT07CombinedPowertrainThermalSetup

jacketLength = linspace(0.5,1.5,8);
% Assume jacket diameter scales with length to achieve constant area
motor.CoolingJacketCooledArea = 0.0150;

for j = 1:length(jacketLength)

% Overwrite channel number and cooresponding calculated values
motor.CoolingJacketLength = jacketLength(j);
motor.CoolingJacketHalfCircleDiameter = motor.CoolingJacketCooledArea/motor.CoolingJacketLength;
motor = motorJacketInit(motor);

out = sim('HT07CombinedPowertrainThermalModelv2IsolatedMotors.slx');
maxRadColdTemp(j) = out.componentTemps.Data(end,1);
maxMcuTempRear(j) = out.componentTemps.Data(end,2);
maxCellBaseTemp(j) = out.componentTemps.Data(end,3);
maxCellTabTemp(j) = out.componentTemps.Data(end,4);
maxCoverTemp(j) = out.componentTemps.Data(end,5);
maxContainerTemp(j) = out.componentTemps.Data(end,6);
maxRadHotTemp(j) = out.componentTemps.Data(end,7);
motorRearLeftTemp(j) = out.componentTemps.Data(end,8);
motorFrontLeftTemp(j) = out.componentTemps.Data(end,9);
AccTotalHeatDissipatedtoWater(j) = out.accHeatDis.Data(end);
maxRadAirOutTempHotLoop(j) = out.componentTemps.Data(end,10);
maxRadAirOutTempColdLoop(j) = out.componentTemps.Data(end,11);
disp('Step Complete')

end
%% Plotting
figure
plot(jacketLength,motorRearLeftTemp)
hold on
plot(jacketLength,motorFrontLeftTemp)
plot(jacketLength,maxRadHotTemp)
xlabel('Cooling Jacket Length (m)')
ylabel('Component Temperatures (C)')
legend({'Max Rear Motor Temp','Max Front Motor Temp','Max Coolant Water Temp'})
title('Hot Loop Component Temperatures - Motor Jacket Length Study','Half Circle Diameter Cooling Channel Geometry Constraint')