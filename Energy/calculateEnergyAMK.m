function [energy] = calculateEnergyAMK(Fx, v, t, Parameters)

nRear = Parameters.nRear; %Rear gear ratio
nFront = Parameters.nFront; %Front gear ratio
graphDataAMK = Parameters.graphDataAMK; %efficiency map of motor
r = Parameters.r; %tire radius
overrideEfficiencyFront = Parameters.overrideEfficiencyFront;
overrideEfficiencyRear = Parameters.overrideEfficiencyRear;

if ~isempty(t)
    
    FxRear = Fx(:,1) + Fx(:,2);
    FxFront = Fx(:,3) + Fx(:,4);
    
    PowerFront = FxFront .* v';
    PowerRear = FxRear .* v';
    
    motorSpeedRear = (v./r) .* nRear ;
    motorSpeedFront = (v./r) .* nFront ;
    
    reqTorqueFront = (FxFront .* r)./nFront;
    reqTorqueRear = (FxRear .* r)./nRear;
    
    effFront = ones(length(v),1);
    effRear = ones(length(v),1);
    
    for i = 1:length(v)       
        effFront(i) = efficiencyAMK(motorSpeedFront(i), reqTorqueFront(i), graphDataAMK, overrideEfficiencyFront);
        effRear(i) = efficiencyAMK(motorSpeedRear(i), reqTorqueRear(i), graphDataAMK, overrideEfficiencyRear);
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