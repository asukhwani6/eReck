function [FzTires, phi] = tireNormalForces(Ax,v,r,Parameters)
% FzTires = [FzRi, FzRo, FzFi, FzFo]

mass = Parameters.mass; % Vehicle + driver mass
rho = Parameters.rho; % Density of air
Cd = Parameters.Cd; % Drag coefficient
Cl = Parameters.Cl; % Lift coefficient
A = Parameters.A; % Reference frontal area
hg = Parameters.hg; % CG height
b = Parameters.b; % Distance from CG to rear axle
hcp = Parameters.hcp; % CP height
bcp = Parameters.bcp; % Distance from CP to rear axle
g = Parameters.g; % Gravity
L = Parameters.L; % wheelbase
t = Parameters.t; % track width
hf = Parameters.hf; % Front roll axis height
hr = Parameters.hr; % Rear roll axis height
Kf = Parameters.Kf; % Front roll stiffness
Kr = Parameters.Kr; % Rear roll stiffness

% calculate hl
hl = hg - (((hr-hf)/L)*(L-b) + hf); %Distance from CG to roll axis 

%% Static forces calculated assuming symmetric CG
FzRstatic = mass*g*((L-b)/L);
FzFstatic = mass*g*((b)/L);

%% Longitudinal inertial load transfer (dependent on Ax)
FzLongInerDelta = mass*Ax*hg/L;

%% Lateral load transfer: Reference pages 212-213 of Fundamentals of Vehicle Dynamics (Gillespie):
% Roll angle phi
phi = (mass*g*hl*(v^2)/(r*g))/(Kf + Kr - mass*g*hl);
% Solve front and rear roll moment equations
FzLatFrontDelta = (Kf*phi + (FzFstatic*hf*v^2)/(r*g))/t;
FzLatRearDelta = (Kr*phi + (FzFstatic*hr*v^2)/(r*g))/t;

%% Front/rear aero (dependent on v)
% Drag and lift calculations
Fl = (Cl*rho*A*v^2)/2;
Fd = (Cd*rho*A*v^2)/2;
% Front/rear force distribution based on location of center of pressure
FzRaero = Fl*(bcp/L) + Fd*(hcp/L);
FzFaero = Fl*((L-bcp)/L) - Fd*(hcp/L);

%% Resolve forces on all tires
FzRi = FzRstatic/2 + FzLongInerDelta/2 - FzLatRearDelta + FzRaero/2;
FzRo = FzRstatic/2 + FzLongInerDelta/2 + FzLatRearDelta + FzRaero/2;
FzFi = FzFstatic/2 - FzLongInerDelta/2 - FzLatFrontDelta + FzFaero/2;
FzFo = FzFstatic/2 - FzLongInerDelta/2  + FzLatFrontDelta + FzFaero/2;

FzTires = [FzRi, FzRo, FzFi, FzFo];
