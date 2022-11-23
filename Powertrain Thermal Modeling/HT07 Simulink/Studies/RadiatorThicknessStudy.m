clear
HT07CombinedPowertrainThermalSetup

radiatorThickness = [0.042,0.055,0.068,0.087];

for j = 1:length(radiatorThickness)

    % Overwrite channel number and cooresponding calculated values
    radiator.finWidth = radiatorThickness(j); % m
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
plot(radiatorThickness,maxCellTabTemp)
hold on
plot(radiatorThickness,maxMcuTempRear)
xlabel('Radiator Thickness (m)')
ylabel('Component Temperatures (C)')
legend({'Max Accumulator Temp','Max MCU Temp'})
title('Hot Loop Component Temperatures - Radiator Thickness Study')