
%% surface plot of speed, current, torque
% SHAFT TORQUE VARIES MINIMALLY BETWEEN TEMPERATURE EXPERIMENTS. MAXIMUM
% DEVIATION IS 0.946 Nm

% POWER LOSS VARIES MINIMALLY BETWEEN TEMPERATURE EXPERIMENTS. MAXIMUM
% DEVIATION IS 0.33 kW

load('A2370DD_T80C.mat')
speedRPM = Speed(:,1);
currentARMS = Stator_Current_Line_RMS(1,:);
Shaft_Torque80 = Shaft_Torque;
surf(speedRPM,currentARMS,Shaft_Torque80')
Total_Loss80 = Total_Loss;
hold on

load('A2370DD_T100C.mat')
speedRPM = Speed(:,1);
currentARMS = Stator_Current_Line_RMS(1,:);
Shaft_Torque100 = Shaft_Torque;
surf(speedRPM,currentARMS,Shaft_Torque100')
Total_Loss100 = Total_Loss;

load('A2370DD_T120C.mat')
speedRPM = Speed(:,1);
currentARMS = Stator_Current_Line_RMS(1,:);
Shaft_Torque120 = Shaft_Torque;
surf(speedRPM,currentARMS,Shaft_Torque120')
Total_Loss120 = Total_Loss;

xlabel('Motor Speed (RPM)')
ylabel('RMS Current (A)')
zlabel('Shaft Torque')

% The diagram is based on a DC bus voltage of 600 VDC.
% If a lower DC bus voltage is available, not all calculated operating points can be approached.
% Which working points can still be reached, can be seen in the worksheets with the voltage that is
% set depending on the current and the speed.
% Example:
% With a DC bus voltage of 500 VDC (500 VDC / √2), a maximum of 354 VAC motor voltage is
% available. Accordingly, the maximum torque generating motor current up to 13,000 rpm is
% available (example a). At a maximum speed of 20,000 rpm, the torque generating motor current
% is reduced to 10.5 A (example b).

%% DC VOLTAGE DROP TORQUE ADJUSTMENT ANALYSIS
load('A2370DD_T80C.mat')


cellIR = 0.01; % Ohms
% cellIR = 0.002; % Ohms
segP = 1;
segS = 23;
segN = 6;
packP = segP;
packS = segS*segN;
packIR = (packS*cellIR/packP); % Ohms

maxCellV = 4.2;
minCellV = 3.6;
MaxOCV = maxCellV*packS; % (V)
MinOCV = minCellV*packS; % (V)

% VOLTAGE DROP FIT TO MELASTA HT05/HT06 CELLS
voltageDrop = Stator_Current_Phase_RMS*packIR;
p1 =       1.025;
p2 =      -1.301;
p3 =      0.8786;
p4 =       3.605;

% X = STATE OF CHARGE, OUT = OCV
OCV = @(x) p1*x.^3 + p2*x.^2 + p3.*x + p4;

% SOC = linspace(0,1,20);
% packVoltage = packS*OCV(SOC);

packVoltage = linspace(0,600,50);
[r,c] = size(voltageDrop);
packAchievableTorque = zeros(r,c);
voltageAdjustedTorque = [];
voltageAdjustedMaxTorque = [];
Legend = {};
speedRPM = Speed(:,1);
for i = 1:length(packVoltage)
    mask = Voltage_Line_Peak < (packVoltage(i)-voltageDrop); % filters for achievable motor conditions
    packAchievableTorque(mask) = Shaft_Torque(mask);
    voltageAdjustedTorque = cat(3,voltageAdjustedTorque,packAchievableTorque);
    maxTorque = max(packAchievableTorque,[],2);
    voltageAdjustedMaxTorque = [voltageAdjustedMaxTorque,maxTorque];
end

voltageLimitationFit = fit(packVoltage',speedRPM',voltageAdjustedMaxTorque,'linearInterp');

figure
surf(packVoltage,speedRPM,voltageAdjustedMaxTorque)
legend(Legend)
title('Torque vs RPM, Variable SOC, Voltage Sag Model',['Assuming LCO Chemistry, ',num2str(packS),'s',num2str(packP),'p, Cell IR = ',num2str(cellIR)])
xlabel('Pack Voltage (V)')
ylabel('Rotational Speed (RPM)')
zlabel('Torque (Nm)')

%% Efficiency Analysis
speedRPM = Speed(:,1);
currentARMS = Stator_Current_Line_RMS(1,:);

% Calculate power from power factor: https://www.engineeringtoolbox.com/power-factor-electrical-motor-d_654.html
% ElectricalRealPower = sqrt(3).*Stator_Current_Phase_RMS.*Voltage_Line_RMS;
MechanicalPower = Shaft_Torque.*Speed.*0.10472;

EfficiencyMechanical = MechanicalPower./(MechanicalPower + Total_Loss);
EfficiencyMechanical(EfficiencyMechanical > 1) = 0;

contour(speedRPM,currentARMS, EfficiencyMechanical',[0.7,.8,.84,.86,.88,.9],'LineWidth',1.2,'ShowText','on')

% convert to torque and speed axes:
[r,c] = size(Shaft_Torque);
for i = 1:r
    for j = 1:c
    sp((i-1)*(c)+j) = speedRPM(i);
    cu((i-1)*(c)+j) = currentARMS(j);
    to((i-1)*(c)+j) = Shaft_Torque(i,j);
    ef((i-1)*(c)+j) = EfficiencyMechanical(i,j);
    end
end
ef(isnan(ef)) = 0;
efficiencyFit = fit([sp',cu'],ef','linearInterp');
currentFit = fit([sp',to'],cu','linearinterp');

torqueNm = linspace(0,max(max(Shaft_Torque)),100);

speedMatRPM = repmat(speedRPM,1,length(torqueNm));
torqueMatNm = repmat(torqueNm,length(speedRPM),1);

efficiencyMap = efficiencyFit(speedMatRPM,currentFit(speedMatRPM,torqueMatNm));

figure
surf(torqueNm,speedRPM,efficiencyMap)
xlabel('Torque (Nm)')
ylabel('Velocity (RPM)')
zlabel('Efficiency')
title('AMK Motor Efficiency vs Torque and RPM')