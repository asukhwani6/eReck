%Script: acceleration  

%This script models the acceleration performance of an electric vehicle. The
%output will be a graphs of acceleration, velocity, tractive force,and 
%displacement with time. Many of the formulas are pulled from Fundamentals
%of Vehicle Dynamics by Thomas Gillespie 

%The acceleration performance is calculated using Newton's Second Law
%for both the traction-limited and power-limited acceleration regimes.
%The midpoint method was chosen for its compromise of increased accuracy
%over Euler's method while being slightly more difficult to implement. A
%more accurate Runge-Kutta method can be used in the future to improve the
%model.

%Author: Marc Maquiling,maquilingm@gatech.edu,646-745-4078
%Date: 12/28/21

%----------------------------------------------------------------------

%Vehicle Parameters (all units SI)

Average_Acceleration = [];

Max_Acceleration = [];

Average_Velocity = [];

Max_Velocity = [];

Energy = [];




var = linspace(150,200,30);
for i = var
mass = i;

L = 1.53; %wheelbase

h = 0.35; %CG height

b = 0.732; %distance from CG to rear axle

%mu = 1.8; %longitudinal tire coefficient of friction

mu = 1.5;

Tm = 140; %motor torque

N = 4.44; %gear ratio

Im = 0.0441 + 0.02; %motor + motor output shaft rotational inertia 

Ip = 0.144; %powertrain rotational inerta (2x wheels + diff)

r = 0.203; %tire radius

rho = 1.225; %air density

Cd = 1.3; %drag coefficient

A = 1.334; %frontal area

Crr = 0.028; %rolling resistance coefficient

eta = 0.8; %powertrain efficiency 

save("vehicle");

%-----------------------------------------------------------------%

vi = zeros(1,length(mass));
V = [vi];

%Calculating initial tractive force and accelerations
[Ft,At] = tractionLimited(vi);
[Fp,Ap] = powerLimited(vi);

%Determining which of the two to start the vectors with
if Ft <= Fp
    Afinal = [At'];
    tractiveForce = [Ft'];
    Ax = At;
elseif Ft > Fp
    Afinal = [Ap'];
    tractiveForce = [Fp'];
    Ax = At;
end
 
%Time step size
h = 0.1;

tractionTime = 0;
powerTime = 0;
Time = [0];

%Midpoint method for loop
for t = 0+h:h:10
    %Calculates tractive force and acceleration for each at the beginning
    %of the loop
    [Ft,At] = tractionLimited(vi);
    
    [Fp,Ap] = powerLimited(vi);
    
    %compares tractive forces. If traction limited is smaller, midpoint
    %method is used with the acceleration due to traction limited tractive
    %force. Vice versa if power limited is smaller. Also calculates and
    %stores amount of time spent in each regime
    if Ft <= Fp
        [Fi,Ai] = tractionLimited(vi);
        midV = vi + (h./2).*Ai;
        midT = t + (h./2);
        [Fmid,midslope] = tractionLimited(midV);
        vo = vi + h.*midslope;
        Ax = midslope;
        tractionTime = h + tractionTime;
    elseif Fp < Ft
        [Fi,Ai] = powerLimited(vi);
        midV = vi + (h./2).*Ai;
        midT = t + (h./2);
        [Fmid,midslope] = powerLimited(midV);
        vo = vi + h.*midslope;
        Ax = midslope;
        powerTime = h + powerTime;

    end
  
    %storing values calculated by midpoint method
    Afinal = [Afinal Ax']; 
    
    V = vertcat(V,vo);
    
    vi = vo;
    
    Time = [Time t];
    
    tractiveForce = [tractiveForce Fmid'];
   
end

%plotting

% %acceleration is normalized by g 
% figure(10);
% plot(Time, Afinal./9.81);
% xlabel("Time (s)");
% ylabel("Acceleration (g)");
% title("Acceleration vs Time");
% 
% % 
% %velocity is converted from m/s to mph
% figure(11);
% plot(Time,V.*2.237);
% xlabel("Time (s)");
% ylabel("Velocity (mph)");
% title("Velocity vs Time");
% 
% %tractive force
% figure(12)
% plot(Time, tractiveForce);
% xlabel("Time (s)");
% ylabel("Tractive Force (N)");
% title("Tractive Force vs Time");
% 
% %calculating and plotting displacement 
% figure(13)
% displacement = cumtrapz(Time,V);
% plot(Time,displacement);
% xlabel("Time (s)");
% ylabel("Displacement (m)");
% % 
% % % %time spent in each regime
% % tractionTime
% % powerTime
% % % 
% figure(14)
% plot(displacement,V.*2.237);
% xlabel("Displacement (m)");
% ylabel("Velocity (mph)");


avgAccel = mean(Afinal./9.81);

maxAccel = max(Afinal)./9.81;

avgVel = mean(V.*2.237);

maxVel = max(V.*2.237);

avgTract = mean(tractiveForce);

energy = max(cumtrapz(((tractiveForce.*r)./N).*(V'./r)));

Average_Acceleration = [Average_Acceleration avgAccel];

Max_Acceleration = [Max_Acceleration maxAccel];

Average_Velocity = [Average_Velocity avgVel];

Max_Velocity = [Max_Velocity maxVel];

Energy = [Energy energy'];

%energy = max(cumtrapz(power));

% figure(34)
% plot(Time,energy);
% 
% figure(35)
% plot(Time, power);

end



figure(20);
plot(var,Average_Acceleration);
xlabel("Mass (kg)");
ylabel("Average Acceleration (g's)");

figure(21);
plot(var,Max_Acceleration);
xlabel("Mass (kg)");
ylabel("Max Acceleration (g's)");

figure(22);
plot(var,Average_Velocity);
xlabel("Mass (kg)");
ylabel("Average Velocity (mph)");

figure(23);
plot(var,Max_Velocity);
xlabel("Mass (kg)");
ylabel("Max Velocity (mph)");


figure(24);
plot(var,Energy.*0.0000002778);
xlabel("Mass (kg)");
ylabel("Energy Usage (kWh)");





