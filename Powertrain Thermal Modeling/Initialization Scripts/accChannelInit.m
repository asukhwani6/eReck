function accChannel = Acc_Channel_Init(accChannel)

accChannel.CooledPerimeter = accChannel.Num * (accChannel.Width+2*accChannel.Height);
accChannel.ViscousPerimeter = 2*accChannel.Num*(accChannel.Width + accChannel.Height);
accChannel.FlowArea = accChannel.Num*accChannel.Width*accChannel.Height;
accChannel.HydraulicDiameter = 4*accChannel.FlowArea/(2*accChannel.ViscousPerimeter);

% Dittus Boelter A Constant = needs to be adjusted to account for ratio of
% cooled area to hydraulic area
dittusBoelterA = 0.023;
accChannel.DittusBoelterAadj = dittusBoelterA*accChannel.CooledPerimeter/accChannel.ViscousPerimeter;

end