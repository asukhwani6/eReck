%% Accelerometer integration and correction script
% Adjust longitudinal acceleration
load('output.mat')

accelMask = S.long_accel(:,1) > 1954430 | S.long_accel(:,1) < 1946380;
motorMask = S.motor_speed(:,1) > 1954430 | S.motor_speed(:,1) < 1946380;
motorTime = S.motor_speed(~motorMask,1)/1000;
motorSpeed = -S.motor_speed(~motorMask,2);
gearRatio = 9/40;
wheelRadius = 0.2;
rpmToRad = 0.10472;
wheelVelocity = motorSpeed*gearRatio*rpmToRad*wheelRadius;

adjTime = S.long_accel(:,1)./1000;
adjAcceleration = S.long_accel(:,2);
adjAcceleration(accelMask) = [];
adjTime(accelMask) = [];

avgAccelSample = adjAcceleration(1940 < adjTime & 1945 > adjTime);
% offset = mean(avgAccelSample);
offset = 0.29;
adjAccelerationOffset = adjAcceleration - offset;
adjVelocityInt = cumtrapz(adjTime,adjAccelerationOffset);

time = min(min(motorTime),min(adjTime)):0.05:max(max(motorTime),max(adjTime));

interpWheelVelocity = interp1(motorTime,wheelVelocity,time);
interpAdjVelocity = interp1(adjTime,adjVelocityInt,time);


% Page 39 Race Car Vehicle Dynamics Milliken
SR = (interpWheelVelocity./interpAdjVelocity) - 1;
figure
plot(time,SR)
ylim([0,2])

figure
plot(adjTime,adjAcceleration)

figure
hold on
plot(adjTime,adjVelocityInt);
plot(motorTime,wheelVelocity)
xlabel('Time (s)')
ylabel('Velocity (m/s)')