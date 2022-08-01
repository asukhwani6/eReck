function [SOL,X,Y] = HT06AccumTherm(S,t_initial,t_final,T0_Acc,T0_Ambient)
%Electrical Resistances
R_t = 0.00009; %ohms TUNED VARIABLE
% R_c = 0.0018; %ohms
%Specific Heat Capacities
cAl = 904; %J/kg*K
cSt = 500; %J/kg*K
cCell = 900; %J/kg*K TUNED VARIABLE
cCu = 387; %J/kg*K
%Mass Definitions
mCell = 0.325; %kg
mFin = 0.0247; %kg
mCover = 1.5; %kg
mCoverAdj = mCover/84; %kg/cell
mContainer = 4; %kg
mContainerAdj = mContainer/84; %kg/cell
mInterconnect = 0.0034; %kg
mInterconnectBolt = 0.00092; %kg
mInterconnectNut = 0.00058; %kg
%Tab Thermal Resistance
tabLength = 0.03; %m
tabThickness = 0.0002; %m
tabWidth = 0.025; %m
tabArea = tabWidth*tabThickness; %m^2
kCopper = 386; %W/m*K
R_tc = tabLength/(2*tabArea*kCopper); %K/W
%Density of Copper
pCu = 8960; %kg/m^3
% Thermal Masses
cellTabVolume = tabLength*tabArea;
cellTabThermalMass = pCu*cellTabVolume*cCu;
C_t = cAl*mInterconnect + 2*cSt*(mInterconnectBolt + mInterconnectNut) + cellTabThermalMass; %J/K
C_c = mFin*cAl + mCell*cCell; %J/K
C_b = (mContainerAdj+mCoverAdj)*cAl; %J/K
%Container Thermal Resistance
interfacialResistance = 0.01; %m^2*K/W LOW CONFIDENCE
contactArea = 0.002; %m^2
R_cb = interfacialResistance/contactArea; %K/W
%Convection Thermal Resistance
baseplateArea = 0.25; %m^2
convectionArea = baseplateArea/84; %m^2
% R_ba = 1/(convectiveCoefficient*convectionArea);
%Initial Temperature
T_a = T0_Ambient; %C
T_b = T0_Acc; %C
T_c = T0_Acc; %C
T_t = T0_Acc; %C

% Initialize SOC to be used for entropic energy generation term
SOC = 1;
%% Generate entropic heat losses fit
% Data from Figure 9 of https://www.mdpi.com/2313-0105/6/3/40

dOCVdT = [-0.15, -0.025, 0.025, 0.175, .175, 0.15, 0.04, 0.03, 0.03, 0, -0.1]/1000;
SOC = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];

[xData, yData] = prepareCurveData( SOC, dOCVdT );
% Set up fittype and options.
ft = 'linearinterp';
% Fit model to data.
[dVdTvsSOC, ~] = fit(xData, yData, ft, 'Normalize', 'on' );

%% Load internal resistance vs temperature fit
load('IRvsCellTempFitMichiganEndurance2022.mat','IRvsCellTemp');

%% Initialize interpolated data used in model
current = S.dc_bus_current;
% create vehicle speed data field
speed = S.motor_speed;
% Convert motor speed to vehicle speed in m/s
speed(:,2) = -speed(:,2)*0.10472*0.2032/4.4444;

% data uniqueness
for i = 1:length(current(:,1))
    current(i,1) = current(i,1) + i/100000000;
end
for i = 1:length(speed(:,1))
    speed(i,1) = speed(i,1) + i/100000000;
end

chargeUsed = cumtrapz(current(:,1),current(:,2))*0.000277778;
SOC = (18-chargeUsed)./18;
dVdT = dVdTvsSOC(SOC);

    function dTdt = myode(t,T,A,current,speed,dVdT,R_t,C_t,C_c,T_a,C_b,convectionArea,IRvsCellTemp)
        instCurr = interp1(current(:,1),current(:,2),t);
        instSpeed = interp1(speed(:,1),speed(:,2),t);
        instdVdT = interp1(current(:,1),dVdT,t);
        instRc = IRvsCellTemp(T(2))/1000;
        if t > 1000
            hhhh = 1;
        end
        if isnan(instSpeed)
            instSpeed = 0;
        end
        if instSpeed < 2
            instH = 10;
        else
%             ANSON/FEDERICO FIT
%             instH = 0.0752*instSpeed^2 + 0.813*instSpeed + 30;
%             CLAIRE FIT:
            instH = -0.02508.*instSpeed.^2 + 4.137.*instSpeed + 4.207;
            instH = instH/2;
        end

% UNCOMMENT FOR ADIABATIC BASEPLATE BOUNDARY CONDITION
% instH = 0.001;

        instR_ba = 1/(convectionArea*instH);
%       B = [R_t*instCurr^2/C_t;instRc*instCurr^2/C_c;(T_a-T(3))/(instR_ba*C_b)];
        B = [R_t*instCurr^2/C_t;(instRc*instCurr^2 + instCurr*(T(2) + 273.15)*instdVdT)/C_c;(T_a-T(3))/(instR_ba*C_b)];
        dTdt = A*T + B;
    end

A = [-1/(R_tc*C_t), 1/(R_tc*C_t), 0
    1/(R_tc*C_c), -(1/(R_tc*C_c) + 1/(R_cb*C_c)), 1/(R_cb*C_c)
    0, 1/(R_cb*C_b), -(1/(R_cb*C_b))];

T0 = [T_t;T_c;T_b];
t_span = [t_initial,t_final];
options = odeset('RelTol',1e-10,'AbsTol', 1e-12);
SOL = ode45(@(t,T) myode(t,T,A,current,speed,dVdT,R_t,C_t,C_c,T_a,C_b,convectionArea,IRvsCellTemp),t_span,T0,options);
X = SOL.x;
Y = SOL.y;
hold on
% plot(X,Y(1,:))
% plot(X,Y(2,:))
% plot(X,Y(3,:))
xlim(t_span)
end