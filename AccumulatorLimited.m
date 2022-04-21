%Returns the max power the accumulator can supply
function [PowerAvailable] = AccumulatorLimited(Power, Parameters)
    
cell = Parameters.cell ; %Cells in Series
IR = Parameters.IR; %Cell Internal Resistance
cellV = Parameters.cellV; %Cell Voltage
cellMaxI = Parameters.cellMaxI; %Max Cell Voltage

VoltageTemp = cellV*cell;
Voltage = realmax;
currReq = Power/VoltageTemp;

%Calculate true current req
while abs(Voltage - VoltageTemp) > 0.0001
      
    VoltageTemp = Voltage;
    
    currReq = Power/VoltageTemp;
    
    if currReq > cellMaxI
        currReq = cellMaxI;
    end        
    Voltage = cellV*cell - (currReq * IR * cell);   
       
end

PowerAvailable = currReq * Voltage;


end