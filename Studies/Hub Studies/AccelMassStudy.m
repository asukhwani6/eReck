clear

HT07_AMK_hubs_vehicle_parameters;
% HT06_vehicle_parameters;
Parameters.mass = Parameters.AccumulatorMass + Parameters.curbMass + Parameters.driverMass;
accelLength = 75; %m
entry_vel = 0; %start from standstill

mass = linspace(100,400,15);

for i = 1:length(mass)
    Parameters.mass = mass(i);
    [accel_t, accel_v, accel_Ax, accel_Ay, accel_Fx, accel_Fz, accel_T, accel_elecPower, accel_eff, accel_q] = speed_transient(accelLength, realmax, entry_vel, realmax, 0, Parameters);
    accel_motorSpeed = [(accel_v'./Parameters.r).*Parameters.nRear,(accel_v'./Parameters.r).*Parameters.nFront].*9.5493;
    accelTime(i) = accel_t(end);
end

figure
plot(mass,accelTime)
title(['Acceleration Mass Sensitivity Study: ',Parameters.VehicleName])
xlabel('Mass (kg)')
ylabel('Accel Time (s)')