%TODO: plot vehicle velocity vs distance

track = "track_1.csv";
vehicle_parameters;

%parametric here
for i = 1:1
    
    straight_parameters(1) = straight_parameters(1) - 10;
    cornering_parameters(1) = cornering_parameters(1) - 10;
    
    time(i) = runLapSim(track, straight_parameters, cornering_parameters);
    fprintf("For vehicle weight of %.1fkg, the lap time is: %.3fs\n",straight_parameters(1), time(i));
end