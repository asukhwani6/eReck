%Calculating initial tractive force and accelerations
function [tractiveForce, Afinal] = initialForces(vi)
[Ft,At] = tractionLimited(vi);
[Fp,Ap] = powerLimited(vi);

%Determining which of the two to start the vectors with
if Ft <= Fp
    Afinal = At;
    tractiveForce = Ft;
    Ax = At;
elseif Ft > Fp
    Afinal = Ap;
    tractiveForce = Fp;
    Ax = At;
end