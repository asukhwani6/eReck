%Mass dependent slip angle calculataion

track = "FSAE2021NevadaEndurance.csv";
HT06_vehicle_parameters;
vel_start = 12; %Starting velocity
lapDistance = 1.002531543393838e+03;
epsilon = realmax;

AccumulatorMassNew = Parameters.AccumulatorMass;

N = 8;

driverFactorLong = linspace(0.7,1,N);
driverFactorLat = driverFactorLong;

%Only Sweeping Along Symmetric Sets

tic
for i = 1:N
    
Parameters.driverFactorLong = driverFactorLong(i);
Parameters.driverFactorLat = Parameters.driverFactorLong;
epsilon = realmax;
fprintf("Driver Factor: %.3f\n",Parameters.driverFactorLat);

    while epsilon > 0.1
        
        Parameters.AccumulatorMass = AccumulatorMassNew;
        Parameters.mass = Parameters.curbMass + Parameters.driverMass + Parameters.AccumulatorMass; %[kg]
        
        [~, t, ~, ~, ~, ~, e] = runLapSimOptimized(vel_start,track,Parameters);
           
        SpecificEnergy = 122.9467/1000; %kW/kg
        lapEnergy = sum(e) ; %Joules
        lapEnergykWh = lapEnergy*2.77778e-7;
        raceEnergy = lapEnergykWh*22000/lapDistance;
        
        AccumulatorMassNew = raceEnergy/SpecificEnergy;
        
        epsilon = abs(AccumulatorMassNew - Parameters.AccumulatorMass);
        
        fprintf("Energy Difference: %.3f\n",epsilon);
        
    end

    time(i) = t(end);
    EnergyReq(i) = raceEnergy;
    
end
toc
%% Cd/Cl Sweep

N = 8;
epsilon = realmax;
track = "FSAE2021NevadaEndurance.csv";
HT06_vehicle_parameters;
vel_start = 12; %Starting velocity
Cl_sweep = linspace(0,3,N);
Cd_sweep = linspace(0,3,N);
lapDistance = 1.002531543393838e+03;

AccumulatorMassNew = Parameters.AccumulatorMass;
AccumulatorMassReset = Parameters.AccumulatorMass;

tic
%Only Sweeping Along Symmetric Sets
for i = 1:N
    for j = 1:N
               
        Parameters.Cl = Cl_sweep(i);
        Parameters.Cd = Cd_sweep(i);
        fprintf("Computing Cl: %.3f, Cd: %.3f\n",Parameters.Cl, Parameters.Cd);
        
        AccumulatorMassNew = AccumulatorMassReset;
        epsilon = realmax;
    while epsilon > 0.1
        
        Parameters.AccumulatorMass = AccumulatorMassNew;
        Parameters.mass = Parameters.curbMass + Parameters.driverMass + Parameters.AccumulatorMass; %[kg]
        
        [~, t, ~, ~, ~, ~, e] = runLapSimOptimized(vel_start,track,Parameters);
           
        SpecificEnergy = 122.9467/1000; %kW/kg
        lapEnergy = sum(e) ; %Joules
        lapEnergykWh = lapEnergy*2.77778e-7;
        raceEnergy = lapEnergykWh*22000/lapDistance;
        
        AccumulatorMassNew = raceEnergy/SpecificEnergy;
        
        epsilon = abs(AccumulatorMassNew - Parameters.AccumulatorMass);
        
        fprintf("Energy Difference: %.3f\n",epsilon);
        
    end

    timeClSweep(i,j) = t(end);
    EnergyClReq(i,j) = raceEnergy;
    
    end
end

toc
%% Max CD bound to hit

HT06_vehicle_parameters;

Cd_max = 3;

t = realmax;

Parameters.TmRear = 160; %motor torque
Parameters.derateSpeedRatioRear = 1; % derate begins after derateRatio*maxMotorRPM

while t(end) > 4.095
    
    Parameters.Cd = Cd_max;
      
    t = accel(0,75,0,0, Parameters);
    
    Cd_max = Cd_max - 0.01;
    
end

fprintf("Max Allowable Cd: %.3f\n",Cd_max);

%% Min Cl bound

HT06_vehicle_parameters;

Cl_min = 0;

t = realmax;

Parameters.TmRear = 160; %motor torque
Parameters.derateSpeedRatioRear = 1; % derate begins after derateRatio*maxMotorRPM

while t > 5.25
    
    Parameters.Cd = Cl_min;
        
    v_allowed = velLimit(8.25,Parameters);
      
    t = (pi*2*8.25)/v_allowed;
    
    Cl_min = Cl_min + 0.01;
    
end

fprintf("Min Allowable Cl: %.3f\n",Cl_min);


%% Data plots

figure
box on
plot(driverFactorLong, time,'-','LineWidth', 4);
xlabel('Driver Factor','FontSize',14);
ylabel('Lap time [s]')
yyaxis right
plot(driverFactorLong, EnergyReq,'-','LineWidth', 4);
ylabel('Energy Expended [kWh]','FontSize',14)
xlim([0.7 1])
grid on
title('Mass Dependent Driver Factor Analysis','FontSize',14)
ax = gca;
ax.FontSize = 14; 
f = gcf;
exportgraphics(f,'diriverFactorMass.png','Resolution',600)

%%
[X,Y] = meshgrid(Cl_sweep,Cd_sweep);
figure
box on
surf(Y,X,timeClSweep);
xlabel('Cl')
ylabel('Cd')
zlabel('Lap time [s]')


