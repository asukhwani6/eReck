%plotting

%acceleration is normalized by g 
figure(10);
plot(Time, Afinal./9.81);
xlabel("Time (s)");
ylabel("Acceleration (g)");
title("Acceleration vs Time");

% 
%velocity is converted from m/s to mph
figure(11);
plot(Time,V.*2.237);
xlabel("Time (s)");
ylabel("Velocity (mph)");
title("Velocity vs Time");

%tractive force
figure(12)
plot(Time, tractiveForce);
xlabel("Time (s)");
ylabel("Tractive Force (N)");
title("Tractive Force vs Time");

%calculating and plotting displacement 
figure(13)
displacement = cumtrapz(Time,V);
plot(Time,displacement);
xlabel("Time (s)");
ylabel("Displacement (m)");
% 
% % %time spent in each regime
% tractionTime
% powerTime
% % 
figure(14)
plot(displacement,V.*2.237);
xlabel("Displacement (m)");
ylabel("Velocity (mph)");

