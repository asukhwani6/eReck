clear
clc
% plot HT06 collected data and compare to modeled temperature
load('MichiganEnduranceOutput.mat')
S.dc_bus_current(:,1) = S.dc_bus_current(:,1)/1000;
S.motor_speed(:,1) = S.motor_speed(:,1)/1000;
S.BMS_average_temperature(:,1) = S.BMS_average_temperature(:,1)/1000;

%% User is requested to input 2 points cooresponding to maximum time and minimum time
figure
plot(S.dc_bus_current(:,1),S.dc_bus_current(:,2))
disp('Select coarse data limits')
[x,~] = ginput(2);
close
figure
plot(S.dc_bus_current(:,1),S.dc_bus_current(:,2))
xlim(x)
disp('Select start and end time. Cell tab temperature at t0 will be set to ambient temperature!')
[x,y] = ginput(2);
close
pause(0.5)

%% Limit data to x selection
currData = S.dc_bus_current(:,2);
currTime = S.dc_bus_current(:,1);
tempData = S.BMS_average_temperature(:,2);
tempTime = S.BMS_average_temperature(:,1);
maskCurr = (currTime < x(1)) | (currTime > x(2));
maskTemp = (tempTime < x(1)) | (tempTime > x(2));
currData(maskCurr) = [];
currTime(maskCurr) = [];
tempData(maskTemp) = [];
tempTime(maskTemp) = [];
currTimeNew = currTime-min(currTime);      
current = [currTimeNew,currData];
tempTimeNew = tempTime-min(tempTime);
temp = [tempTimeNew,tempData];

t_initial = x(1);
t_final = x(2);
T0_Acc = min(tempData);
% next line is only true if ambient temperature was constant through entire
% run, and no precooling/preheating occured
T0_Ambient = min(S.BMS_average_temperature(:,2));

[SOL,X,Y] = HT06AccumTherm(S,t_initial,t_final,T0_Acc,T0_Ambient);

%% Plot
figure
hold on
plot(tempTimeNew,tempData,'.')
plot(X-t_initial,Y(1,:))
plot(X-t_initial,Y(2,:))
plot(X-t_initial,Y(3,:))
plot(X-t_initial,ones(length(X),1).*T0_Ambient)

xlabel('Time (s)')
ylabel('Temperature (C)')
title('Accumulator Thermal Model and Experimental HT06 Test Data')
legend({'Collected Cell Tab Temp','Modeled Cell Tab Temp','Modeled Cell Temp','Modeled Accumulator Baseplate Temp','Ambient Temperature'})
grid on
box on