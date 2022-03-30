%parameters: track_data, parameter
%TODO: visualization


function [totalT] = runLapSim(track,straight_parameters,cornering_parameters)

track_1 = importdata(track);
track_elements = track_1.data(:,1);
track_radius = track_1.data(:,2);
track_length = track_1.data(:,3);
fprintf("Total track length: %.3fm\n",sum(track_length));

vel_temp = 0; %initial speed is 0
optim_number = 500;
totalT= 0;

%Loops through the different elements of the track
for ct = 1:length(track_elements)
    %fprintf("Calculating track element %d ",ct);
    
    if (track_elements(ct) == 1)&&(ct < length(track_elements))
        fprintf("straight with braking\n");
        %TODO: make into function
        [time, vel_temp, ~] = speed_transient(straight_parameters, cornering_parameters, track_length(ct), track_radius(ct+1),optim_number,vel_temp);
        
        
    elseif (track_elements(ct) == 0)&&(track_elements(ct+1) == 1)&&(ct < length(track_elements)) %steady state cornering
        
        fprintf("steady state corner\n");
        time = cornering(track_length(ct),vel_temp);
        
    elseif (track_elements(ct) == 0)&&(track_elements(ct+1) == 0)&&(ct < length(track_elements))
         
        time_i = 0;
        td = 0;
        allowed_v = cornerFunc(cornering_parameters,track_radius(ct),10);
        
         if vel_temp <  allowed_v %entry speed below allowed speed
             
            [time_i, td, vel_temp] = acceleration_target(vel_temp, allowed_v, straight_parameters, track_radius(ct)); %TODO
                % calculate time it took to accelerate up to speed
                % calculate the amount of the arc length used for that               
         end
         
         t_dis = track_length(ct) - td;
         
         
         if (track_radius(ct+1)>=track_radius(ct)) % Situation 1: V_2 > V1
             fprintf("succesive corners: slow to fast\n");
             % Next corner is faster so drive at allowed_v for entire arc
             time_1 = cornering(t_dis,vel_temp);
             
         else % Situation 2: V2 < V1    
             fprintf("succesive corners: fast to slow\n");
            %calculate the amount of distance required to brake v_allowed
            v_n = cornerFunc(cornering_parameters,track_radius(ct+1),10);
            
            [time_b, vel_brake, braking_distance] = decel(v_n, t_dis,optim_number,vel_temp);
            
            t_dis = t_dis - braking_distance; %adjusted cornering distance
            
            time_c = cornering(t_dis,vel_temp);
            
            vel_temp = vel_brake; %final velocity is the brake velocity
            
            time_1 = time_b + time_c;
        end
        
        time = time_i + time_1;
        
    else %final straight
        fprintf("final straight\n");
        [accel_time, final_v] = acceleration(vel_temp, track_length(ct),straight_parameters);
        time = accel_time;
    end
    totalT = totalT + time;
    fprintf("End Velocity %.3f total time: %.3f\n",vel_temp, totalT);
end

%fprintf("Lap Time: %3fs\n",totalT);

end
