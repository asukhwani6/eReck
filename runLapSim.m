%parameters: track_data, straight parameter, cornering parameters, epsilon
function [totalT,  v, t,locations] = runLapSim(vel_start,track,sp,cp,ep)

track_1 = importdata(track);
t_elements =track_1.data(:,1);
t_radius = track_1.data(:,2)./3.281; %[M]
t_length = track_1.data(:,3)./3.281; %[M]


%fprintf("Total track length: %.3fm\n",sum(t_length));

vel_temp = vel_start; %initial speed
totalT= 0; %initial time 
locations = [];
v = vel_temp; %velocity vector
t = totalT; %time vector

%Loops through the different elements of the track
for ct = 1:length(t_elements)       
    
    if (t_elements(ct) == 1)&&(ct < length(t_elements))
        
        %fprintf("Element %d: straight %.3fm with braking\n",ct,t_length(ct));  
        [time_v, vel_v, ~] = speed_transient(sp, cp, t_length(ct), t_radius(ct+1),ep,vel_temp);
        
    elseif ct == length(t_elements)&&(t_elements(ct) == 0) %Added for edge case where ct+1 does not exist for SS cornering check
        %fprintf("Element %d: final corner\n",ct);  
        [time_v,vel_v] = cornering(t_length(ct),vel_temp);
        
    elseif (t_elements(ct) == 0)&&(t_elements(ct+1) == 1)&&(ct < length(t_elements)) %steady state cornering
        
        %fprintf("Element %d: steady state corner, arc length: %.3fm\n", ct,t_length(ct)); 
        [time_v,vel_v] = cornering(t_length(ct),vel_temp);
             
    elseif (t_elements(ct) == 0)&&(t_elements(ct+1) == 0)&&(ct < length(t_elements))
       
        
        sa = rad2deg(sp(2)/t_radius(ct)); %slip angle selection of this corner
        sa_n = rad2deg(sp(2)/t_radius(ct+1)); %slip angle selection of next corner
        

        allowed_v = cornerFunc(cp,t_radius(ct),sa);
        av_next = cornerFunc(cp, t_radius(ct+1),sa_n);
        
        time_v_a = 0;
        t_dis = t_length(ct);
        vel_v_a = allowed_v; 
        cornered = 0;
        
        %fprintf("Element %d: Current Radius: %.3f, Next Radius: %.3f, Curr V_al: %.3f Next V_al: %.3f\n",ct, t_radius(ct),t_radius(ct+1),allowed_v,cornerFunc(cp,t_radius(ct+1),10));
        
        if (vel_temp < allowed_v) %entry speed below allowed speed 
     
            if av_next < allowed_v %Check if next corner allowable velocity < current allowable velocity
                
                [time_v, vel_v] = speed_transient_corner(sp, t_length(ct), av_next, allowed_v, ep,vel_temp); %Treat as transient with steady state hold
                cornered = 1;          
            else
                [time_v_a, vel_v_a, td] = acceleration(vel_temp, allowed_v, t_length(ct), sp, 0); %TODO
                % calculate time it took to accelerate up to speed and amount of the arc length used for that
                vel_temp = vel_v_a(end);
                
                if t_length(ct) < td %TODO: edge case when u can't accel all the way before u run out of room to decelerate
                    t_dis = 0;
                else
                    t_dis = t_length(ct) - td; %remaining arc distance for SS corner
                end
                
            end      
        end   
        
        if (cornered == 0)
            if (t_radius(ct+1)>=t_radius(ct)) % Situation 1: V_2 > V1
                [time_v,vel_v] = cornering(t_dis,vel_temp); % Next corner is faster so drive at allowed_v for entire arc
            else % Situation 2: V2 < V1
                [t_b, v_b, braking_distance] = decel(av_next, t_dis,ep,vel_temp); %calculate distance, time req and final velocity
                t_dis = t_dis - braking_distance; %adjusted cornering distance
                [t_c,v_c] = cornering(t_dis,vel_temp);
                
                t_b = t_b + t_c(end);
                time_v = [t_c, t_b];
                vel_v = [v_c; v_b'];
            end
            
            if (time_v_a(end)~=0) %only add acceleration if we have to speed up for the corner
                time_v = time_v + time_v_a(end);
                time_v = [time_v_a, time_v];
                vel_v = [vel_v_a; vel_v];
            end
        end
        
    else 
        [time_v,vel_v] = acceleration(vel_temp,0, t_length(ct),sp,1); %final straight     
    end
    
    v = [v; vel_v];
    time_v = time_v + t(end);
    locations = [locations length(t)];
    t = [t, time_v];
    vel_temp = v(end);
    fprintf("End Velocity %.3f total time: %.3f\n",v(end), t(end));
end
fprintf("Done with loop\n");
totalT = time_v(end);

end


