function [ffo] = frontOutsideForce(cornering_parameters)

[mass, Kf, Kr, L, b, rho, hf, hr, hg, hl, Cl, A, t, g, v] = corner_decode(cornering_parameters);

syms a 

LLTf = a.*(mass.*g./t).*((hl.*Kf)./(Kf+Kr)) + a.*(mass.*g.*(L-b)./L).*hf;
%LLTf = a.*(mass.*g./t).*(((hl.*Kf)./(Kf+Kr)) + ((L-b)./L).*hf);
LLTr = a.*(mass.*g./t).*((hl.*Kr)./(Kf+Kr)) + a.*(mass.*g.*(b)./L).*hr;

Front_LLTD = double(LLTf/(LLTr+LLTf));

wfo = 0.5.*mass.*g.*(b./L) + 0.25.*rho.*Cl.*(L-b)./L.*A.*v.^2+LLTf;

%ffo = simplify(-0.0017.*wfo.^2+3.95.*wfo-274);
ffo = simplify(-0.0001.*wfo.^2+2.18.*wfo+149);

end

