function [FxFront,FxRear] = powerLimited(v,Parameters)

% Get Used Vehicle Parameters:
% UPDATE VEHICLE PARAMETERS IN VEHICLE PARAMETER FILES

nRear = Parameters.nRear; % Powertrain rear gear reduction
nFront = Parameters.nFront; % Powertrain front gear reduction
TmRear = Parameters.TmRear; % Rear motor max torque
TmFront = Parameters.TmFront; % Front motor max torque
r = Parameters.r; % Tire radius
eta = Parameters.eta; % Powertrain Efficiency
Rw = Parameters.Rw; %Wheel size [m]

adjTmRear = 140 -2.*10.^-5.*(v).^5+0.0014.*v.^4-0.0372.*v.^3+0.4109.*v.^2-1.7775.*v; % Rear Torque(V)
adjTmFront = 140 -2.*10.^-5.*(v).^5+0.0014.*v.^4-0.0372.*v.^3+0.4109.*v.^2-1.7775.*v; %Front Torque(V)
%^This function comes from the Emrax 208 torque vs RPM data. Data points
%from the spec sheet were put into an Excel sheet and then I fitted a curve
%to them.


mV = v/(Rw) * nRear; %Motor Speed [rad/s]
PreqRear = mV*min([TmRear adjTmRear]);
PreqFront = mV*min([TmFront adjTmFront]);

Bat_P_rear = AccumulatorLimited(PreqRear, Parameters);
Bat_T_rear = Bat_P_rear/mV;

Bat_P_front = AccumulatorLimited(PreqFront, Parameters);
Bat_T_front = Bat_P_front/mV;

TmRear = min([adjTmRear TmRear Bat_T_rear]);
TmFront = min([adjTmFront TmFront Bat_T_front]);

FxRear = (TmRear.*nRear.*eta)./r;
FxFront = (TmFront.*nFront.*eta)./r;

end

%     effectiveMass = (mass + ((Im.*nRear.^2+Ip)./r.^2));
% 
%     Ax = (1./effectiveMass).*netF;

