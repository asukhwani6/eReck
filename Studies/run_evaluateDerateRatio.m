%% Derate Ratio
HT06_vehicle_parameters;
derateRatio = linspace(0,0.95,10);
lapTimeVec = [];
energyVec = [];
track = 'FSAE2021NevadaEndurance.csv';
vel_start = 12;
eps = realmax;
accumulatorMassNew = Parameters.AccumulatorMass;
for i = 1:length(derateRatio)
    Parameters.derateSpeedRatioRear = derateRatio(i);
    while eps > 0.2
        Parameters.AccumulatorMass = accumulatorMassNew;
        Parameters.mass = Parameters.curbMass + Parameters.driverMass + Parameters.AccumulatorMass; %[kg]

        [v, t, locations, Ax, Ay, Fx, e] = runLapSimOptimized(vel_start,track,Parameters);
        dist = cumtrapz(t,v);
        lapDistance = dist(end);
        lapEnergy = sum(e) ; %Joules
        lapEnergykWh = lapEnergy*2.77778e-7;
        raceEnergy = lapEnergykWh*22000/lapDistance;
        fprintf('Total Energy Expenditure During Race: %.2f kWh\n',raceEnergy)
        fprintf('Simulated Lap Time: %.2f seconds\n',t(end))

        specificEnergy = .12294; %kWh/kg
        accumulatorMassNew = raceEnergy/specificEnergy;
        eps = abs(Parameters.AccumulatorMass - accumulatorMassNew);
        fprintf('Accumulator Mass Delta: %.2f seconds\n',eps)
    end
    lapTimeVec = [lapTimeVec, t(end)];
    energyVec = [energyVec, raceEnergy];
end