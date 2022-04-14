function [fx] = tire_x(fz)

fx = (-4982) + 1503 * log(fz);

fx = fx * (1/4.448); %Convert to N

end