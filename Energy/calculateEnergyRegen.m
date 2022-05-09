function [T, elecPower, eff, q] = calculateEnergyRegen(Fx, v, t, Parameters)

nRear = Parameters.nRear; %Rear gear ratio
nFront = Parameters.nFront; %Front gear ratio
graphDataEmrax208 = Parameters.graphDataEmrax208; %efficiency map of Emrax 208 motor
graphDataAMKA2370DD = Parameters.graphDataAMKA2370DD; %efficiency map of AMK motor
r = Parameters.r; %tire radius
frontRegen = ones(length(v),1)*Parameters.frontRegen;
rearRegen = ones(length(v),1)*Parameters.rearRegen;
overrideEfficiencyFront = Parameters.overrideEfficiencyFront;
overrideEfficiencyRear = Parameters.overrideEfficiencyRear;
motorType = Parameters.motorType;

if ~isempty(t)

    motorSpeedFrontRPM = (v./r) .* nFront *9.549297; %Calculate motor speed and convert to RPM
    motorSpeedRearRPM = (v./r) .* nRear *9.549297; %Calculate motor speed and convert to RPM

    brakeTorque = [Fx(:,[1,2]).*r./nRear , Fx(:,[3,4]).*r./nFront];

    regenTorqueRearIn = min([brakeTorque(:,1)'; rearRegen'])';
    regenTorqueRearOut = min([brakeTorque(:,2)'; rearRegen'])';
    regenTorqueFrontIn = min([brakeTorque(:,3)'; frontRegen'])';
    regenTorqueFrontOut = min([brakeTorque(:,4)'; frontRegen'])';

    T = [regenTorqueRearIn, regenTorqueRearOut, regenTorqueFrontIn, regenTorqueFrontOut];

    eff = ones(length(v),4);

    switch motorType
        case 'Emrax 208'
            for i = 1:length(v)
                for j = 1:2
                    eff(i,j) = efficiencyEmrax208(motorSpeedRearRPM(i), T(i,j), graphDataEmrax208, overrideEfficiencyRear);
                end
                for j = 3:4
                    eff(i,j) = efficiencyEmrax208(motorSpeedFrontRPM(i), T(i,j), graphDataEmrax208, overrideEfficiencyFront);
                end
            end
        case 'AMK A2370DD'
            for i = 1:length(v)
                 for j = 1:2
                    eff(i,j) = efficiencyAMK(motorSpeedRearRPM(i), T(i,j), graphDataAMKA2370DD, overrideEfficiencyRear);
                end
                for j = 3:4
                    eff(i,j) = efficiencyAMK(motorSpeedFrontRPM(i), T(i,j), graphDataAMKA2370DD, overrideEfficiencyFront);
                end
            end
        otherwise
            disp('Parameters.motorType not recognized. Use "Emrax 208" or "AMK "')
    end

    T = -T;
    regenForce = [T(:,[1,2]).*nFront./r , T(:,[3,4]).*nFront./r];

    powerMech = regenForce.*v';
    elecPower = powerMech.*eff;
    q = elecPower - powerMech;
else
    T = [];
    elecPower = [];
    eff = [];
    q = [];

end

end