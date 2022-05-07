function [energy] = calculateEnergy(Fx, v, t, Parameters)

nRear = Parameters.nRear; %Rear gear ratio
nFront = Parameters.nFront; %Front gear ratio
graphDataEmrax208 = Parameters.graphDataEmrax208; %efficiency map of Emrax 208 motor
graphDataAMKA2370DD = Parameters.graphDataAMKA2370DD; %efficiency map of AMK motor
r = Parameters.r; %tire radius
overrideEfficiencyFront = Parameters.overrideEfficiencyFront;
overrideEfficiencyRear = Parameters.overrideEfficiencyRear;
motorType = Parameters.motorType;

if ~isempty(t)
    
    FxRear = Fx(:,1) + Fx(:,2);
    FxFront = Fx(:,3) + Fx(:,4);
    
    PowerFront = FxFront .* v';
    PowerRear = FxRear .* v';
    
    motorSpeedRear = (v./r) .* nRear ;
    motorSpeedFront = (v./r) .* nFront ;
    motorSpeedFrontRPM = motorSpeedFront*9.549297;
    motorSpeedRearRPM = motorSpeedRear*9.549297;
    
    reqTorqueFront = (FxFront .* r)./nFront;
    reqTorqueRear = (FxRear .* r)./nRear;
    
    effFront = ones(length(v),1);
    effRear = ones(length(v),1);
    
    switch motorType
        case 'Emrax 208'
            for i = 1:length(v)
                effFront(i) = efficiencyEmrax208(motorSpeedFrontRPM(i), reqTorqueFront(i), graphDataEmrax208, overrideEfficiencyFront);
                effRear(i) = efficiencyEmrax208(motorSpeedRearRPM(i), reqTorqueRear(i), graphDataEmrax208, overrideEfficiencyRear);
            end
        case 'AMK A2370DD'
            for i = 1:length(v)
                effFront(i) = efficiencyAMK(motorSpeedFrontRPM(i), reqTorqueFront(i), graphDataAMKA2370DD, overrideEfficiencyFront);
                effRear(i) = efficiencyAMK(motorSpeedRearRPM(i), reqTorqueRear(i), graphDataAMKA2370DD, overrideEfficiencyRear);
            end
        otherwise
            disp('Parameters.motorType not recognized. Use "Emrax 208" or "AMK A2370DD"')
    end
    
    PowerFront = PowerFront./effFront;
    PowerRear = PowerRear./effRear;
    
    energyFront = cumtrapz(t,PowerFront,1);
    energyRear = cumtrapz(t,PowerRear,1);
    energy = energyFront(end) + energyRear(end);
else
    energy = 0;
end

end