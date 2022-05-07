function motorEfficiency = efficiencyAMK(rpm, torque, graphDataAMK, overrideEfficiency)
efficiencyGraph = graphDataAMK.efficiencyFit;
currentGraph = graphDataAMK.currentFit;

% fits generated from data analysis of published AMK A2370DD motor data: 
if overrideEfficiency ~= 0
    motorEfficiency = overrideEfficiency;
else
    motorEfficiency = efficiencyGraph(rpm,currentGraph(rpm,torque));
    % HARD CODED TO PREVENT ERRORS IF INSTANTANEOUS MOTOR SPEED/TORQUE
    % COMMAND EXCEEDS PHYSICAL LIMITATIONS OF MOTOR
    if isnan(motorEfficiency)
        motorEfficiency = 0.8;
    end
end