function [tVec, vVec, AxVec, AyVec] = accel(r,l,v,Parameters)
%% Usage: Transient Acceleration, Both Cornering and Straight Line Accel
% Based on vehicle conditions (Ax, v, r), calculates instantaneous normal
% force at each tire. TTC tire data fit curves define performance envelope
% of tire at given condition and calculates overall power limited tractive
% force

% Inputs: radius, arc length, input velocity, Parameter structure
% Outputs: tVec, vVec, AxVec, AyVec

%% Convert 0 radius elements to straights with radius realmax
if r == 0 
    r = realmax;
end

%% Get Vehicle Parameters
Crr = Parameters.Crr;
Cd = Parameters.Cd;
A = Parameters.A;
rho = Parameters.rho;
mass = Parameters.mass;

%% SLIP ANGLE CONSTANT, NOT A GOOD ASSUMPTION
slipAngle = deg2rad(10);

%%
% Timestep = 0.01 seconds
t = 0;
dt = 0.01;

Ax = 0;
dist = 0;
vVec = [];
tVec = [];
AxVec = [];
AyVec = [];

while(abs(dist)<l)
    t = t + dt;
    [FzTires, ~] = tireNormalForces(Ax,v,r,Parameters);
    [f_x, f_y] = fff(FzTires, v,r,Parameters,0);
    
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
    %TODO: ADD SLIP ANGLE DETERMINATION THROUGH STEERING ANGLE, VEHICLE
    %HEADING, RADIUS
    FxLatTireDrag = sum(f_y*slipAngle);
    NetFx = sum(f_x) - Fd - Frr - FxLatTireDrag;
    Ax = NetFx/mass;
    midV = v + (dt./2).*Ax;

    % Recalculate normal forces
    [FzTires, ~] = tireNormalForces(Ax,midV,r,Parameters);
    [f_x, f_y] = fff(FzTires,midV,r,Parameters,0);

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
    %TODO: ADD SLIP ANGLE DETERMINATION THROUGH STEERING ANGLE, VEHICLE
    %HEADING, RADIUS
    FxLatTireDrag = sum(f_y*slipAngle);
    NetFx = sum(f_x) - Fd - Frr - FxLatTireDrag;
    Ax = NetFx/mass;

    v = v + Ax*dt;
    dist = dist + v*dt;

    vVec = [vVec, v];
    tVec = [tVec, t];
    AxVec = [AxVec, Ax];
    AyVec = [AyVec, (v^2)/r];
end