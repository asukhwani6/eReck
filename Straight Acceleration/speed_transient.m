function [time,  exit_v, braking_distance] = speed_transient(straight_parameters, cornering_parameters,track_length,track_radius, optim_number, entry_vel)

threshold = 0.1;
braking_a = -1.5 * 9.81; %max braking deceleration [m/s^2]

if (track_length> 40)
    d = linspace(track_length/3, track_length,optim_number);
else
    d = linspace(0.5, track_length,optim_number);
end

allowed_v = cornerFunc(cornering_parameters,track_radius,10); %Slip Angle 10
%fprintf("Allowed Cornering Velocity %3f\n",allowed_v);

%Optimization loop to calculate best brake balance
for i = 1:optim_number %always sweep from braking entire distance
    %fprintf("Optimizing brake/accel balance, Iteration %d\n",i);
    
    braking_distance = track_length - d(i);
    
    [accel_time, temp_v] = acceleration(entry_vel, d(i),straight_parameters);
    [brake_time, exit_v] = brake_calculator(braking_a,braking_distance, temp_v);
    %fprintf("End Velocity %3f\n",final_v);
    if abs(allowed_v - exit_v)<threshold || (exit_v > allowed_v)
        break %end optimization
    end
end
%fprintf("End Velocity %3f\n",final_v);
time = accel_time + brake_time;