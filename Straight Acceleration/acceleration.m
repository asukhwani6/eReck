%parameters: entry velocity, distance | output: time, exit velocity
% type = 1 for distance check, otherwise distance and velocity check
function [Time, V, traveled_dis] = acceleration(entry_v, target_v, dist,parameters, type)

h = 0.01;%Time step size

V = [entry_v];
Time = [0];
traveled_dis = 0;
t = 0;
vi = entry_v;
Ai = 0;

check = 1;

%Midpoint method for loop
while check
    
    t = t + h; % iterate time
    
    %Determines which regime to iterate
    
    [Ft,Ai] = tractionLimited(vi,Ai,parameters);
    [Fp,~] = powerLimited(vi,parameters);
    
    if Ft <= Fp
        
        [~,Ai] = tractionLimited(vi,Ai,parameters);      
        midV = vi + (h./2).*Ai;       
        [~,midslope] = tractionLimited(midV,Ai,parameters);
        vo = vi + h.*midslope;
        Ai = midslope;      
       
    elseif Fp < Ft
        
        [~,Ai] = powerLimited(vi,parameters);
        midV = vi + (h./2).*Ai; 
        [~,midslope] = powerLimited(midV,parameters);
        vo = vi + h.*midslope;
        Ai = midslope;            
    end
    
    %storing values calculated by midpoint method
    V = vertcat(V,vo);
    vi = vo;
    Time = [Time t]; %Increments total time
    traveled_dis = cumtrapz(Time,V);
    traveled_dis = traveled_dis(end);
    
    %Condition check
    if (type == 1)
        check = (traveled_dis < dist);
    else
        check = (vi < target_v) && (traveled_dis < dist);
    
    end       
end


end



