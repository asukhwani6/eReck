function [tVec, vVec] = accel(r,l,v,Parameters)
%% Get Vehicle Parameters
Crr = Parameters.Crr;
Cd = Parameters.Cd;
A = Parameters.A;
rho = Parameters.rho;
mass = Parameters.mass;

% Timestep = 0.01 seconds
t = 0;
dt = 0.01;

Ax = 0;
dist = 0;
vVec = [];
tVec = [];

while(abs(dist)<l)
    t = t + dt;
    [FzTires, ~] = tireNormalForces(Ax,v,r,Parameters);
    [f_x, ~] = fff(FzTires, v,r,Parameters,0);
    
    % Power limitation
    [FxFrontPowerLimited,FxRearPowerLimited] = powerLimited(v,Parameters);
    rearAxleForceTraction = f_x(1) + f_x(2);
    FxOutRear = min(FxRearPowerLimited,rearAxleForceTraction);

    % Distribute rear power through locked differential
    f_x(1) = (f_x(1)/rearAxleForceTraction)*FxOutRear;
    f_x(2) = (f_x(2)/rearAxleForceTraction)*FxOutRear;
    f_x(3) = min(FxFrontPowerLimited,f_x(3));
    f_x(4) = min(FxFrontPowerLimited,f_x(4));

    % Calculate acceleration and midpoint velocity using midpoint ODE
    % solver
    Frr = sum(FzTires)*Crr;
    Fd = 0.5*(v^2)*Cd*A*rho;
    NetFx = sum(f_x) - Fd - Frr;
    Ax = NetFx/mass;
    midV = v + (dt./2).*Ax;

    % Recalculate normal forces
    [FzTires, ~] = tireNormalForces(Ax,midV,r,Parameters);
    [f_x, ~] = fff(FzTires,midV,r,Parameters,0);

    % Power limitation
    [FxFrontPowerLimited,FxRearPowerLimited] = powerLimited(v,Parameters);
    rearAxleForceTraction = f_x(1) + f_x(2);
    FxOutRear = min(FxRearPowerLimited,rearAxleForceTraction);

    % Distribute rear power through locked differential
    f_x(1) = (f_x(1)/rearAxleForceTraction)*FxOutRear;
    f_x(2) = (f_x(2)/rearAxleForceTraction)*FxOutRear;
    f_x(3) = min(FxFrontPowerLimited,f_x(3));
    f_x(4) = min(FxFrontPowerLimited,f_x(4));

    % Calculate acceleration
    Frr = sum(FzTires)*Crr;
    Fd = 0.5*(midV^2)*Cd*A*rho;
    NetFx = sum(f_x) - Fd - Frr;
    Ax = NetFx/mass;

    v = v + Ax*dt;
    dist = dist + v*dt;

    vVec = [vVec, v];
    tVec = [tVec, t];
end