%Vehicle Parameters (all units SI)
Parameters.VehicleName = 'HT07 AMK Hub Motor';

Parameters.g = 9.81; %acceleration due to gravity

Parameters.curbMass = 120; %[kg]

Parameters.driverMass = 68; %[kg]

Parameters.AccumulatorMass = 43.5; %[kg]

Parameters.L = 1.53; %wheelbase

Parameters.b = 0.78; %distance from CG to rear axle 51% front

Parameters.motorType = 'AMK A2370DD';
Parameters.TmRear = 42; % Rear motor torque
Parameters.TmFront = 42; % Front motor torque

Parameters.derateSpeedRatioRear = 0.95; % derate begins after derateRatio*maxMotorRPM
Parameters.derateSpeedRatioFront = 0.95; % derate begins after derateRatio*maxMotorRPM

Parameters.rearRegen = 42; % regen Torque treated for each motor individually
Parameters.frontRegen = 42; % regen Torque treated for each motor individually

Parameters.overrideEfficiencyRear = 0; % ONLY SET THIS VALUE IF YOU WISH TO OVERRIDE AMK A2370DD EFFICIENCY MAPPING
Parameters.overrideEfficiencyFront = 0; % ONLY SET THIS VALUE IF YOU WISH TO OVERRIDE AMK A2370DD EFFICIENCY MAPPING

Parameters.maxPower = 80000; % W

% To update derating strategy, write new derating function and change @(functionDerate)
derateFunFront = @linearDerate; % define function handle
derateFunRear = @linearDerate; % define function handle

Parameters.derateRear = derateFunRear; % define function handle used to derate Rear motor torque
Parameters.derateFront = derateFunFront; % define function handle used to derate Front motor torque

Parameters.mRearTopSpeed = 19000; % Rear Torque drops to 0 when motor rpm exceeds this value
Parameters.mFrontTopSpeed = 19000; % Rear Torque drops to 0 when motor rpm exceeds this value

Parameters.nRear = 12; % Rear gear ratio
Parameters.nFront = 12; % Front gear ratio

Parameters.Im = 0.0441 + 0.02; %motor + motor output shaft rotational inertia 
Parameters.Ip = 0.144; %powertrain rotational inertia (2x wheels + diff)

Parameters.r = 0.203; %tire radius

Parameters.rho = 1.225; %air density

Parameters.Cd = 1.41; %drag coefficient
Parameters.Cl = 2.62; % Lift coefficient

Parameters.A = 1; %frontal (reference) area

Parameters.hcp = 0.3974; % CP height
Parameters.bcp = 0.6604; % Distance from CP to rear axle

Parameters.Crr = 0.028; %rolling resistance coefficient R25B 

Parameters.Kf = 113 * 57.3; %Front roll stiffness

Parameters.Kr = 113 * 57.3; %Rear roll stiffness

Parameters.hf = 0.058; %Front roll center height

Parameters.hr = 0.071; %Rear roll center height 

Parameters.hg = 0.198; %CG height

Parameters.hl = Parameters.hg - (((Parameters.hr-Parameters.hf)/Parameters.L)*(Parameters.L-Parameters.b) + Parameters.hf); %Distance from CG to roll axis 

Parameters.v = 9.69;

Parameters.t = 1.215; %track width

Parameters.optim_number = 500; %discretization number of recurEvents guess and check

Parameters.cell = 84; %Cells in Series

Parameters.IR = 0.002; %Cell Internal Resistance

Parameters.cellV = 4.2; %Cell Voltage

Parameters.cellMaxI = 270; %Max Cell Current [A]

Parameters.driverFactorLong = 1; % driver is not as good as sim
Parameters.driverFactorLat = 1; % driver is not as good as sim

Parameters.tireFactor = 0.5; % tires are not as good as TTC data

Parameters.graphDataEmrax208 = load('graphDataEmrax208.mat');
Parameters.graphDataAMKA2370DD = load('graphDataAMKA2370DD.mat');
Parameters.graphDataVoltageLimitFitAMK = load('graphDataVoltageLimitFitAMK.mat');
