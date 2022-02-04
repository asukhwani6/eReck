%Straight Parameters decode
function[mass, L, h, b, m_u,Tm, N, Im, Ip, r, rho, Cd, A, Crr, eta] = param_decode(parameters)

mass = parameters(1); %[kg]

L = parameters(2); %wheelbase

h = parameters(3); %CG height

b = parameters(4); %distance from CG to rear axle

%mu = 1.8; %longitudinal tire coefficient of friction

m_u = parameters(5);

Tm = parameters(6); %motor torque

N = parameters(7); %gear ratio

Im = parameters(8); %motor + motor output shaft rotational inertia 

Ip = parameters(9); %powertrain rotational inerta (2x wheels + diff)

r = parameters(10); %tire radius

rho = parameters(11); %air density

Cd = parameters(12); %drag coefficient

A = parameters(13); %frontal area

Crr = parameters(14); %rolling resistance coefficient

eta = parameters(15); %powertrain efficiency 

end

