function motor = motorJacketInit(motor)

motor.CoolingJacketFlowVolume = motor.CoolingJacketFlowArea*motor.CoolingJacketLength; % m^3

% Need to reduce Nusselt number in motor jacket by ratio of viscous
% friction perimeter to cooled perimeter. Adjust dittus boelter A
% coefficient in Nu = a*(Re^b)*(Pr^c)

dittusBoelterA = 0.023;
motor.DittusBoelterAadj = dittusBoelterA*(motor.CooledPerimeter/motor.ViscousPerimeter);

end

