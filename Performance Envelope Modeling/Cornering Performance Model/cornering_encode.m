%% Initialize  HT06 Corner Parameters
mass = 248;

Kf = 113; %Front roll stiffness Nm/deg

Kf = Kf.*57.3;

Kr = 113; %Rear roll stiffness Nm/deg

Kr = Kr.*57.3;

L = 1.53; %Wheelbase

b = 0.732; %Distance from CG to front axle

rho = 1.225; %Air density

hf = 0.0508; %Front roll center height

hr = 0.071; %Rear roll center height 

hg = 0.2; %CG height

hl = hg - (((hr-hf)/L)*(L-b) + hf); %Distance from CG to roll axis 

Cl = 2.6; % Lift coefficient 

A = 1; %Reference area

t = 1.215; %track

g = 9.81; %acceleration due to gravity 
