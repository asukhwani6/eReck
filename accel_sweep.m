vehicle_parameters;
vary_length = 20;
cd_range = linspace(0,5,vary_length);


for i = 1: vary_length
    straight_parameters(12) = cd_range(i); %Coeffcient of drag  
    [Time, ~] = acceleration(0, 75,straight_parameters);
    
    t(i) = Time(end);
end 

figure
plot(cd_range,t,'.');

%% Steady State Sweep
vary_length = 20;
cl_range = linspace(0,5,vary_length);


for i = 1: vary_length
    cornering_parameters(12) = cl_range(i); %Coeffcient of drag  
    [allow_v] = cornerFunc(cornering_parameters,100,10);
    [Time,~] = cornering(100,allow_v);
    
    t(i) = Time(end);
end 

figure
plot(cl_range,t,'-');