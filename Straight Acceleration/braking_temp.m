function [Time, V, td] = braking_temp(vi, dist, parameters,t_v)

td = 0; %Traveled distance
h = 0.005;
Ai = 0; %The instantaneous starting acceleration is 0
t = 0;
V =[vi];
Time = [0];
e = 0.001;
lg = 1;
while td < dist && lg ~=0
    
    t = t+h;
 
    
    midV = vi + (h./2).*Ai;
    [~,midslope] = tl_brake(midV,Ai,parameters);
    vo = vi + h.*midslope;
    Ai = midslope;
    
    if (vo - t_v) <= 0.001
        lg = 0;
    end
    
    V = vertcat(V,vo);
    vi = vo;
    Time = [Time t]; %Increments total time
    traveled_dis = cumtrapz(Time,V);
    td = traveled_dis(end);
        
end

if td > dist
    td = dist;
end


end