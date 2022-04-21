close all
HT06_vehicle_parameters;
r = 20;
l = 100;

mass = Parameters.mass;

t = 0;
dt = 0.001;
Ax = 0;
v = 23;
dist = 0;
vVec = [];
dVec = [];
FxTiresVec = [];
FzTiresVec = [];
FyTiresVec = [];

while(abs(dist)<l)
    t = t + dt;
    [FzTires, phi] = tireNormalForces(Ax,v,r,Parameters);
    [f_x, ~] = fff(FzTires, v,r,Parameters,0);
    
    % Power Limitation Logic
    [FxFront,FxRear] = powerLimited(v,Parameters);

    rearAxleForceTraction = f_x(1) + f_x(2);
    FxOutRear = min(FxRear,rearAxleForceTraction);
    f_x(1) = (f_x(1)/rearAxleForceTraction)*FxOutRear;
    f_x(2) = (f_x(2)/rearAxleForceTraction)*FxOutRear;
    f_x(3) = min(FxFront,f_x(3));
    f_x(4) = min(FxFront,f_x(4));

    % Calculate Acceleration
    Ax = sum(f_x)/mass;
    midV = v + (dt./2).*Ax;

    [FzTires, phi] = tireNormalForces(Ax,midV,r,Parameters);
    [f_x, f_y] = fff(FzTires,midV,r,Parameters,0);

    % Power Limitation Logic
    [FxFront,FxRear] = powerLimited(v,Parameters);

    rearAxleForceTraction = f_x(1) + f_x(2);
    FxOutRear = min(FxRear,rearAxleForceTraction);
    f_x(1) = (f_x(1)/rearAxleForceTraction)*FxOutRear;
    f_x(2) = (f_x(2)/rearAxleForceTraction)*FxOutRear;
    f_x(3) = min(FxFront,f_x(3));
    f_x(4) = min(FxFront,f_x(4));

    Ax = sum(f_x)/mass;

    v = v + Ax*dt;
    dist = dist + v*dt;

    FzTiresVec = [FzTiresVec;FzTires];
    FxTiresVec = [FxTiresVec;f_x];
    FyTiresVec = [FyTiresVec;f_y];
    vVec = [vVec, v];
    dVec = [dVec, dist];
end

plot(dVec,vVec,'.')
figure
hold on
plot(dVec,FxTiresVec(:,1))
plot(dVec,FxTiresVec(:,2))
plot(dVec,FxTiresVec(:,3))
plot(dVec,FxTiresVec(:,4))

title('Long Force for each tire')
xlabel('distance (m)')
ylabel('Force (N)')
legend({'FxRi','FxRo','FxFi','FxFo'})

figure
hold on
plot(dVec,FyTiresVec(:,1))
plot(dVec,FyTiresVec(:,2))
plot(dVec,FyTiresVec(:,3))
plot(dVec,FyTiresVec(:,4))
title('Lateral Force for each tire')
xlabel('distance (m)')
ylabel('Force (N)')
legend({'FyRi','FyRo','FyFi','FyFo'})

figure
hold on
plot(dVec,FzTiresVec(:,1))
plot(dVec,FzTiresVec(:,2))
plot(dVec,FzTiresVec(:,3))
plot(dVec,FzTiresVec(:,4))
title('Normal Force for each tire')
xlabel('distance (m)')
ylabel('Force (N)')
legend({'FzRi','FzRo','FzFi','FzFo'})

figure
hold on
plot(FxTiresVec(:,1)./FzTiresVec(:,1),FyTiresVec(:,1)./FzTiresVec(:,1),'.')
plot(FxTiresVec(:,2)./FzTiresVec(:,2),FyTiresVec(:,2)./FzTiresVec(:,2),'.')
plot(FxTiresVec(:,3)./FzTiresVec(:,3),FyTiresVec(:,3)./FzTiresVec(:,3),'.')
plot(FxTiresVec(:,4)./FzTiresVec(:,4),FyTiresVec(:,4)./FzTiresVec(:,4),'.')
legend({'Ri','Ro','Fi','Fo'})

figure
hold on
plot(FxTiresVec(:,1),FyTiresVec(:,1),'.')
plot(FxTiresVec(:,2),FyTiresVec(:,2),'.')
plot(FxTiresVec(:,3),FyTiresVec(:,3),'.')
plot(FxTiresVec(:,4),FyTiresVec(:,4),'.')
legend({'Ri','Ro','Fi','Fo'})

[f_x, f_y] = fff(FzTires, v,r,Parameters,1);