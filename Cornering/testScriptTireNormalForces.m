%% steady state cornering (skidpad)
HT06_vehicle_parameters;
t = 5;
r = 8.5; % meters
C = 2*pi*r;
v = C/t;

FzRiVec = [];
FzRoVec = [];
FzFiVec = [];
FzFoVec = [];

Kr = linspace(1000,15000);
for i = 1:length(Kr)
Parameters.Kr = Kr(i);
Ax = 0;
Ay = (v^2)/r;

[FzRi, FzRo, FzFi, FzFo, phi] = tireNormalForces(Ax,Ay,v,r,Parameters);

FzRiVec = [FzRiVec, FzRi];
FzRoVec = [FzRoVec, FzRo];
FzFiVec = [FzFiVec, FzFi];
FzFoVec = [FzFoVec, FzFo];
end

%% plot all forces
hold on
plot(Kr,FzRoVec)
plot(Kr,FzRiVec)
plot(Kr,FzFoVec)
plot(Kr,FzFiVec)
legend({'Rear Inside Normal Load','Rear Outside Normal Load','Front Inside Normal Load','Front Outside Normal Load'})
xlabel('Rear Roll Stiffness (m)')
ylabel('Normal Force (N)')
title('Weight Transfer vs CG Height assuming 5 second skidpad time at 8.5 meter radius')

%% plot weight transfer
figure
hold on
plot(Kr,FzRoVec-FzRiVec)
plot(Kr,FzFoVec-FzFiVec)
legend({'Rear Weight Transfer','Front Weight Transfer'})
xlabel('Rear Roll Stiffness (Nm/rad)')
ylabel('Normal Force (N)')
title('Weight Transfer vs Rear Roll Stiffness assuming 5 second skidpad time at 8.5 meter radius')