function [tVec, vVec, AxVec, AyVec, FxVec, FzVec] = braking(r,l,v,Ax_in,Parameters)
%% Usage: Transient Braking, Both Cornering and Straight Line Braking
% Based on vehicle conditions (Ax, v, r), calculates instantaneous normal
% force at each tire. TTC tire data fit curves define performance envelope
% of tire at given condition and calculate overall braking force

% Inputs: radius, arc length, input velocity, Parameter structure
% Outputs: tVec, vVec
if r == 0
    r = realmax;
end

%% Get Vehicle Parameters
Cd = Parameters.Cd;
A = Parameters.A;
rho = Parameters.rho;
mass = Parameters.mass;

%% SLIP ANGLE CONSTANT, NOT A GOOD ASSUMPTION
slipAngle = deg2rad(7);

%%

% Timestep = 0.01 seconds
t = 0;
dt = 0.01;

Ax = Ax_in;
dist = 0;
vVec = [];
tVec = [];
AxVec = [];
AyVec = [];
FxVec = [];
FzVec = [];

while(abs(dist)<l)
    
    t = t + dt;
    [f_z, ~] = tireNormalForces(Ax,v,r,Parameters);
    [f_x, f_y] = fff(f_z, v,r,Parameters,0);
    
    % Minimum of both rear wheel brake force is used for traction limited
    % braking
    f_x(1) = min(f_x(1),f_x(2));
    f_x(2) = min(f_x(1),f_x(2));
    f_x(3) = min(f_x(3),f_x(4));
    f_x(4) = min(f_x(3),f_x(4));
    
    % Calculate acceleration and midpoint velocity using midpoint ODE
    % solver
    Fd = 0.5*(v^2)*Cd*A*rho;
    % Lateral Tire Drag
    FxLatTireDrag = sum(f_y*slipAngle);
    NetFx = sum(f_x) + Fd + FxLatTireDrag;
    Ax = -NetFx/mass;
    midV = v + (dt./2).*Ax;
    if midV >0
        % Recalculate normal forces
        [f_z, ~] = tireNormalForces(Ax,midV,r,Parameters);
        [f_x, f_y] = fff(f_z,midV,r,Parameters,0);
        
        % Minimum of both rear wheel brake force is used for traction limited
        % braking
        f_x(1) = min(f_x(1),f_x(2));
        f_x(2) = min(f_x(1),f_x(2));
        f_x(3) = min(f_x(3),f_x(4));
        f_x(4) = min(f_x(3),f_x(4));
        % Calculate acceleration
        
        Fd = 0.5*(midV^2)*Cd*A*rho;
        % Lateral tire drag
        FxLatTireDrag = sum(f_y*slipAngle);
        NetFx = sum(f_x) + Fd + FxLatTireDrag;
        Ax = -NetFx/mass;
        
        v = v + Ax*dt;
        dist = dist + v*dt;
    else
        Ax = 0;
        v = 0;
        break
    end
    vVec = [vVec, v];
    tVec = [tVec, t];
    AxVec = [AxVec, Ax];
    AyVec = [AyVec, (v^2)/r];
    FxVec = [FxVec; f_x];
    FzVec = [FzVec; f_z];
end
end