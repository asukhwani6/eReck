%parameters: track_data, parameter
function [totalT] = runLapSim(track,straight_parameters,cornering_parameters)

track_1 = importdata(track);
track_elements = track_1.data(:,1);
track_radius = track_1.data(:,2);
track_length = track_1.data(:,3);

braking_a = -1.5 * 9.81; %max braking deceleration [m/s^2]

vel_temp = 0; %initial speed is 0
optim_number = 500;
threshold = 0.1;
totalT= 0;

%Loops through the different elements of the track
for ct = 1:length(track_elements)
    %fprintf("Calculating track element %d ",ct);
    
    if (track_elements(ct) == 1)&&(ct < length(track_elements))              
       %fprintf("straight with braking\n");
       
       %optimization loop to calculate best balance
       if (track_length(ct)> 40)
       d = linspace(track_length(ct)/3, track_length(ct),optim_number);
       else
       d = linspace(0.5, track_length(ct),optim_number);
       end
       
       allowed_v = allowed_cornering(track_radius(ct+1),cornering_parameters);
       %fprintf("Allowed Cornering Velocity %3f\n",allowed_v);
       
       for i = 1:optim_number %always sweep from braking entire distance
           %fprintf("Optimizing brake/accel balance, Iteration %d\n",i);
           braking_distance = track_length(ct) - d(i);
           [accel_time, exit_v] = acceleration(vel_temp, d(i),straight_parameters);          
           [brake_time, final_v] = brake_calculator(braking_a,braking_distance, exit_v);
           %fprintf("End Velocity %3f\n",final_v);
           if abs(allowed_v - final_v)<threshold || (final_v > allowed_v)
               break %end optimization
           end
       end
       vel_temp = final_v;
       %fprintf("End Velocity %3f\n",final_v);
       time = accel_time + brake_time;   
       
    elseif (track_elements(ct) == 0)&&(ct < length(track_elements)) %steady state cornering
        %fprintf("steady state corner\n");
       time = cornering(track_length(ct),vel_temp);       
    else %final straight
        %fprintf("final straight\n");
        [accel_time, final_v] = acceleration(vel_temp, track_length(ct),straight_parameters);
        time = accel_time;
    end
    
    totalT = totalT + time;
end

%fprintf("Lap Time: %3fs\n",totalT);

end
