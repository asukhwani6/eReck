function [T, elecPower, eff, q] = calculateEnergy(Fx, v, t, Parameters)

nRear = Parameters.nRear; %Rear gear ratio
nFront = Parameters.nFront; %Front gear ratio
graphDataEmrax208 = Parameters.graphDataEmrax208; %efficiency map of Emrax 208 motor
graphDataAMKA2370DD = Parameters.graphDataAMKA2370DD; %efficiency map of AMK motor
r = Parameters.r; %tire radius
overrideEfficiencyFront = Parameters.overrideEfficiencyFront;
overrideEfficiencyRear = Parameters.overrideEfficiencyRear;
motorType = Parameters.motorType;

if ~isempty(t)

    powerMech = Fx.*v';

    motorSpeedFrontRPM = (v./r) .* nFront *9.549297; %Calculate motor speed and convert to RPM
    motorSpeedRearRPM = (v./r) .* nRear *9.549297; %Calculate motor speed and convert to RPM

    T = [(Fx(:,[1,2]).*r)./nRear, (Fx(:,[3,4]).*r)./nFront];

    eff = ones(length(v),4);

    switch motorType
        case 'Emrax 208'
            for i = 1:length(v)
                for j = 1
                    eff(i,j) = efficiencyEmrax208(motorSpeedRearRPM(i), T(i,j) + T(i,j+1), graphDataEmrax208, overrideEfficiencyRear);
                    eff(i,j+1) = eff(i,j);
                end
                for j = 3
                    eff(i,j) = efficiencyEmrax208(motorSpeedRearRPM(i), T(i,j) + T(i,j+1), graphDataEmrax208, overrideEfficiencyRear);
                    eff(i,j+1) = eff(i,j);
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
            disp('Parameters.motorType not recognized. Use "Emrax 208" or "AMK A2370DD"')
    end

    elecPower = [powerMech(:,[1,2])./eff(:,[1,2]), powerMech(:,[3,4])./eff(:,[3,4])];
    q = elecPower - powerMech;
else
    T = [];
    elecPower = [];
    eff = [];
    q = [];
end

end