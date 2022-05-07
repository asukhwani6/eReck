function [FxFront,FxRear] = powerLimited(v,Parameters)

% Get Used Vehicle Parameters:
% UPDATE VEHICLE PARAMETERS IN VEHICLE PARAMETER FILES

nRear = Parameters.nRear; % Powertrain rear gear reduction
nFront = Parameters.nFront; % Powertrain front gear reduction
TmRear = Parameters.TmRear; % Rear motor max torque
TmFront = Parameters.TmFront; % Front motor max torque
mRearTopSpeed = Parameters.mRearTopSpeed; % Torque drops to 0 when motor rpm exceeds this value
mFrontTopSpeed = Parameters.mFrontTopSpeed; % Torque drops to 0 when motor rpm exceeds this value
derateSpeedRatioFront = Parameters.derateSpeedRatioFront;
derateSpeedRatioRear = Parameters.derateSpeedRatioRear;
r = Parameters.r; % Tire radius
maxPower = Parameters.maxPower; % Rules required maximum power (80kW for 2022)

mVRear = (v/r) * nRear; % Rear Motor Speed [rad/s]
mVrpmRear = 9.549297*mVRear;
mVFront = (v/r) * nFront; % Front Motor Speed [rad/s]
mVrpmFront = 9.549297*mVFront;

derateFront = Parameters.derateFront(mVrpmFront,mFrontTopSpeed,derateSpeedRatioFront);
derateRear = Parameters.derateRear(mVrpmRear,mRearTopSpeed,derateSpeedRatioRear);

adjTmRear = TmRear*derateRear;
adjTmFront = TmFront*derateFront;

PowerTotal = adjTmRear*mVRear + adjTmFront*mVFront;
if PowerTotal > maxPower
    adjTmFront = adjTmFront*(maxPower/PowerTotal); % scale torques to reduce overall power based on ratio of torques
    adjTmRear = adjTmRear*(maxPower/PowerTotal); % scale torques to reduce overall power based on ratio of torques
end

FxRear = (adjTmRear.*nRear)./r;
FxFront = (adjTmFront.*nFront)./r;

end

%     effectiveMass = (mass + ((Im.*nRear.^2+Ip)./r.^2));
% 
%     Ax = (1./effectiveMass).*netF;

