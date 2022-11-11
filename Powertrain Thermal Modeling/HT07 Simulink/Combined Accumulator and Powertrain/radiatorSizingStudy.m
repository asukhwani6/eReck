clear
radiatorHeightMultiplier = linspace(0.5,1.5,10);
for j = 1:length(radiatorHeightMultiplier)

radiator.CoreHeight = radiatorHeightMultiplier(j)*(6.5 * 25.4 / 1000); % m
HT07CombinedPowertrainThermalSetupExperimental

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
