%parameters: entry velocity, distance | output: time, exit velocity
% type = 1 for distance check, otherwise distance and velocity check
function [Time, V, traveled_dis, FnormFront, FnormRear] = acceleration(entry_v, target_v, dist,Parameters, type)

%TODO: ADD INERTIAL EFFECTS OF POWERTRAIN

mass = Parameters.mass; % Vehicle + driver mass
rho = Parameters.rho; % Density of air
Cd = Parameters.Cd; % Drag coefficient
Cl = Parameters.Cl; % Lift coefficient
A = Parameters.A; % Reference frontal area
Crr = Parameters.Crr; % Tire rolling resistance coefficient
L = Parameters.L; % Wheelbase
hg = Parameters.hg; % CG height
b = Parameters.b; % Distance from CG to rear axle
hcp = Parameters.hcp; % CP height
bcp = Parameters.bcp; % Distance from CP to rear axle
g = Parameters.g; % Gravity

h = 0.01;%Time step size

V = entry_v;
Time = 0;
traveled_dis = 0;
t = 0;
vi = entry_v;
Ai = 0;
check = 1;
FnormFront = [];
FnormRear = [];

%Midpoint method for loop
while check
    
    t = t + h; % iterate time

    % calculate drag
    Drag = 0.5.*rho.*Cd.*vi.^2.*A; %drag force
    % calculate lift
    Lift = 0.5.*rho.*Cl.*vi.^2.*A; %lift force
    % distribute aero forces based on Cp
    FzAeroFront = Lift*(bcp/L) - Drag*(hcp/L);
    FzAeroRear = Lift*((L-bcp)/L) + Drag*(hcp/L);

    % distribute inertial forces based on Cg
    FzInertialFront = mass*g*((b/L) - (Ai/g)*(hg/L));
    FzInertialRear = mass*g*(((L-b)/L) + (Ai/g)*(hg/L));

    % combine inertial and aero forces
    FzFront = FzAeroFront + FzInertialFront;
    FzRear = FzAeroRear + FzInertialRear;

    % Calculate traction limit and power limit
    FxTractionRear = 2*tire_x(FzRear/2); %symmetric weight distribution
    FxTractionFront = 2*tire_x(FzFront/2); %symmetric weight distribution
    [FxPowerFront,FxPowerRear] = powerLimited(vi,Parameters);

    % Determine tractive force and calculate longitudinal acceleration
    FxTraction = min([FxTractionFront FxPowerFront]) + min([FxTractionRear FxPowerRear]);
    Ai = (FxTraction - Drag - FzFront*Crr - FzRear*Crr)/mass;
    midV = vi + (h./2).*Ai;

    Drag = 0.5.*rho.*Cd.*midV.^2.*A; %drag force
    % calculate lift
    Lift = 0.5.*rho.*Cl.*midV.^2.*A; %lift force
    % distribute aero forces based on Cp
    FzAeroFront = Lift*(bcp/L) - Drag*(hcp/L);
    FzAeroRear = Lift*((L-bcp)/L) + Drag*(hcp/L);

    % distribute inertial forces based on Cg
    FzInertialFront = mass*g*((b/L) - (Ai/g)*(hg/L));
    FzInertialRear = mass*g*((b/L) + (Ai/g)*(hg/L));

    % combine inertial and aero forces
    FzFront = FzAeroFront + FzInertialFront;
    FzRear = FzAeroRear + FzInertialRear;

    % Calculate traction limit and power limit
    FxTractionRear = 2*tire_x(FzRear/2); %symmetric weight distribution
    FxTractionFront = 2*tire_x(FzFront/2); %symmetric weight distribution
    [FxPowerFront,FxPowerRear] = powerLimited(midV,Parameters);

    % Determine tractive force and calculate longitudinal acceleration
    FxTraction = min([FxTractionFront FxPowerFront]) + min([FxTractionRear FxPowerRear]);
    Ai = (FxTraction - Drag - FzFront*Crr - FzRear*Crr)/mass;
    vo = vi + h.*Ai;

%     tractionLimitedFront = FxTractionFront<FxPowerFront;
%     tractionLimitedRear = FxTractionRear<FxPowerRear;
%     if Ft <= Fp

%         [FxRear,FxFront] = tractionLimited(vi,Ai,Parameters); 
%         [~,Ai] = tractionLimited(vi,Ai,Parameters);     
%         midV = vi + (h./2).*Ai;       
%         [~,midslope] = tractionLimited(midV,Ai,Parameters);
%         vo = vi + h.*midslope;
%         Ai = midslope;      
%        
%     elseif Fp < Ft
%         
%         [~,Ai] = powerLimited(vi,Parameters);
%         midV = vi + (h./2).*Ai; 
%         [~,midslope] = powerLimited(midV,Parameters);
%         vo = vi + h.*midslope;
%         Ai = midslope;            
%     end
%     
    %storing values calculated by midpoint method

    V = vertcat(V,vo);
    vi = vo;
    Time = [Time t]; %Increments total time
    traveled_dis = cumtrapz(Time,V);
    traveled_dis = traveled_dis(end);
    FnormFront = [FnormFront,FzFront];
    FnormRear = [FnormRear,FzRear];
    
    %Condition check
    if (type == 1)
        check = (traveled_dis < dist);
    else
        check = (vi < target_v) && (traveled_dis < dist);
    
    end       
end


end



