function motor = Motor_Jacket_Init(motor)

motor.CoolingJacketFlowArea = pi*(motor.CoolingJacketHalfCircleDiameter^2)/8; % m^3
motor.CoolingJacketFlowVolume = motor.CoolingJacketFlowArea*motor.CoolingJacketLength; % m^3
motor.CoolingJacketHydraulicDiameter = 4*motor.CoolingJacketFlowArea/((1+pi)*motor.CoolingJacketHalfCircleDiameter);
motor.CoolingJacketCooledArea = motor.CoolingJacketLength*motor.CoolingJacketHalfCircleDiameter; % m^2

% Need to reduce Nusselt number in motor jacket by ratio of viscous
% friction perimeter to cooled perimeter. Adjust dittus boelter A
% coefficient in Nu = a*(Re^b)*(Pr^c)

dittusBoelterA = 0.023;
motor.DittusBoelterAadj = dittusBoelterA*(motor.CoolingJacketHalfCircleDiameter/((1+pi)*motor.CoolingJacketHalfCircleDiameter));

end

