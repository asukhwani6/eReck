function [xr,iter,X] = Bisection(f,xl,xu,es,imax)

%This function finds the approximate root of a function by searching within
%a user defined interval. It does this by checking the sign of the function
%at the 2 points and, if the signs show that the function crosses the
%x-axis, it takes the midpoint between the 2 points to be the approximate
%root. Done iteratively, this method will always converge on the root,
%given the correct starting conditions.

%inputs
%function handle
%lower initial value
%upper initial value
%stopping criterion
%max iteration number 

%outputs
%approximate root
%number of iterations used
%vector containing roots



%initializing variables and vectors 

x = 0;
iter = 0;
ea = es + 1;
flag = true;
eavec = [];
X =[];

g = f(xl);
p = f(xu);

%Initial check if xl and xu are valid inputs
if sign(f(xl).*f(xu)) ~= -1 
    sprintf("Invalid initial guesses");
    flag = false;
    X = [NaN];
    eavec = [NaN];
    iter = NaN;
end

%bisection implementation in while loop
while ea >= es && iter < imax && flag == true
    %storing previous x for ea calculation
    xp = x;
    
    %calculating new x based on bisection method
    x = (xu + xl).*(0.5);
    
    %storing new x in vector
    X = [X  x];
    
    %checking if root has been found exactly 
    if(f(x).*f(xl)==0)
        %root has been found exactly 
    end
 
    %finding values for next iteration also checking to make sure multiple
    %roots do not exist
    %checks whether root is in upper or lower region
    if(sign(f(x).*f(xl))==-1)
        xu = x;
        %checks if there is a root in the other region
        if(iter <= 1 && sign(f(x).*f(xu))== -1)
            sprintf("There are multiple roots. Please choose initial values closer to the desired root");
        end
        
    %checks whether root is in upper or lower region
    elseif(sign(f(x).*f(xu))==-1)
        xl = x;
        %checks if there is a root in the other region
        if(iter <= 1 && sign(f(x).*f(xl))== -1)
            sprintf("There are multiple roots. Please choose initial values closer to the desired root");
        end
    end
    
    %starts calculation for ea only after the first iteration per the
    %definition of ea
    if iter >= 1
        %calculates ea
        ea = (abs(x-xp)./(abs(x))).*100;
        %stores ea values in a vector
        eavec = [eavec ea];
    end
    %adds one to the iter count
    iter = iter + 1;
end

%final value assignment. Also creates a vector composed of values of iter
ea = eavec(end);
itervec = [2:iter];
xr = X(end);

%prints statement and generates graph with the appropriate labels, grid,
%and a title.
% fprintf('The approximate root of the function is %f, found after %f iterations, with an approximate relative error of %f percent.',xr,iter,ea);
% semilogy(itervec,eavec,'-');
% grid on;
% xlabel('Iteration Number');
% ylabel('Approximate relative percent error');
% title('Plot of approximate relative percent error vs iteration number');
% hold on
% if flag == false
%     fprintf("Invalid initial guesses.");
% end

%Author: Marc-Anthony Maquiling
%Section: ME2016 - Section E
%Assignment: HW1
%Date: 2/18/21

end

