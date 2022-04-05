%parameters: track_data, straight parameter, cornering parameters, epsilon
function [totalT,  v, t,locations] = runLapSim(track,sp,cp,ep)

track_1 = importdata(track);
t_elements = track_1.data(:,1);
t_radius = track_1.data(:,2);
t_length = track_1.data(:,3);
fprintf("Total track length: %.3fm\n",sum(t_length));

vel_temp = 17.43; %initial speed
totalT= 0; %initial time 
locations = [];
v = vel_temp; %velocity vector
t = totalT; %time vector

%Loops through the different elements of the track
for ct = 1:length(t_elements)   
    if (t_elements(ct) == 1)&&(ct < length(t_elements))
        
        fprintf("Element %d: straight with braking\n",ct);  
        [time_v, vel_v, ~] = speed_transient(sp, cp, t_length(ct), t_radius(ct+1),ep,vel_temp);
        
    elseif (t_elements(ct) == 0)&&(t_elements(ct+1) == 1)&&(ct < length(t_elements)) %steady state cornering
        
        fprintf("Element %d: steady state corner\n", ct); 
        [time_v,vel_v] = cornering(t_length(ct),vel_temp);
             
    elseif (t_elements(ct) == 0)&&(t_elements(ct+1) == 0)&&(ct < length(t_elements))
        
        allowed_v = cornerFunc(cp,t_radius(ct),10);
        time_v_a = 0;
        td = 0;
        vel_v_a = allowed_v; 
        
        if (vel_temp < allowed_v) %entry speed below allowed speed       
            [time_v_a, td, vel_v_a] = acceleration_target(vel_temp, allowed_v, sp, t_radius(ct)); %TODO
            % calculate time it took to accelerate up to speed and amount of the arc length used for that
            vel_temp = vel_v_a(end);
        end   
        
        t_dis = t_length(ct) - td; %remaining arc distance for SS corner
        
        if (t_radius(ct+1)>=t_radius(ct)) % Situation 1: V_2 > V1
            fprintf("Element %d: succesive corners: slow to fast\n", ct);
            % Next corner is faster so drive at allowed_v for entire arc
            [time_v,vel_v] = cornering(t_length(ct),vel_temp);                
        else % Situation 2: V2 < V1
            fprintf("Element %d: succesive corners: fast to slow\n", ct);
            %calculate the amount of distance required to brake to v_allowed
            v_n = cornerFunc(cp,t_radius(ct+1),10); %Allowed velocity of next corner
            [t_b, v_b, braking_distance] = decel(v_n, t_dis,ep,vel_temp); %calculate distance, time req and final velocity  
            t_dis = t_dis - braking_distance; %adjusted cornering distance
            
            [t_c,v_c] = cornering(t_dis,vel_temp);
            
            t_b = t_b + t_c(end);    
            time_v = [t_c, t_b];
            vel_v = [v_c; v_b'];                                 
        end
        
        if (time_v_a~=0) %only add acceleration if we have to speed up for the corner
            time_v = time_v + time_v_a(end);
            time_v = [time_v_a, time_v];
            vel_v = [vel_v_a; vel_v];
        end
        
    else %final straight
        fprintf("Element %d: final straight\n", ct);
        [time_v,vel_v] = acceleration(vel_temp, t_length(ct),sp);      
    end
    
    v = [v; vel_v];
    time_v = time_v + t(end);
    locations = [locations length(t)];
    t = [t, time_v];
    vel_temp = v(end);
    %fprintf("End Velocity %.3f total time: %.3f\n",v(end), t(end));
end

totalT = t(end);

end
