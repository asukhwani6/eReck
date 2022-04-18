
function [Fx,Ax] = powerLimited(v,Parameters)

%Author: Marc Maquiling,maquilingm@gatech.edu,646-745-4078
%Date: 12/28/21

% Get Used Vehicle Parameters:
% UPDATE VEHICLE PARAMETERS IN VEHICLE PARAMETER FILES

mass = Parameters.mass; % vehicle + driver mass
N = Parameters.N; % Powertrain gear reduction
rho = Parameters.rho; % Density of air
Cd = Parameters.Cd; % Drag coefficient
A = Parameters.A; % Reference frontal area
Tm = Parameters.Tm; % Motor Torque
Im = Parameters.Im; % Motor + motor output shaft rotational inertia
Ip = Parameters.Ip; % Powertrain rotational inertia (2x wheels + diff)
r = Parameters.r; % Tire radius
Crr = Parameters.Crr; % Tire rolling resistance coefficient
eta = Parameters.eta; % Powertrain Efficiency

D = 0.5.*rho.*Cd.*v.^2.*A; % Drag force

Rr =  Crr.* mass.*9.81; % Rolling resistance force

adjTm = 140 -2.*10.^-5.*(v).^5+0.0014.*v.^4-0.0372.*v.^3+0.4109.*v.^2-1.7775.*v; %Torque(V)
if adjTm < Tm
    Tm = adjTm;
end

%^This function comes from the Emrax 208 torque vs RPM data. Data points
%from the spec sheet were put into an Excel sheet and then I fitted a curve
%to them.

netF = ((Tm.*N.*eta)./r) - D - Rr; %add tire drag = cornering force * 4 * sin(10)

if netF < 0

    Fx = 0;
    Ax = 0;
else

    Fx = (Tm.*N.*eta)./r;

    effectiveMass = (mass + ((Im.*N.^2+Ip)./r.^2));

    Ax = (1./effectiveMass).*netF;
end
end

