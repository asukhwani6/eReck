track = "FSAE2021NevadaEndurance.csv";
HT05_vehicle_parameters;
vel_start = 12; %Starting velocity

N = 10;

driverFactorLong = linspace(0.6,1,N);
driverFactorLat = linspace(0.6,1,N);

for i = 1:N
    for j = 1:N
     fprintf("Long Factor: %.3f Lat Factor: %.3f\n",driverFactorLong(i),driverFactorLat(j));
Parameters.driverFactorLong = driverFactorLong(i);
Parameters.driverFactorLat = driverFactorLat(j);

[~, t, ~, ~, ~, ~, e] = runLapSimOptimized(vel_start,track,Parameters);
lapEnergy = sum(e) ; %Joules
lapEnergykWh = lapEnergy*2.77778e-7;

time(i,j) = t(end); %total time per lap
raceEnergy(i,j) = lapEnergykWh*22000/lapDistance; %Endurance Energy [kWh]
    end
end

[X,Y] = meshgrid(driverFactorLat,driverFactorLong);

figure
surf(Y,X,time)
xlabel('Driver Factor Longitudinal')
ylabel('Driver Factor Lateral')
zlabel('Time')
title('Lap Time Sensitivity')
view(45,30)

figure
surf(Y,X,raceEnergy)
xlabel('Driver Factor Longitudinal')
ylabel('Driver Factor Lateral')
zlabel('KWh')
title('Energy Consumption Sensitivity')
view(45,30)
%% Test

N = 5;
M = 6;

penis = linspace(0.6,1,N);
banana = linspace(0.6,1,M);

for i = 1:N
    for j = 1:M

cock(i,j) = 69;

    end
end

[X,Y] = meshgrid(banana,penis);

figure
surf(X,Y,cock)

