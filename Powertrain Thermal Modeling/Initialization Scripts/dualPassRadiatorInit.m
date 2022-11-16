%% Radiator
function radiator = Dual_Pass_Radiator_Init(radiator)

radiator.ShroudWidth = radiator.CoreWidth + 0.1; % m
radiator.ShroudHeight = radiator.CoreHeight + 0.075; % m
radiator.CoreArea = radiator.CoreWidth * radiator.CoreHeight; % m^2
radiator.ShroudArea = radiator.ShroudWidth * radiator.ShroudHeight; % m^2
radiator.finRowNumber = radiator.CoreHeight / (radiator.finHeight + radiator.waterChannelOuterHeight);
radiator.finColumnNumber = radiator.CoreWidth / radiator.finDepth;
radiator.airChannelNumber = radiator.finRowNumber * radiator.finColumnNumber;
radiator.coldFluidSA = radiator.airChannelNumber * (2 * radiator.finDepth * radiator.finWidth + 2 * radiator.finHeight * radiator.finWidth); % m ^ 2
radiator.airChannelHydraulicDiameter = (2 * radiator.finDepth * radiator.finHeight / (radiator.finDepth + radiator.finHeight)); % m

% Water Channels
radiator.waterChannelInnerHeight = radiator.waterChannelOuterHeight - 0.0006;
radiator.waterChannelInnerWidth = radiator.finWidth - 0.002; % m
radiator.waterChannelRowNumber = radiator.finRowNumber - 1; 
radiator.waterChannelArea = radiator.waterChannelInnerHeight * radiator.waterChannelInnerWidth; % m ^ 2
radiator.waterChannelAreaTotal = radiator.waterChannelArea*radiator.waterChannelRowNumber;
radiator.waterChannelHydraulicDiameter = 4 * radiator.waterChannelArea / (2*radiator.waterChannelInnerHeight + 2*radiator.waterChannelInnerWidth); % m
radiator.waterChannelLength = radiator.CoreWidth + 0.01; % m Add 10mm because of stick through on welded panels
radiator.waterChannelVolumeTotal = radiator.waterChannelArea * radiator.waterChannelLength * radiator.waterChannelRowNumber; % m ^ 3
radiator.waterChannelSA = radiator.waterChannelLength * 2 * (radiator.waterChannelInnerHeight + radiator.waterChannelInnerWidth); % m ^ 2
radiator.waterChannelSATotal = radiator.waterChannelSA * radiator.waterChannelRowNumber; % m ^ 2

% Misc
radiator.waterVolumem3 = radiator.waterVolumeL/1000; % m^3
radiator.effectiveCrossSection = radiator.waterVolumem3/radiator.CoreHeight;

%% NEEDS TO BE UPDATED MANUALLY EACH RUN BASED ON MASS FLOW RATE AND REYNOLDS NUMBER
waterKinematicViscosity40C = 0.0000010533;
radiator.waterChannelVelTesting = 6 * 1.66667e-5 / (radiator.waterChannelAreaTotal/2); % m/s
radiator.radReGuessTesting = radiator.waterChannelVelTesting * radiator.waterChannelHydraulicDiameter ./ waterKinematicViscosity40C;% JUST GUESS
radiator.radFrictionFactor = 64/radiator.radReGuessTesting; % CHECK AGAIN
radiator.KSharpEntrance = 0.8;
radiator.KwaterChannelExit = 0.8;
radiator.KSlightlyRoundedEntrance = 0.2;

radiator.Ktot = 2*((radiator.KSharpEntrance + radiator.KwaterChannelExit) + radiator.KSlightlyRoundedEntrance * 2);
radiator.leqMinor = (radiator.Ktot * radiator.waterChannelHydraulicDiameter ./ radiator.radFrictionFactor);
