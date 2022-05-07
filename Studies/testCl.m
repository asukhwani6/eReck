%% Cl target sweep
HT06_vehicle_parameters;
cl = [];
skidpad = [];
velocity = [];
time = [];
i = 1;
%while cl_var < 4
cl_var = linspace(0,4,20)
for i = 1:length(cl_var)
% overwrite driver mass with lowest mass driver
% Parameters.driverMass = 50; %kg
Parameters.mass = Parameters.driverMass + Parameters.curbMass;
Parameters.Cl = cl_var(i);
velocity(i) = velLimit(8.5, Parameters);
time(i) = 2*8.5*pi/velocity(i);
i = i+1;
end
plot(time, cl_var, "*")
xlabel("Skidpad Time (s)")
ylabel("Coefficient of Lift (expressed as a positive integer)")
title("Coefficient of Lift vs Skidpad Time")