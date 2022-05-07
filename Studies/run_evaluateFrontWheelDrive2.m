%% run 0: Emrax 208 in rear
HT06_vehicle_parameters
vel_start = 12; % m/s
track = 'FSAE2021NevadaEndurance.csv';
Parameters.driverFactorLong = 0.85;
Parameters.driverFactorLat = 0.85;
Parameters.rearRegen = 70;
Parameters.frontRegen = 0;

[v0, t0, locations0, Ax0, Ay0, Fx0, e0] = runLapSimOptimized(vel_start,track,Parameters);

dist = cumtrapz(t0,v0);
lapDistance = dist(end);
lapEnergy = sum(e0) ; %Joules
lapEnergykWh = lapEnergy*2.77778e-7;
raceEnergy = lapEnergykWh*22000/lapDistance;
fprintf('Total Energy Expenditure During Race: %.2f kWh\n',raceEnergy)
fprintf('Simulated Lap Time: %.2f seconds\n',t0(end))

Parameters.driverFactorLong = 1;
Parameters.driverFactorLat = 1;

[tAccel0, vAccel0, AxAccel0, AyAccel0, FxAccel0, FzAccel0] = accel(0,75,0,0,Parameters);
vSkidpad = velLimit(8.25,Parameters);
tSkidpad = 2*8.25*pi/vSkidpad;

fprintf('Acceleration time: %.2f seconds\n',tAccel0(end))
fprintf('Skidpad time: %.2f seconds\n',tSkidpad)
fprintf('Converged Accumulator Mass: %.2f kg\n',Parameters.AccumulatorMass')
%% run 1: Emrax 208 in rear, 2x Nova 30 at front
HT06_vehicle_parameters
Parameters.driverFactorLong = 0.85;
Parameters.driverFactorLat = 0.85;

Parameters.TmRear = 140; %motor torque
Parameters.TmFront = 160; %motor torque
Parameters.rearRegen = 70;
Parameters.frontRegen = 80;
Parameters.nFront = 3.2;
Parameters.nRear = 4.44;
Parameters.overrideEfficiencyFront = 0.9;
Parameters.derateSpeedRatioRear = 0.5; % derate begins after derateRatio*maxMotorRPM
Parameters.derateSpeedRatioFront = 0.8; % derate begins after derateRatio*maxMotorRPM
Parameters.mRearTopSpeed = 7000; % Rear Torque drops to 0 when motor rpm exceeds this value
Parameters.mFrontTopSpeed = 5000; % Rear Torque drops to 0 when motor rpm exceeds this value
Parameters.curbMass = Parameters.curbMass+ 27; %kg (calculated from gearbox mass estimation, )

eps = realmax;
accumulatorMassNew = Parameters.AccumulatorMass;
while eps > 0.2
    Parameters.AccumulatorMass = accumulatorMassNew;
    Parameters.mass = Parameters.curbMass + Parameters.driverMass + Parameters.AccumulatorMass; %[kg]
    [v1, t1, locations1, Ax1, Ay1, Fx1, e1] = runLapSimOptimized(vel_start,track,Parameters);
    dist = cumtrapz(t1,v1);
    lapDistance = dist(end);
    lapEnergy = sum(e1) ; %Joules
    lapEnergykWh = lapEnergy*2.77778e-7;
    raceEnergy = lapEnergykWh*22000/lapDistance;
    fprintf('Total Energy Expenditure During Race: %.2f kWh\n',raceEnergy)
    fprintf('Simulated Lap Time: %.2f seconds\n',t1(end))

    specificEnergy = .12294; %kWh/kg
    accumulatorMassNew = raceEnergy/specificEnergy;
    eps = abs(Parameters.AccumulatorMass - accumulatorMassNew);
    fprintf('Accumulator Mass Delta: %.2f kg\n',eps)
end

Parameters.driverFactorLong = 1;
Parameters.driverFactorLat = 1;

[tAccel1, vAccel1, AxAccel1, AyAccel1, FxAccel1, FzAccel1] = accel(0,75,0,0,Parameters);
vSkidpad = velLimit(8.25,Parameters);
tSkidpad = 2*8.25*pi/vSkidpad;

fprintf('Acceleration time: %.2f seconds\n',tAccel1(end))
fprintf('Skidpad time: %.2f seconds\n',tSkidpad)
fprintf('Converged Accumulator Mass: %.2f kg\n',Parameters.AccumulatorMass')

%% run 2: 4x Nova 30
HT06_vehicle_parameters

Parameters.driverFactorLong = 0.85;
Parameters.driverFactorLat = 0.85;

Parameters.TmRear = 160; %motor torque
Parameters.TmFront = 160; %motor torque
Parameters.rearRegen = 80;
Parameters.frontRegen = 80;
Parameters.nFront = 3.2;
Parameters.nRear = 3.2;
Parameters.overrideEfficiencyFront = 0.9;
Parameters.overrideEfficiencyRear = 0.9;
Parameters.derateSpeedRatioRear = 0.8; % derate begins after derateRatio*maxMotorRPM
Parameters.derateSpeedRatioFront = 0.8; % derate begins after derateRatio*maxMotorRPM
Parameters.mRearTopSpeed = 5000; % Rear Torque drops to 0 when motor rpm exceeds this value
Parameters.mFrontTopSpeed = 5000; % Rear Torque drops to 0 when motor rpm exceeds this value
Parameters.curbMass = Parameters.curbMass+ 27; %kg (calculated from gearbox mass estimation, )

eps = realmax;
accumulatorMassNew = Parameters.AccumulatorMass;
while eps > 0.2
    Parameters.AccumulatorMass = accumulatorMassNew;
    Parameters.mass = Parameters.curbMass + Parameters.driverMass + Parameters.AccumulatorMass; %[kg]
    [v2, t2, locations2, Ax2, Ay2, Fx2, e2] = runLapSimOptimized(vel_start,track,Parameters);
    dist = cumtrapz(t2,v2);
    lapDistance = dist(end);
    lapEnergy = sum(e2) ; %Joules
    lapEnergykWh = lapEnergy*2.77778e-7;
    raceEnergy = lapEnergykWh*22000/lapDistance;
    fprintf('Total Energy Expenditure During Race: %.2f kWh\n',raceEnergy)
    fprintf('Simulated Lap Time: %.2f seconds\n',t2(end))

    specificEnergy = .12294; %kWh/kg
    accumulatorMassNew = raceEnergy/specificEnergy;
    eps = abs(Parameters.AccumulatorMass - accumulatorMassNew);
    fprintf('Accumulator Mass Delta: %.2f kg\n',eps)
end

Parameters.driverFactorLong = 1;
Parameters.driverFactorLat = 1;

vSkidpad = velLimit(8.25,Parameters);
tSkidpad = 2*8.25*pi/vSkidpad;
[tAccel2, vAccel2, AxAccel2, AyAccel2, FxAccel2, FzAccel2] = accel(0,75,0,0,Parameters);

fprintf('Acceleration time: %.2f seconds\n',tAccel2(end))
fprintf('Skidpad time: %.2f seconds\n',tSkidpad)
fprintf('Converged Accumulator Mass: %.2f kg\n',Parameters.AccumulatorMass')

%% Plotting
figure
hold on
plot(tAccel0,vAccel0)
plot(tAccel1,vAccel1)
plot(tAccel2,vAccel2)
title('Acceleration Powertrain Architecture Comparison Velocity vs Time')
xlabel('Time (s)')
ylabel('Velocity (m/s)')
legend({'Emrax208 Rear','2x Nova30 Front, Emrax208 Rear','2x Nova30 Front, 2x Nova30 Rear'})

d0 = cumtrapz(t0,v0);
d1 = cumtrapz(t1,v1);
d2 = cumtrapz(t2,v2);
figure
hold on
plot(d0,v0)
plot(d1,v1)
plot(d2,v2)
title('Powertrain Architecture Comparison Velocity vs Distance: FSAE Nevada Endurance 2021')
xlabel('Time (s)')
ylabel('Velocity (m/s)')
legend({'Emrax208 Rear','2x Nova30 Front, Emrax208 Rear','2x Nova30 Front, 2x Nova30 Rear'})

