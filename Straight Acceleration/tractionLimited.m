function [Fx,Ax] = tractionLimited(v,parameters)

%Author: Marc Maquiling,maquilingm@gatech.edu,646-745-4078
%Date: 12/28/21

[mass, L, h, b, m_u,Tm, N, Im, Ip, r, rho, Cd, A, Crr, eta] = param_decode(parameters);

%This if statement calculates the tractive force at the beginning of
%acceleration. After that, the else statement, calculates the traction
%limited tractive force as a function of acceleration, since the weight on
%the drive wheels will decrease as the acceleration decreases.

Fx = ((m_u.*mass.*9.81.*b)./L)/(1-((m_u.*h)./L)); 

%Fx = (mu.*mass.*9.81).*(b./L + (Ai./9.81).*(h./L));

D = 0.5.*rho.*Cd.*v.^2.* A; %drag force

Rr =  Crr.* mass.*9.81; %Rolling resistance

Ax = (1./mass).*(Fx - D - Rr);

end

