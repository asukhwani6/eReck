%Corners Parameters decode
function [mass, Kf, Kr, L, b, rho, hf, hr, hg, hl, Cl, A, t, g, v] = corner_decode(cornering_parameters)

mass = cornering_parameters(1);

Kf = cornering_parameters(2); %Front roll stiffness

%Kr = 113; %Rear roll stiffness

Kr = cornering_parameters(3);

L = cornering_parameters(4); %Wheelbase

b = cornering_parameters(5); %Distance from CG to front axle

rho = cornering_parameters(6); %Air density

hf = cornering_parameters(7); %Front roll center height

hr = cornering_parameters(8); %Rear roll center height 

hg = cornering_parameters(9); %CG height

hl = cornering_parameters(10); %Distance from CG to roll axis 

Cl = cornering_parameters(11); % Lift coefficient 

A = cornering_parameters(12); %Reference area

t = cornering_parameters(13); %track

g = cornering_parameters(14); %acceleration due to gravity 

%Cf = (Kf./t).*((mass.*g.*hl)./(Kf+Kr-mass.*g.*hl))+ ((mass.*g.*(L-b)./L).*hf)./t ; %Front lateral load transfer coefficient

%Cr = (Kr./t).*((mass.*g.*hl)./(Kf+Kr-mass.*g.*hl))+ (mass.*g.*((b./L).*hr))./t ; %Rear lateral load transfer coefficient

v = cornering_parameters(15);

end
