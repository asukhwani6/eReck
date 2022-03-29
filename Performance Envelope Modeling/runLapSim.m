%parameters: track_data, parameter
%TODO: handle successive cornering
function [totalT] = runLapSim(track,straight_parameters,cornering_parameters)

track_1 = importdata(track);
track_elements = track_1.data(:,1);
track_radius = track_1.data(:,2);
track_length = track_1.data(:,3);

braking_a = -1.5 * 9.81; %max braking deceleration [m/s^2]
threshold = 0.1;
vel_temp = 0; %initial speed is 0
optim_number = 500;
totalT= 0;

%Loops through the different elements of the track
for ct = 1:length(track_elements)
    %fprintf("Calculating track element %d ",ct);
    
    if (track_elements(ct) == 1)&&(ct < length(track_elements))
        fprintf("straight with braking\n");
        %TODO: make into function
        [time, vel_temp] = speed_transient(straight_parameters, cornering_parameters, track_length(ct), track_radius(ct+1),optim_number,vel_temp);
        
        
    elseif (track_elements(ct) == 0)&&(track_elements(ct+1) == 1)&&(ct < length(track_elements)) %steady state cornering
        
        %TODO: Check if next is also corner
        
        fprintf("steady state corner\n");
        time = cornering(track_length(ct),vel_temp);
        
    elseif (track_elements(ct) == 0)&&(track_elements(ct+1) == 0)&&(ct < length(track_elements))
        
        fprintf("succesive corners\n");
        time_1 = cornering((track_length(ct)/2),vel_temp);
        [time_2, vel_temp] = speed_transient(straight_parameters, cornering_parameters, (track_length(ct)/2), track_radius(ct+1),optim_number,vel_temp);
        time = time_1 + time_2;
        
    else %final straight
        fprintf("final straight\n");
        [accel_time, final_v] = acceleration(vel_temp, track_length(ct),straight_parameters);
        time = accel_time;
    end
    fprintf("End Velocity %.3f total time: %.3f\n",vel_temp, totalT);
    totalT = totalT + time;
end

%fprintf("Lap Time: %3fs\n",totalT);

end
