%parameters: distance | output: allowed_entry_velocity

function [allowed_v] = allowed_cornering(radius,cornering_parameters)

[mass, Kf, Kr, L, b, rho, hf, hr, hg, hl, Cl, A, t, g, v] = corner_decode(cornering_parameters);

syms a v 

assume(a > 0);
ffo = frontOutsideForce(cornering_parameters); 
ffi = frontInsideForce(cornering_parameters);
fro = rearOutsideForce(cornering_parameters);
fri = rearInsideForce(cornering_parameters);

frontForce = simplify(ffo + ffi);
rearForce = simplify(fro + fri);

corneringForce = frontForce + rearForce;

secondLaw = simplify(corneringForce);

T = secondLaw == mass.*a; %Final Equation

B = double(solve(T))./g;

Lateral_Acceleration = B(2);

allowed_v = sqrt(Lateral_Acceleration * radius);

end