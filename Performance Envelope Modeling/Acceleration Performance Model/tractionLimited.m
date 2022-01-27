function [Fx,Ax] = tractionLimited(v)

%Author: Marc Maquiling,maquilingm@gatech.edu,646-745-4078
%Date: 12/28/21

load("vehicle");

%This if statement calculates the tractive force at the beginning of
%acceleration. After that, the else statement, calculates the traction
%limited tractive force as a function of acceleration, since the weight on
%the drive wheels will decrease as the acceleration decreases.

Fx = ((mu.*mass.*9.81.*b)./L)/(1-((mu.*h)./L)); 

%Fx = (mu.*mass.*9.81).*(b./L + (Ai./9.81).*(h./L));

D = 0.5.*rho.*Cd.*v.^2.* A; %drag force

Rr =  Crr.* mass.*9.81; %Rolling resistance

Ax = (1./mass).*(Fx - D - Rr);

end

