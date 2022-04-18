%calculates the instantaneous braking force
function [Fx,Ax] = tl_brake(v,Ax,Parameters)

% Get Used Vehicle Parameters:
% UPDATE VEHICLE PARAMETERS IN VEHICLE PARAMETER FILES

mass = Parameters.mass; % Vehicle + driver mass
rho = Parameters.rho; % Density of air
Cd = Parameters.Cd; % Drag coefficient
Cl = Parameters.Cl; % Lift coefficient
A = Parameters.A; % Reference frontal area
Crr = Parameters.Crr; % Tire rolling resistance coefficient
L = Parameters.L; % Wheelbase
hg = Parameters.hg; % CG height
b = Parameters.b; % Distance from CG to rear axle
g = Parameters.g; % Gravity

c = L - b; %distance from CG to front axle
Lift = 0.5.*rho.*Cl.*v.^2.* A; %Lift force
Fz = mass * g * ( (c/L) + (-Ax/g)*(hg/L)) + Lift;

%TODO: ADD ROTATIONAL INERTIA EFFECTS TO BRAKING

Fx = 2*tire_x(Fz/2);

D = 0.5.*rho.*Cd.*v.^2.* A; %drag force

Rr =  Crr.* mass.*9.81; %Rolling resistance

Ax = (-1)*(1./mass).*(Fx + D + Rr);

end

