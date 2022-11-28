clear
HT07CombinedPowertrainThermalSetup

jacketHeight = linspace(0.0001,0.01,15); % m

for j = 1:length(jacketHeight)

    % Overwrite jacket height and cooresponding calculated values
    motor.CoolingJacketHeight = jacketHeight(j);
    motor.CoolingJacketFlowArea = motor.CoolingJacketHeight*motor.CoolingJacketWidth;
    motor.CoolingJacketHydraulicDiameter = 2*motor.CoolingJacketFlowArea/(motor.CoolingJacketWidth+motor.CoolingJacketHeight);
    motor.CooledPerimeter = motor.CoolingJacketWidth;
    motor.ViscousPerimeter = 2*(motor.CoolingJacketWidth + motor.CoolingJacketHeight);
    motor = motorJacketInit(motor);

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
plot(jacketHeight,motorRearLeftTemp)
hold on
plot(jacketHeight,motorFrontLeftTemp)
plot(jacketHeight,maxRadHotTemp)
xlabel('Cooling Jacket Channel Height(m)')
ylabel('Component Temperatures (C)')
legend({'Max Rear Motor Temp','Max Front Motor Temp','Max Coolant Water Temp'})
title('Hot Loop Component Temperatures - Motor Jacket Height Study','Rectangular Cooling Channel Geometry Constraint')