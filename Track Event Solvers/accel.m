function [tVec, vVec, AxVec, AyVec, FxTiresMat, FzTiresMat] = accel(r,l,v, Ax_in, Parameters)
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
slipAngle = sin(deg2rad(5));

%%
% Timestep = 0.01 seconds
t = 0;
dt = 0.001;

Ax = Ax_in;
dist = 0;
vVec = [];
tVec = [];
AxVec = [];
AyVec = [];
FzTiresMat = [];
FxTiresMat = [];

while(abs(dist)<l)
    t = t + dt;
    [f_z, ~] = tireNormalForces(Ax,v,r,Parameters);
    [f_x, f_y] = fff(f_z, v,r,Parameters,0);
    
    % Power limitation
    [FxFrontPowerLimited,FxRearPowerLimited] = powerLimited(v,Parameters);
    rearAxleForceTraction = f_x(1) + f_x(2);
    frontAxleForceTraction = f_x(3) + f_x(4);
    FxOutRear = min(FxRearPowerLimited,rearAxleForceTraction);
    FxOutFront = min(FxFrontPowerLimited,frontAxleForceTraction);

    % Distribute rear power through locked differential
    f_x(1) = (f_x(1)/rearAxleForceTraction)*FxOutRear;
    f_x(2) = (f_x(2)/rearAxleForceTraction)*FxOutRear;
    f_x(3) = (f_x(3)/frontAxleForceTraction)*FxOutFront;
    f_x(4) = (f_x(4)/frontAxleForceTraction)*FxOutFront;

    % Calculate acceleration and midpoint velocity using midpoint ODE
    % solver
    Frr = sum(f_z)*Crr;
    Fd = 0.5*(v^2)*Cd*A*rho;

    %TODO: ADD SLIP ANGLE DETERMINATION THROUGH STEERING ANGLE, VEHICLE
    %HEADING, RADIUS
    FxLatTireDrag = sum(f_y*slipAngle);
    NetFx = sum(f_x) - Fd - Frr - FxLatTireDrag;
    Ax = NetFx/mass;
    midV = v + (dt./2).*Ax;

    % Recalculate normal forces
    [f_z, ~] = tireNormalForces(Ax,midV,r,Parameters);
    [f_x, f_y] = fff(f_z,midV,r,Parameters,0);

     % Power limitation
    [FxFrontPowerLimited,FxRearPowerLimited] = powerLimited(v,Parameters);
    rearAxleForceTraction = f_x(1) + f_x(2);
    frontAxleForceTraction = f_x(3) + f_x(4);
    FxOutRear = min(FxRearPowerLimited,rearAxleForceTraction);
    FxOutFront = min(FxFrontPowerLimited,frontAxleForceTraction);

    % Distribute rear power through locked differential
    f_x(1) = (f_x(1)/rearAxleForceTraction)*FxOutRear;
    f_x(2) = (f_x(2)/rearAxleForceTraction)*FxOutRear;
    f_x(3) = (f_x(3)/frontAxleForceTraction)*FxOutFront;
    f_x(4) = (f_x(4)/frontAxleForceTraction)*FxOutFront;

    % Calculate acceleration
    Frr = sum(f_z)*Crr;
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
    FzTiresMat = [FzTiresMat; f_z];
    FxTiresMat = [FxTiresMat; f_x];
end