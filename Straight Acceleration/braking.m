function [tVec, vVec] = braking(r,l,v,Parameters)

% Get Vehicle Parameters
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
vVec = [v];
tVec = [0];

if r == 0
    r = realmax;
end

while(abs(dist)<l)
    t = t + dt;
    [FzTires, ~] = tireNormalForces(Ax,v,r,Parameters);
    [f_x, ~] = fff(FzTires, v,r,Parameters,0);
    
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
    NetFx = sum(f_x) + Fd + Frr;
    Ax = -NetFx/mass;
    midV = v + (dt./2).*Ax;
    if midV >0
        % Recalculate normal forces
        [FzTires, ~] = tireNormalForces(Ax,midV,r,Parameters);
        [f_x, ~] = fff(FzTires,midV,r,Parameters,0);
        
        % Minimum of both rear wheel brake force is used for traction limited
        % braking
        f_x(1) = min(f_x(1),f_x(2));
        f_x(2) = min(f_x(1),f_x(2));
        f_x(3) = min(f_x(3),f_x(4));
        f_x(4) = min(f_x(3),f_x(4));
        
        % Calculate acceleration
        Frr = sum(FzTires)*Crr;
        Fd = 0.5*(midV^2)*Cd*A*rho;
        NetFx = sum(f_x) + Fd + Frr;
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
end
end