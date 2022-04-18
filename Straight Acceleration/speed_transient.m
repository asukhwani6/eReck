function [time,  v, braking_distance] = speed_transient(Parameters,track_length, optim_number, entry_vel, allowed_v)

d = linspace(0.5, track_length,optim_number);

%fprintf("Allowed Cornering Velocity %3f\n",allowed_v);

%Optimization loop to calculate best brake balance
for i = 1:optim_number %always sweep from braking entire distance
    %fprintf("Optimizing brake/accel balance, Iteration %d\n",i);
    
    braking_distance = track_length - d(i);
    
    [accel_time, accel_v] = acceleration(entry_vel,0, d(i),Parameters,1);
    
    %[brake_time, exit_v] = brake_calculator(braking_a,braking_distance, accel_v(end));
    [brake_time, brake_v,~] = braking(accel_v(end), braking_distance, Parameters);
    %fprintf("End Velocity %3f\n",final_v);
    if (i ~=1 && i ~=optim_number)
        if ((brake_v(end) > allowed_v(end)))
            brake_v = tempBrake_v;
            brake_time = tempBrake_time;
            break %end optimization
        end
    end
    tempBrake_v = brake_v;
    tempBrake_time = brake_time;
end

v = [accel_v; brake_v];
brake_time = brake_time + accel_time(end);

%fprintf("End Velocity %3f\n",final_v);
time = [accel_time,  brake_time];