function [Fx,Ax] = tractionLimited(v,Ax,Parameters)

%Author: Marc Maquiling,maquilingm@gatech.edu,646-745-4078
%Date: 12/28/21

% Get Used Vehicle Parameters:
% UPDATE VEHICLE PARAMETERS IN VEHICLE PARAMETER FILES

mass = Parameters.mass; % Vehicle + driver mass
rho = Parameters.rho; % Density of air
Cd = Parameters.Cd; % Drag coefficient
A = Parameters.A; % Reference frontal area
Crr = Parameters.Crr; % Tire rolling resistance coefficient
L = Parameters.L; % Wheelbase
hg = Parameters.hg; % CG height
b = Parameters.b; % Distance from CG to rear axle
g = Parameters.g; % Gravity

%TODO: ADD ROTATIONAL INERTIA EFFECTS TO TRACTION LIMITED ACCELERATION

Ip = Parameters.Ip; % Powertrain rotational inertia (2x wheels + diff)
N = Parameters.N; % Powertrain gear reduction
r = Parameters.r; % Tire radius
eta = Parameters.eta; % Powertrain Efficiency

%This if statement calculates the tractive force at the beginning of
%acceleration. After that, the else statement, calculates the traction
%limited tractive force as a function of acceleration, since the weight on
%the drive wheels will decrease as the acceleration decreases.

%Fx = ((m_u.*mass.*9.81.*b)./L)/(1-((m_u.*h)./L)); 

Fz = mass * g * ( (b/L) + (Ax/g)*(hg/L));

Fx = 2*tire_x(Fz/2); %symmetric weight distribution

D = 0.5.*rho.*Cd.*v.^2.* A; %drag force

Rr =  Crr.* mass.*9.81; %Rolling resistance

Ax = (1./mass).*(Fx - D - Rr);

end

