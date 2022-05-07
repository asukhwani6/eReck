function y = brakeSolve(braking_distance, entry_vel, allowed_v, track_radius, track_length, Ax_in, Parameters)
dAccel = track_length - braking_distance;
[~, accel_v, accel_Ax] = accel(track_radius, dAccel, entry_vel, Ax_in, Parameters);
% if braking distance = track length, acceleration distance = 0, thus
% accel_v will be empty
if isempty(accel_v)
    brakeEntryV = entry_vel;
    brakeEntryAx = Ax_in;
else
    brakeEntryV = accel_v(end);
    brakeEntryAx = accel_Ax(end);
end

if allowed_v > brakeEntryV
    y = 0;
    % return zero (break optimization) if vehicle does not accelerate above
    % next corner maximum velocity. Initial solver guess passes 0 braking
    % distance, so optimization will end if vehicle is incapable of
    % exceeding velocity limit of next corner while accelerating fully
    % through current event
else
    [~, brake_v] = braking(track_radius, braking_distance, brakeEntryV, brakeEntryAx, Parameters);
    if isempty(brake_v)
        brakeExitV = brakeEntryV;
    else
        brakeExitV = brake_v(end);
    end
    % hard code required to ensure solution meets brakeExitV < allowed_v
    if brakeExitV > allowed_v
        y = 1;
    else
        y = brakeExitV - allowed_v;
    end
end