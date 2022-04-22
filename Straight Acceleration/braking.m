function [tVec, vVec, AxVec, AyVec] = braking(r,l,v,Ax_in,Parameters)
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

Ax = Ax_in;
dist = 0;
vVec = [v];
tVec = [0];
AxVec = [0];
AyVec = [(v^2)/r];

while(abs(dist)<l)
    t = t + dt;
    [FzTires, ~] = tireNormalForces(Ax,v,r,Parameters);
    [f_x, f_y] = fff(FzTires, v,r,Parameters,0);
    
    % Minimum of both rear wheel brake force is used for traction limited
    % braking
    f_x(1) = min(f_x(1),f_x(2));
    f_x(2) = min(f_x(1),f_x(2));
    f_x(3) = min(f_x(3),f_x(4));
    f_x(4) = min(f_x(3),f_x(4));
    
    % Calculate acceleration and midpoint velocity using midpoint ODE
    % solver
    Frr = sum(FzTires)*Crr;
    Fd = 0.5*(v^2)*Cd*A*rho;
    % Lateral Tire Drag
    FxLatTireDrag = sum(f_y*slipAngle);
    NetFx = sum(f_x) + Fd + Frr + FxLatTireDrag;
    Ax = -NetFx/mass;
    midV = v + (dt./2).*Ax;
    if midV >0
        % Recalculate normal forces
        [FzTires, ~] = tireNormalForces(Ax,midV,r,Parameters);
        [f_x, f_y] = fff(FzTires,midV,r,Parameters,0);
        
        % Minimum of both rear wheel brake force is used for traction limited
        % braking
        f_x(1) = min(f_x(1),f_x(2));
        f_x(2) = min(f_x(1),f_x(2));
        f_x(3) = min(f_x(3),f_x(4));
        f_x(4) = min(f_x(3),f_x(4));
        
        % Calculate acceleration
        Frr = sum(FzTires)*Crr;
        Fd = 0.5*(midV^2)*Cd*A*rho;
        % Lateral tire drag
        FxLatTireDrag = sum(f_y*slipAngle);
        NetFx = sum(f_x) + Fd + Frr + FxLatTireDrag;
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
end
end