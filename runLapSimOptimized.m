function [v,t,eventIndices] = runLapSimOptimized(vel_start,track,Parameters,ep)
%% Get Used Vehicle Parameters:
% UPDATE VEHICLE PARAMETERS IN VEHICLE PARAMETER FILES
L = Parameters.L; % Wheelbase

%% Code
track_1 = importdata(track);
t_radius = track_1.data(:,2)./3.281; %[M]
t_length = track_1.data(:,3)./3.281; %[M]
optim_number = 500;

vel_0 = vel_start; %initial speed
totalT= 0; %initial time
eventIndices = [];
v = vel_0; %velocity vector
t = totalT; %time vector

for ct = 1:length(t_length)
    fprintf("%d element\n",ct)
    % CASE STATEMENTS FOR CORNERING AND STRAIGHTS

    sa = rad2deg(L/t_radius(ct));
    velLimit = cornerFunc(Parameters,t_radius(ct),sa);

    if (ct ~= length(t_radius))
        saNextCorner = rad2deg(L/t_radius(ct+1));
        velLimitNextCorner = cornerFunc(Parameters,t_radius(ct+1),saNextCorner);
    else % if last element, velocity limit of next corner is defined as the maximum 64 bit floating point number
        velLimitNextCorner = realmax;
    end

    if (t_radius(ct) == 0) %straight

        [time_v, vel_v, ~] = speed_transient(Parameters, t_length(ct),optim_number,vel_0,velLimitNextCorner);

    elseif (t_radius(ct) ~= 0) %corner

        [time_v, vel_v] = speed_transient_corner(Parameters, t_length(ct), velLimitNextCorner, velLimit, ep,vel_0);
    end

    time_v = time_v + t(end);
    t = [t, time_v];
    v = [v, vel_v'];
    eventIndices = [eventIndices length(t)];

    % if final velocity of event which just occured is greater than maximum
    % input velocity of the next event

    if vel_v(end) > velLimitNextCorner
        % loop through track elements in reverse order to correct discrepancy
        [v, t, eventIndices] = recurEvents(vel_v(end), ct, v, t, eventIndices, Parameters, ep, optim_number, t_radius, t_length);
    end

    vel_0 = v(end);
end
end