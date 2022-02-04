function [fro] = rearOutsideForce(cornering_parameters)

[mass, Kf, Kr, L, b, rho, hf, hr, hg, hl, Cl, A, t, g, v] = corner_decode(cornering_parameters);

syms a

LLTr = a.*(mass.*g./t).*((hl.*Kr)./(Kf+Kr)) + a.*(mass.*g.*(b)./L).*hr;

wro = 0.5.*mass.*g.*((L-b)./L) + 0.25.*rho.*Cl.*A.*(b./L).*v.^2+ LLTr;

fro = simplify(-0.0001.*wro.^2+2.18.*wro+149);
end

