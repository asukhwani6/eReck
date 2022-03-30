%Script: Acceleration Performance 

%This script models the acceleration performance of HyTech's   The
%output will be a graphs of acceleration, velocity, and displacement with
%time. 

%The acceleration performance is calculated using Newton's Second Law
%for both the traction-limited and power-limited acceleration regimes.
%The midpoint method was chosen for its compromise of increased accuracy
%over Euler's method while being slightly more difficult to implement. A
%more accurate Runge-Kutta method can be used in the future to improve the
%model.

%Do not edit anything other than the vehicle parameters unless you
%understand the numerical methods used to solve the ODEs.

%----------------------------------------------------------------------

%Vehicle Parameters (all units SI)

vehicle = struct;

mass = 173;

L = 1.53; %wheelbase

h = 0.35; %CG height

b = 0.732; %distance from CG to rear axle

mu = 1.1; %longitudinal tire coefficient of friction

Tm = 140; %motor torque

N = 4.44; %gear ratio

Ip = 0.0134; %powertrain rotational inertia

Iw = 0.094; %wheel rotational inertia

r = 0.203; %tire radius

rho = 1.225; %air density

Cd = 0.907; %drag coefficient

A = 1.334; %frontal area

Crr = 0.02; %rolling resistance coefficient

eta = 0.8; %powertrain efficiency

save(vehicle);




