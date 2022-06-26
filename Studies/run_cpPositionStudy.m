% HT07_AMK_hubs_vehicle_parameters;
HT06_vehicle_parameters;

%% Accel
r = realmax;
l = 75;
v = 0;
Ax_in = 0;
bcpVary = linspace(0,Parameters.L,100);

for i = 1:length(bcpVary)
    Parameters.bcp = bcpVary(i);
    [tAccel, vAccel, AxAccel, AyAccel, FxTiresAccel, FzTiresAccel] = accel(r,l,v, Ax_in, Parameters);
    accelTime(i) = tAccel(end);
end

figure
plot(bcpVary, accelTime)

%% Skidpad
rSkidpad = 8.5; % m
% Parameters.hcp = 0;
for i = 1:length(bcpVary)
    Parameters.bcp = bcpVary(i);
    vSkidpad = velLimit(rSkidpad,Parameters);
    skidpadTime(i) = 2.*rSkidpad.*pi./vSkidpad;
end

figure
plot(bcpVary./Parameters.L, skidpadTime)