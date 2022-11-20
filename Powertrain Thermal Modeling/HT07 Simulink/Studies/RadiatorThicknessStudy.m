clear
HT07CombinedPowertrainThermalSetup
radiator.aerodynamicFactor = radiator.aerodynamicFactor*1.5;

radiatorThicknessMultiplier = linspace(0.5,2,8);
% Assume jacket diameter scales with length to achieve constant area
motor.CoolingJacketCooledArea = 0.0150;

for j = 1:length(radiatorThicknessMultiplier)

    % Overwrite channel number and cooresponding calculated values
    radiator.finWidth = radiatorThicknessMultiplier(j)*0.042; % m
    radiator = dualPassRadiatorInit(radiator);

    try
        out = sim('HT07CombinedPowertrainThermalModelv2IsolatedMotors.slx');
    catch ME
        fprintf('Simulation Failed: %s\n', ME.message);
        continue;  % Jump to next iteration
    end

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
plot(radiatorThicknessMultiplier,maxCellTabTemp)
hold on
plot(radiatorThicknessMultiplier,maxMcuTempRear)
xlabel('Radiator Thickness Multiplier')
ylabel('Component Temperatures (C)')
legend({'Max Accumulator Temp','Max MCU Temp'})
title('Hot Loop Component Temperatures - Radiator Thickness Study')