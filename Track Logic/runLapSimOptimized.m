function [v,t,eventIndices,Ax,Ay,Fx, Fz, T, elecPower, eff, q] = runLapSimOptimized(vel_start,track,Parameters)

%% Get Used Vehicle Parameters:
% UPDATE VEHICLE PARAMETERS IN VEHICLE PARAMETER FILES
% CALCULATE TOTAL MASS BASED ON COMPONENT MASSES
Parameters.mass = Parameters.AccumulatorMass + Parameters.curbMass + Parameters.driverMass;
optim_number = Parameters.optim_number; %Discretization number

%% Code
track_1 = importdata(track);
t_radius = track_1.data(:,2)./3.281; %[M]
t_length = track_1.data(:,3)./3.281; %[M]

vel_0 = vel_start; %initial speed
eventIndices = [];
v = vel_0; %velocity vector
t = 0; %time vector
Ax = 0; % Longitudinal acceleration vector
Ay = 0; % Lateral acceleration vector
Fx = [0,0,0,0];
Fz = [0,0,0,0];
e = 0;
q = [0,0,0,0];
T = [0,0,0,0];
elecPower = [0,0,0,0];
eff = [0,0,0,0];

for ct = 1:length(t_length)
    % If last element, velocity limit of next corner is defined as the
    % maximum 64 bit floating point number. Else velocity limit is
    % calculated based on next track element 
    if (ct == length(t_radius))
        velLimitNextCorner = realmax;
    else 
        velLimitNextCorner = velLimit(t_radius(ct+1),Parameters);
    end

    [time_v, vel_v, Ax_v, Ay_v, Fx_v, Fz_v, T_v, elecPower_v, eff_v, q_v] = speed_transient(t_length(ct),t_radius(ct),vel_0,velLimitNextCorner, Ax(end), Parameters);
    

    time_v = time_v + t(end);
    t = [t, time_v];
    v = [v, vel_v];
    Ax = [Ax,Ax_v];
    Ay = [Ay,Ay_v];
    Fx = [Fx; Fx_v];
    Fz = [Fz; Fz_v];
    q = [q; q_v];
    T = [T; T_v];
    eff = [eff; eff_v];
    elecPower = [elecPower; elecPower_v];
    eventIndices = [eventIndices length(t)];

    % if final velocity of event which just occured is greater than maximum
    % input velocity of the next event

    if vel_v(end) > velLimitNextCorner
        disp('Entered recurEvents')
        % loop through track elements in reverse order to correct discrepancies
        [v, t, eventIndices, Ax, Ay, Fx, Fz, T, elecPower, eff, q] = recurEvents(vel_v(end), ct, v, t, eventIndices, optim_number, t_radius, t_length, Ax, Ay, Fx, Fz, T, elecPower, eff, q, Parameters);
    end

    vel_0 = v(end);
end
end