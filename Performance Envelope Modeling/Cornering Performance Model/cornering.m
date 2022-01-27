%Script: Cornering 


var = linspace(150,300,20);

Lateral_Acceleration = [];

%for i = var
mass = 173;

Kf = 113; %Front roll stiffness

%Kr = 113; %Rear roll stiffness

Kr = 256;

L = 1.53; %Wheelbase

b = 0.732; %Distance from CG to front axle

rho = 1.225; %Air density

hf = 0.058; %Front roll center height

hr = 0.071; %Rear roll center height 

hg = 0.215; %CG height
%hg = 0.215-0.045;
%hg = 0.35;

hl = hg - (((hr-hf)/L)*(L-b) + hf); %Distance from CG to roll axis 

Cl = 2.48; % Lift coefficient 

A = 1.334; %Reference area

t = 1.215; %track

g = 9.81; %acceleration due to gravity 

%Cf = (Kf./t).*((mass.*g.*hl)./(Kf+Kr-mass.*g.*hl))+ ((mass.*g.*(L-b)./L).*hf)./t ; %Front lateral load transfer coefficient

%Cr = (Kr./t).*((mass.*g.*hl)./(Kf+Kr-mass.*g.*hl))+ (mass.*g.*((b./L).*hr))./t ; %Rear lateral load transfer coefficient

v = 9.69;

save("cornering_parameters");

syms a v 

assume(a > 0);

ffo = frontOutsideForce(); 
ffi = frontInsideForce();
frontForce = simplify(ffo + ffi);


fro = rearOutsideForce();
fri = rearInsideForce();
rearForce = simplify(fro + fri);

corneringForce = frontForce + rearForce;

%secondLaw = simplify(corneringForce - mass.*a);
secondLaw = simplify(corneringForce);

T = secondLaw == mass.*a; 

B = double(solve(T))./g;

B = B(2);

%latAccel = double(A(2,1))/9.81; %Lateral acceleration in g's

Lateral_Acceleration = [Lateral_Acceleration B];

%end

plot(var,Lateral_Acceleration);
title("Ay vs CG Height Sensitivity");
xlabel("CG Height (m)");
ylabel("Lateral Acceleration (g)");

