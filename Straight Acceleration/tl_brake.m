%calculates the instantaneous braking force

function [Fx,Ax] = tl_brake(v,Ax,parameters)


[mass, L, h, b, m_u,Tm, N, Im, Ip, r, rho, Cd, A, Crr, eta, g] = param_decode(parameters);


c = L - b; %distance from CG to front axle

Fz = mass * g * ( (c/L) + (-Ax/g)*(h/L));
   
Fx = 2*tire_x(Fz/2);

D = 0.5.*rho.*Cd.*v.^2.* A; %drag force

Rr =  Crr.* mass.*9.81; %Rolling resistance

Ax = (-1)*(1./mass).*(Fx + D + Rr);

end

