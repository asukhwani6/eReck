%parameters: distance | output: allowed_entry_velocity
function [time, v] = brake_calculator(braking_accel, dist, entry_v)


exit_v = sqrt(entry_v^2 + 2*braking_accel * dist);
time = abs((exit_v - entry_v)/(braking_accel));


if ~isreal(exit_v)
    time = 0;
    v = 0;
else
    time = 0:(time/30):time; %time vector
    v = linspace(entry_v,exit_v,length(time)); %velocity vector    
end

%TODO


end