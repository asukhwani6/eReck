function [v,t,eventIndices,Ax,Ay] = runLapSimOptimized(vel_start,track,Parameters)
%% Get Used Vehicle Parameters:
% UPDATE VEHICLE PARAMETERS IN VEHICLE PARAMETER FILES
L = Parameters.L; % Wheelbase
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

for ct = 1:length(t_length)
    fprintf("%d element\n",ct)
    % CASE STATEMENTS FOR CORNERING AND STRAIGHTS

    %sa = rad2deg(L/t_radius(ct));
    %velLimit = cornerFunc(Parameters,t_radius(ct),sa);

    % If last element, velocity limit of next corner is defined as the maximum 64 bit floating point number
    % Else velocity limit is calculated based on next track element
    if (ct == length(t_radius))
        velLimitNextCorner = realmax;
    else 
        velLimitNextCorner = velLimit(t_radius(ct+1),Parameters);
    end

    [time_v, vel_v, Ax_v, Ay_v] = speed_transient(t_length(ct),t_radius(ct),vel_0,velLimitNextCorner, Parameters);
    

    time_v = time_v + t(end);
    t = [t, time_v];
    v = [v, vel_v];
    Ax = [Ax,Ax_v];
    Ay = [Ay,Ay_v];
    eventIndices = [eventIndices length(t)];

    % if final velocity of event which just occured is greater than maximum
    % input velocity of the next event

    if vel_v(end) > velLimitNextCorner
        % loop through track elements in reverse order to correct discrepancies
        [v, t, eventIndices] = recurEvents(vel_v(end), ct, v, t, eventIndices, Parameters, optim_number, t_radius, t_length, Ax, Ay);
    end

    vel_0 = v(end);
end
end