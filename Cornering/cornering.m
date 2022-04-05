%Parameters: Radius of Turn, Entry Velocity | Output: Time

function [time,v] = cornering(turn_arc, entry_vel)

time = linspace(0,(turn_arc/entry_vel),30);
v = ones(length(time),1) * entry_vel;



end




