%parameters: distance | output: allowed_entry_velocity
function [time, exit_v] = brake_calculator(braking_accel, dist, entry_v)

exit_v = sqrt(entry_v^2 + 2*braking_accel * dist);
time = (exit_v - entry_v)/(braking_accel);

if (exit_v < 0)
    time = 0;
    exit_v = 0;
end

end