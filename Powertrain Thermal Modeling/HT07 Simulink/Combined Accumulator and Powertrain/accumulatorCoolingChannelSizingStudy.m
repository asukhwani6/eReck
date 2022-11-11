clear
channelNum = linspace(1,5,10);
for j = 1:length(channelNum)

accChannelWidth = 0.008; % m
radiator.CoreHeight = (6.5 * 25.4 / 1000); % m
accChannelNum = channelNum(j);
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
%% Plotting
figure
plot(channelNum,maxCellTabTemp)
hold on
plot(channelNum,maxMcuTempRear)
xlabel('Number of Acc Water Channels')
ylabel('Component Temperatures (C)')
legend({'Max Cell Tab Temperature','Max MCU Cold Plate Temperature'})
title('Cold Loop Component Temperatures - Accumulator Channel Number Study',['Accumulator Channel Width: ',num2str(accChannelWidth*1000),' mm'])