% Calculates time and exit_v for constant speed then decelerates to target
function [time,  v, braking_distance] = decel(allowed_v,track_length, optim_number, entry_vel,straight_parameters)

threshold = 0.005;

if (track_length> 40)
    d = linspace(track_length/3, track_length,optim_number);
else
    d = linspace(0.5, track_length,optim_number);
end

%Optimization loop to calculate best brake balance
for i = 1:optim_number %always sweep from braking entire distance
    
    braking_distance = track_length - d(i);
    [time, v] = braking(entry_vel,braking_distance,straight_parameters);

    if abs(allowed_v - v(end))< threshold || (v(end) > allowed_v) %Reaches threshold, or velocity below allowed velocity
        break %end optimization
    end
    
end
