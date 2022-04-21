function [v] = velLimit(r, Parameters)

if r==0
    r = realmax;
end

err = realmax;
Ax = 0;
v = 0;
mass = Parameters.mass;
dt = 0.001;
Crr = Parameters.Crr;
rho = Parameters.rho;
Cd = Parameters.Cd;
A = Parameters.A;

while err > 0.0005
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
    vLast = v;
    v = v + Ax*dt;
    err = v - vLast;
end
    

end