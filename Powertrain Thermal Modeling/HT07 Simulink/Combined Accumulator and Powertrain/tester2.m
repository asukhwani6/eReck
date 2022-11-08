clear
radiator.CoreHeight = 1.4*(6.5 * 25.4 / 1000); % m
HT07CombinedPowertrainThermalSetupExperimental

out14 = sim('HT07CombinedPowertrainThermalModelv2IsolatedMotors.slx')
maxRadColdTemp = out14.componentTemps.Data(end,1)
maxMcuTempRear = out14.componentTemps.Data(end,2)
maxCellBaseTemp = out14.componentTemps.Data(end,3)
maxCellTabTemp = out14.componentTemps.Data(end,4)
maxCoverTemp = out14.componentTemps.Data(end,5)
maxContainerTemp = out14.componentTemps.Data(end,6)
maxRadHotTemp = out14.componentTemps.Data(end,7)
motorRearLeftTemp = out14.componentTemps.Data(end,8)
motorFrontLeftTemp = out14.componentTemps.Data(end,9)
AccTotalHeatDissipatedtoWater = out14.accHeatDis.Data(end)
maxRadAirOutTempHotLoop = out14.componentTemps.Data(end,10)
maxRadAirOutTempColdLoop = out14.componentTemps.Data(end,11)
table14 = [maxRadColdTemp; maxMcuTempRear; maxCellBaseTemp; maxCellTabTemp; maxCoverTemp; maxContainerTemp; maxRadHotTemp; motorRearLeftTemp; motorFrontLeftTemp; AccTotalHeatDissipatedtoWater; maxRadAirOutTempHotLoop; maxRadAirOutTempColdLoop]


radiator.CoreHeight = 1.6*(6.5 * 25.4 / 1000); % m
HT07CombinedPowertrainThermalSetupExperimental

out15 = sim('HT07CombinedPowertrainThermalModelv2IsolatedMotors.slx')
maxRadColdTemp = out15.componentTemps.Data(end,1)
maxMcuTempRear = out15.componentTemps.Data(end,2)
maxCellBaseTemp = out15.componentTemps.Data(end,3)
maxCellTabTemp = out15.componentTemps.Data(end,4)
maxCoverTemp = out15.componentTemps.Data(end,5)
maxContainerTemp = out15.componentTemps.Data(end,6)
maxRadHotTemp = out15.componentTemps.Data(end,7)
motorRearLeftTemp = out15.componentTemps.Data(end,8)
motorFrontLeftTemp = out15.componentTemps.Data(end,9)
AccTotalHeatDissipatedtoWater = out15.accHeatDis.Data(end)
maxRadAirOutTempHotLoop = out15.componentTemps.Data(end,10)
maxRadAirOutTempColdLoop = out15.componentTemps.Data(end,11)
table15 = [maxRadColdTemp; maxMcuTempRear; maxCellBaseTemp; maxCellTabTemp; maxCoverTemp; maxContainerTemp; maxRadHotTemp; motorRearLeftTemp; motorFrontLeftTemp; AccTotalHeatDissipatedtoWater; maxRadAirOutTempHotLoop; maxRadAirOutTempColdLoop]


radiator.CoreHeight = 1.7*(6.5 * 25.4 / 1000); % m
HT07CombinedPowertrainThermalSetupExperimental

out16 = sim('HT07CombinedPowertrainThermalModelv2IsolatedMotors.slx')
maxRadColdTemp = out16.componentTemps.Data(end,1)
maxMcuTempRear = out16.componentTemps.Data(end,2)
maxCellBaseTemp = out16.componentTemps.Data(end,3)
maxCellTabTemp = out16.componentTemps.Data(end,4)
maxCoverTemp = out16.componentTemps.Data(end,5)
maxContainerTemp = out16.componentTemps.Data(end,6)
maxRadHotTemp = out16.componentTemps.Data(end,7)
motorRearLeftTemp = out16.componentTemps.Data(end,8)
motorFrontLeftTemp = out16.componentTemps.Data(end,9)
AccTotalHeatDissipatedtoWater = out16.accHeatDis.Data(end)
maxRadAirOutTempHotLoop = out16.componentTemps.Data(end,10)
maxRadAirOutTempColdLoop = out16.componentTemps.Data(end,11)
table16 = [maxRadColdTemp; maxMcuTempRear; maxCellBaseTemp; maxCellTabTemp; maxCoverTemp; maxContainerTemp; maxRadHotTemp; motorRearLeftTemp; motorFrontLeftTemp; AccTotalHeatDissipatedtoWater; maxRadAirOutTempHotLoop; maxRadAirOutTempColdLoop]
