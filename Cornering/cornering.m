%Parameters: Radius of Turn, Entry Velocity | Output: Time

function [time,v] = cornering(turn_arc, entry_vel)

time_req = turn_arc/entry_vel;

time = linspace(0,time_req,30); %Length of time vector picked arbitrarily
v = ones(length(time),1) * entry_vel; %Constant Velocity



end




