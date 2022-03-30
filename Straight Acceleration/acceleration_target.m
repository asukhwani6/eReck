%parameters: entry velocity, final_velocity | output: time, distance

function [time, traveled_dis, exit_v] = acceleration_target(entry_v, target_v,parameters, allowed_distance)

h = 0.1;%Time step size

V = [entry_v];
Time = [0];
traveled_dis = 0;
t = 0;
vi = entry_v;

%Midpoint method for loop
while (vi < target_v) && (traveled_dis < allowed_distance)
    
    t = t + h; % iterate time
    
    %Determines which regime to iterate
    [Ft,~] = tractionLimited(vi,parameters);
    [Fp,~] = powerLimited(vi,parameters);
    
    if Ft <= Fp
        
        [~,Ai] = tractionLimited(vi,parameters);      
        midV = vi + (h./2).*Ai;       
        [~,midslope] = tractionLimited(midV,parameters);
        vo = vi + h.*midslope;
        Ax = midslope;      
       
    elseif Fp < Ft
        
        [~,Ai] = powerLimited(vi,parameters);
        midV = vi + (h./2).*Ai; 
        [~,midslope] = powerLimited(midV,parameters);
        vo = vi + h.*midslope;
        Ax = midslope;            
    end
    
    %storing values calculated by midpoint method
    V = vertcat(V,vo);
    vi = vo;
    Time = [Time t]; %Increments total time
    traveled_dis = cumtrapz(Time,V);
    traveled_dis = traveled_dis(end);
end

time = t;
exit_v = V(end);

end
