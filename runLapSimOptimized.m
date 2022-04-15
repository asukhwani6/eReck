function [v,t,locations] = runLapSimOptimized(vel_start,track,sp,cp,ep)

track_1 = importdata(track);
t_radius = track_1.data(:,2)./3.281; %[M]
t_length = track_1.data(:,3)./3.281; %[M]
optim_number = 500;

vel_0 = vel_start; %initial speed
totalT= 0; %initial time
locations = [];
v = vel_0; %velocity vector
t = totalT; %time vector

for ct = 1:length(t_length)
fprintf("%d element\n",ct)
    % CASE STATEMENTS FOR CORNERING AND STRAIGHTS

    sa = rad2deg(sp(2)/t_radius(ct));
    velLimit = cornerFunc(cp,t_radius(ct),sa);
    
    saNextCorner = rad2deg(sp(2)/t_radius(ct+1));
    velLimitNextCorner = cornerFunc(cp,t_radius(ct+1),saNextCorner);
    

    if (t_radius(ct) == 0) && (ct < length(t_radius)) %straight with subsequent events

        [time_v, vel_v, ~] = speed_transient(sp, t_length(ct),optim_number,vel_0,velLimitNextCorner);

    elseif (t_radius(ct) ~= 0) && (ct < length(t_radius)) %corner

        [time_v, vel_v] = speed_transient_corner(sp, t_length(ct), velLimitNextCorner, velLimit, ep,vel_0);

    elseif (t_radius(ct) == 0) && (ct == length(t_radius)) %straight with no subsequent events

        [time_v, vel_v, ~] = speed_transient(sp, t_length(ct),optim_number,vel_0,realMax);

    elseif (t_radius(ct) ~= 0) && (ct == length(t_radius)) %corner with no subsequent events

        [time_v, vel_v] = speed_transient_corner(sp, t_length(ct), velLimitNextCorner, velLimit, ep,vel_0);

    end

    time_v = time_v + t(end);
    t = [t, time_v];
    v = [v, vel_v'];
    locations = [locations length(t)];

    % if final velocity of last event is greater than maximum input velocity
    % of next event
    if vel_v(end) > velLimitNextCorner
        % recursively loop through track elements
        [v, t, locations] = recurEvents(vel_v(end), ct, v, t, locations, sp, cp, ep, optim_number, t_radius, t_length);
    end

    vel_0 = v(end);
end
end