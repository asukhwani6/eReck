function [energy] = calculateEnergyRegen(Fx, v, t, Parameters)

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

    FxRear = Fx(:,1) + Fx(:,2);
    FxFront = Fx(:,3) + Fx(:,4);

    motorSpeedRear = (v./r) .* nRear ;
    motorSpeedFront = (v./r) .* nFront ;
    motorSpeedFrontRPM = motorSpeedFront*9.549297;
    motorSpeedRearRPM = motorSpeedRear*9.549297;

    brakeTorqueFront = (FxFront .* r)./nFront;
    brakeTorqueRear = (FxRear .* r)./nRear;

    regenBrakeTorqueFront = min([brakeTorqueFront';frontRegen']);
    regenBrakeTorqueRear = min([brakeTorqueRear';rearRegen']);

    effFront = ones(length(v),1);
    effRear = ones(length(v),1);
    switch motorType
        case 'Emrax 208'
            for i = 1:length(v)
                effFront(i) = efficiencyEmrax208(motorSpeedFrontRPM(i), regenBrakeTorqueFront(i), graphDataEmrax208, overrideEfficiencyFront);
                effRear(i) = efficiencyEmrax208(motorSpeedRearRPM(i), regenBrakeTorqueRear(i), graphDataEmrax208, overrideEfficiencyRear);
            end
        case 'AMK A2370DD'
            for i = 1:length(v)
                effFront(i) = efficiencyAMK(motorSpeedFrontRPM(i), regenBrakeTorqueFront(i), graphDataAMKA2370DD, overrideEfficiencyFront);
                effRear(i) = efficiencyAMK(motorSpeedRearRPM(i), regenBrakeTorqueRear(i), graphDataAMKA2370DD, overrideEfficiencyRear);
            end
        otherwise
            disp('Parameters.motorType not recognized. Use "Emrax 208" or "AMK "')
    end

    regenForceFront = regenBrakeTorqueFront.*nFront./r;
    regenForceRear = regenBrakeTorqueRear.*nRear./r;

    PowerFront = regenForceFront.*v;
    PowerRear = regenForceRear.*v;

    PowerFront = PowerFront.*effFront;
    PowerRear = PowerRear.*effRear;

    energyFront = cumtrapz(t,PowerFront,1);
    energyRear = cumtrapz(t,PowerRear,1);
    energy = energyFront(end) + energyRear(end);
else
    energy = 0;
end

end