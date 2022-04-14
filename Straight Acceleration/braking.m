function [Time, V, td] = braking(vi, dist, parameters)

td = 0; %Traveled distance
h = 0.01;
Ai = 0; %The instantaneous starting acceleration is 0
t = 0;
V =[vi];
Time = [0];
e = 0.001;
vo = 1;
while td < dist && vo ~=0
    
    t = t+h;
 
    
    midV = vi + (h./2).*Ai;
    [~,midslope] = tl_brake(midV,Ai,parameters);
    vo = vi + h.*midslope;
    Ai = midslope;
    if vo <= 0.001
        vo = 0;
    end
    
    V = vertcat(V,vo);
    vi = vo;
    Time = [Time t]; %Increments total time
    traveled_dis = cumtrapz(Time,V);
    td = traveled_dis(end);
        
end



%TODO


end