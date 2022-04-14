function [Fx,Ax] = tractionLimited(v,Ax,parameters,cock)

%Author: Marc Maquiling,maquilingm@gatech.edu,646-745-4078
%Date: 12/28/21

[mass, L, h, b, m_u,Tm, N, Im, Ip, r, rho, Cd, A, Crr, eta, g] = param_decode(parameters);

%This if statement calculates the tractive force at the beginning of
%acceleration. After that, the else statement, calculates the traction
%limited tractive force as a function of acceleration, since the weight on
%the drive wheels will decrease as the acceleration decreases.




%Fx = ((m_u.*mass.*9.81.*b)./L)/(1-((m_u.*h)./L)); 

    
Fz = mass * g * ( (b/L) + (Ax/g)*(h/L));

Fx = 2*tire_x(Fz/2); %symmetric weight distribution


D = 0.5.*rho.*Cd.*v.^2.* A; %drag force

Rr =  Crr.* mass.*9.81; %Rolling resistance

Ax = (1./mass).*(Fx - D - Rr);

end

