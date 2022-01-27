function [ffi] = frontInsideForce()
load("cornering_parameters");

syms a

LLTf = a.*(mass.*g./t).*((hl.*Kf)./(Kf+Kr)) + a.*(mass.*g.*(L-b)./L).*hf;

wfi = 0.5.*mass.*g.*(b./L) + 0.25.*rho.*Cl.*((L-b)./L).*A.*v.^2 - LLTf;

ffi = simplify(-0.0001.*wfi.^2+2.18.*wfi+149);
end

