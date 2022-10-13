function [efficiency] = efficiencyEmrax208(rpm, torque, graphData, overrideEfficiency)

if overrideEfficiency > 0
    efficiency = overrideEfficiency;
else
    graphData.graphData;

    if (rpm > 6000)
        mappedRPM = 122;
    elseif (rpm <= 0)
        mappedRPM = 1;
    else
        mappedRPM = ceil(122*rpm/6000);
    end

    if (torque >= 160)
        mappedTorque = 74;
    else
        mappedTorque = 75 - ceil(74*torque/159);
    end

    if (torque <= 0)
        efficiency = 1;
    else
        if torque > 60
            hhhh= 1;
        end
        efficiency = graphData.graphData(mappedTorque, mappedRPM) / 100;
    end

end
end