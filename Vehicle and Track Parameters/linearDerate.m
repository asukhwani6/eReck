function derate = linearDerate(motorV,maxRPM,derateRatio)

if motorV < maxRPM*derateRatio
    derate = 1;
else
    derate = (maxRPM - motorV)/(maxRPM-(maxRPM*derateRatio));
end
if derate < 0
    derate = 0;
end
end

