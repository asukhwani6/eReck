%Vehicle Parameters (all units SI)

g = 9.81; %acceleration due to gravity

mass = 222; %[kg]

L = 1.53; %wheelbase

b = 0.732; %distance from CG to rear axle

%mu = 1.8; %longitudinal tire coefficient of friction

m_u = 1.5;

Tm = 120; %motor torque

N = 4.44; %gear ratio

Im = 0.0441 + 0.02; %motor + motor output shaft rotational inertia 

Ip = 0.144; %powertrain rotational inerta (2x wheels + diff)

r = 0.203; %tire radius

rho = 1.225; %air density

Cd = 1.3; %drag coefficient

Cl = 2.6; % Lift coefficient

A = 1; %frontal (reference) area

Crr = 0.028; %rolling resistance coefficient

eta = 0.80; %powertrain efficiency 

Kf = 113 * 57.3; %Front roll stiffness

Kr = 113 * 57.3; %Rear roll stiffness

hf = 0.058; %Front roll center height

hr = 0.071; %Rear roll center height 

hg = 0.1778; %CG height

hl = hg - (((hr-hf)/L)*(L-b) + hf); %Distance from CG to roll axis 

v = 9.69;

t = 1.215; %track

straight_parameters = [mass L hg b m_u Tm N Im Ip r rho Cd A Crr eta g Cl];

cornering_parameters = [mass, Kf, Kr, L, b, rho, hf, hr, hg, hl, Cl, A, t, g, v];