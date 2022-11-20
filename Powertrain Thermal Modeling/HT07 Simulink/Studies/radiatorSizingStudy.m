clear
HT07CombinedPowertrainThermalSetup
radiator.aerodynamicFactor = radiator.aerodynamicFactor*1.5;

radiatorHeightMultVec = linspace(0.5,1.5,6);
radiatorWidthMultVec = linspace(0.5,1.5,6);

for j = 1:length(radiatorHeightMultVec)
    for k = 1:length(radiatorWidthMultVec)

    % Overwrite core height and call new radiator calculations
    radiator.CoreHeight = radiatorHeightMultVec(j)*(6.5 * 25.4 / 1000); % m
    radiator.CoreWidth = radiatorWidthMultVec(k)*(5.125 * 25.4 / 1000); % m
    radiator = dualPassRadiatorInit(radiator);

    try
        out = sim('HT07CombinedPowertrainThermalModelv2IsolatedMotors.slx');
    catch ME
        fprintf('Simulation Failed: %s\n', ME.message);
        continue;  % Jump to next iteration
    end

    maxRadColdTemp(j,k) = out.componentTemps.Data(end,1);
    maxMcuTempRear(j,k) = out.componentTemps.Data(end,2);
    maxCellBaseTemp(j,k) = out.componentTemps.Data(end,3);
    maxCellTabTemp(j,k) = out.componentTemps.Data(end,4);
    maxCoverTemp(j,k) = out.componentTemps.Data(end,5);
    maxContainerTemp(j,k) = out.componentTemps.Data(end,6);
    maxRadHotTemp(j,k) = out.componentTemps.Data(end,7);
    motorRearLeftTemp(j,k) = out.componentTemps.Data(end,8);
    motorFrontLeftTemp(j,k) = out.componentTemps.Data(end,9);
    AccTotalHeatDissipatedtoWater(j,k) = out.accHeatDis.Data(end);
    maxRadAirOutTempHotLoop(j,k) = out.componentTemps.Data(end,10);
    maxRadAirOutTempColdLoop(j,k) = out.componentTemps.Data(end,11);
    disp('Step Complete')
    end
end
mask = maxRadColdTemp == 0;

maxRadColdTemp(mask) = nan;
maxMcuTempRear(mask) = nan;
maxCellBaseTemp(mask) = nan;
maxCellTabTemp(mask) = nan;
maxCoverTemp(mask) = nan;
maxContainerTemp(mask) = nan;
maxRadHotTemp(mask) = nan;
motorRearLeftTemp(mask) = nan;
motorFrontLeftTemp(mask) = nan;
AccTotalHeatDissipatedtoWater(mask) = nan;
maxRadAirOutTempHotLoop(mask) = nan;
maxRadAirOutTempColdLoop(mask) = nan;

%% Plot
figure
hold on
surf(radiatorWidthMultVec,radiatorHeightMultVec,maxCellTabTemp)
xlabel('Width Multiplier')
ylabel('Height Multiplier')
zlabel('Accumulator Temp')
acceptableAccumulatorTemp = 55*ones(length(radiatorWidthMultVec),length(radiatorHeightMultVec));
surf(radiatorWidthMultVec,radiatorHeightMultVec,acceptableAccumulatorTemp)

figure
hold on
surf(radiatorWidthMultVec,radiatorHeightMultVec,maxMcuTempRear)
xlabel('Width Multiplier')
ylabel('Height Multiplier')
zlabel('MCU Temp')
acceptableMCUTemp = 50*ones(length(radiatorWidthMultVec),length(radiatorHeightMultVec));
surf(radiatorWidthMultVec,radiatorHeightMultVec,acceptableMCUTemp)

figure
hold on
surf(radiatorWidthMultVec,radiatorHeightMultVec,motorRearLeftTemp)
xlabel('Width Multiplier')
ylabel('Height Multiplier')
zlabel('Motor Temp')
acceptableMotorTemp = 90*ones(length(radiatorWidthMultVec),length(radiatorHeightMultVec));
surf(radiatorWidthMultVec,radiatorHeightMultVec,acceptableMotorTemp)

%% Plot Absolute Lengths
figure
hold on
surf(radiatorWidthMultVec*(5.125 * 25.4 / 1000),radiatorHeightMultVec*(6.5 * 25.4 / 1000),maxCellTabTemp)
title('Accumulator Cell Tab Temp vs Radiator Sizing')
xlabel('Radiator Core Width (m)')
ylabel('Radiator Core Height (m)')
zlabel('Accumulator Temp')
acceptableAccumulatorTemp = 55*ones(length(radiatorWidthMultVec),length(radiatorHeightMultVec));
surf(radiatorWidthMultVec*(5.125 * 25.4 / 1000),radiatorHeightMultVec*(6.5 * 25.4 / 1000),acceptableAccumulatorTemp)

figure
hold on
surf(radiatorWidthMultVec*(5.125 * 25.4 / 1000),radiatorHeightMultVec*(6.5 * 25.4 / 1000),maxMcuTempRear)
title('Inverter Cold Plate Temp vs Radiator Sizing')
xlabel('Radiator Core Width (m)')
ylabel('Radiator Core Height (m)')
zlabel('MCU Temp')
acceptableMCUTemp = 50*ones(length(radiatorWidthMultVec),length(radiatorHeightMultVec));
surf(radiatorWidthMultVec*(5.125 * 25.4 / 1000),radiatorHeightMultVec*(6.5 * 25.4 / 1000),acceptableMCUTemp)

figure
hold on
surf(radiatorWidthMultVec*(5.125 * 25.4 / 1000),radiatorHeightMultVec*(6.5 * 25.4 / 1000),motorRearLeftTemp)
title('Motor Surface Temp vs Radiator Sizing')
xlabel('Radiator Core Width (m)')
ylabel('Radiator Core Height (m)')
zlabel('Motor Temp')
acceptableMotorTemp = 90*ones(length(radiatorWidthMultVec),length(radiatorHeightMultVec));
surf(radiatorWidthMultVec*(5.125 * 25.4 / 1000),radiatorHeightMultVec*(6.5 * 25.4 / 1000),acceptableMotorTemp)