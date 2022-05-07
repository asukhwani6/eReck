%% HT07 AMK Hubs
HT07_AMK_hubs_vehicle_parameters;
Parameters.mass = Parameters.AccumulatorMass + Parameters.curbMass + Parameters.driverMass;

n = 30;
nFrontVec = linspace(8,18,n);
nRearVec = linspace(8,18,n);
accelTime = [];

for i = 1:length(nFrontVec)
    for j = 1:length(nRearVec)

Parameters.nFront = nFrontVec(i);
Parameters.nRear = nRearVec(j);
[accel_time,accel_v,~,~, accel_Fx] = accel(0,75,0,0,Parameters);
accelTime(i,j) = accel_time(end);

    end
end
figure
surf(nFrontVec,nRearVec,accelTime')
xlabel('Front Gear Ratio')
ylabel('Rear Gear Ratio')
zlabel('Acceleration Event Time (s)')
title('Acceleration Gear Ratio Study: AMK Hub Motors')

figure
contour(nFrontVec,nRearVec,accelTime,20,'ShowText','on')
xlabel('Front Gear Ratio')
ylabel('Rear Gear Ratio')
title('Acceleration Gear Ratio Study: AMK Hub Motors')
%% HT06
HT06_vehicle_parameters;
Parameters.mass = Parameters.AccumulatorMass + Parameters.curbMass + Parameters.driverMass;

n = 100;
nRearVec = linspace(3,10,n);
accelTimeHT06 = [];

for i = 1:length(nRearVec)

Parameters.nRear = nRearVec(i);
[accel_time,accel_v,~,~, accel_Fx] = accel(0,75,0,0,Parameters);
accelTimeHT06(i) = accel_time(end);

end

figure
plot(nRearVec,accelTimeHT06)
xlabel('Rear Gear Ratio')
zlabel('Acceleration Event Time (s)')