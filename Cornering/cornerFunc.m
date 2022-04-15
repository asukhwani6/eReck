function [v_allowed] = cornerFunc(cornering_parameters,radius,slipAngle)

[mass, Kf, Kr, L, b, rho, hf, hr, hg, hl, Cl, A, t, g, v] = corner_decode(cornering_parameters);

%Put parameters into FYcalc for front and rear to get coefficients. See pg 215-216 of Fundamentals of Vehicle Dynamics (Gillespie)

frontTireWeightStatic =  0.5.*mass.*g.*(b./L);
rearTireWeightStatic = 0.5.*mass.*g.*((L-b)./L);
coeff = FYcalc(slipAngle,frontTireWeightStatic);

aStiff = coeff(2);
bStiff = -coeff(1);

cFront = (mass*g./t).*((hl.*Kf)./(Kf+Kr-mass.*g.*hl)) + (mass.*g.*(L-b)./L).*hf./t;
dFront = 2.*frontTireWeightStatic+rho.*0.5.*Cl.*((b)./L).*A;

cRear = (mass.*g./t).*((hl.*Kr)./(Kf+Kr-mass.*g.*hl)) + (mass.*g.*(b)./L).*hr./t;
dRear = 2.*rearTireWeightStatic + 0.5.*rho.*Cl.*A.*((L-b)./L);

sF = 2.*frontTireWeightStatic;
sR = 2.*rearTireWeightStatic;
lF = 0.5.*Cl.*((b)./L).*A;
lR = 0.5.*rho.*Cl.*A.*((L-b)./L);

G = -4.*bStiff.*(cFront.^2+cRear.^2);
H = radius.*lF.*(2 + 4.*bStiff.*sF + 2.*bStiff.*lR.*radius) + radius.*lR.*(2 + 4.*bStiff.*sR + 2.*bStiff.*lR.*radius) + mass./slipAngle;
I = 2.*aStiff.*mass.*g-2.*bStiff.*(sR.^2+sF.^2);

f = @(x) G.*x.^2 + H.*x + I; %Lateral force( lateral accel)
[latAccel,~,~] = Bisection(f,1,30,0.1,100);
latAccel_g = latAccel./g;

v_allowed = sqrt(latAccel.*radius);

if radius == 0
    v_allowed = realmax;
end
end

