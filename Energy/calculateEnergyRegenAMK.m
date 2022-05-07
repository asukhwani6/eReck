function [energy] = calculateEnergyRegenAMK(Fx, v, t, Parameters)

nRear = Parameters.nRear; %Rear gear ratio
nFront = Parameters.nFront; %Front gear ratio
graphDataAMK = Parameters.graphDataAMK; %efficiency map of motor
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
    
    brakeTorqueFront = (FxFront .* r)./nFront;
    brakeTorqueRear = (FxRear .* r)./nRear;
    
    regenBrakeTorqueFront = min([brakeTorqueFront';frontRegen']);
    regenBrakeTorqueRear = min([brakeTorqueRear';rearRegen']);

    effFront = ones(length(v),1);
    effRear = ones(length(v),1);
    
    for i = 1:length(v)       
        effFront(i) = efficiencyAMK(motorSpeedFront(i), regenBrakeTorqueFront(i), graphDataAMK, overrideEfficiencyFront);
        effRear(i) = efficiencyAMK(motorSpeedRear(i), regenBrakeTorqueRear(i), graphDataAMK, overrideEfficiencyRear);
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