%Vehicle Parameters (all units SI)

Parameters.g = 9.81; %acceleration due to gravity

Parameters.curbMass = 168; %[kg]

% David/Lachlan
Parameters.driverMass = 68; %[kg]

% Claire
% Parameters.driverMass = 50; %[kg]

Parameters.mass = Parameters.curbMass + Parameters.driverMass; %[kg]

Parameters.L = 1.53; %wheelbase

Parameters.b = 0.78; %distance from CG to rear axle 51% front

Parameters.m_u = 1.5;

Parameters.TmRear = 140; %motor torque
Parameters.TmFront = 0; %motor torque

Parameters.nRear = 4.44; %gear ratio
Parameters.nFront = 4.44; %gear ratio

Parameters.Im = 0.0441 + 0.02; %motor + motor output shaft rotational inertia 

Parameters.Ip = 0.144; %powertrain rotational inertia (2x wheels + diff)

Parameters.r = 0.203; %tire radius

Parameters.rho = 1.225; %air density

% HIGH DRAG CONFIGURATION
Parameters.Cd = 1.41; %drag coefficient
Parameters.Cl = 2.62; % Lift coefficient

% LOW DRAG CONFIGURATION
% Param.Cd = 0.85;
% Param.Cl = 1.62;

Parameters.A = 1; %frontal (reference) area

Parameters.hcp = 0.3974; % CP height
Parameters.bcp = 0.6604; % Distance from CP to rear axle

Parameters.Crr = 0.028; %rolling resistance coefficient R25B 

Parameters.eta = 0.93; %powertrain efficiency 

Parameters.Kf = 113 * 57.3; %Front roll stiffness

Parameters.Kr = 113 * 57.3; %Rear roll stiffness

Parameters.hf = 0.058; %Front roll center height

Parameters.hr = 0.071; %Rear roll center height 

Parameters.hg = 0.20; %CG height

Parameters.hl = Parameters.hg - (((Parameters.hr-Parameters.hf)/Parameters.L)*(Parameters.L-Parameters.b) + Parameters.hf); %Distance from CG to roll axis 

Parameters.v = 9.69;

Parameters.t = 1.215; %track