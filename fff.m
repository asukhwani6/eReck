
%Parameters: [Fn_rearIn, Fn_rearOut, Fn_frontIn, Fn_frontOut]
function [f_x, f_y] = fff(FzTires, v,r,Parameters)

    mass = Parameters.mass;
    f_fx = @(x) 0.000134*x.^2 + 3.04.*x + 43.3; %Poly2 fit for max Fx vs Fz
    f_fy = @(x) -0.002395*x.^2 + 2.879.*x + 26.24; %Poly2 fit for max Fy vs Fz
    
    
    fy_car = (mass*v^2)/r;
    
      
    a = f_fx(FzTires/4.4482216153) * 4.4482216153; %Convert to N
    b = f_fy(FzTires/4.4482216153) * 4.4482216153; %Convert to N
    
    theta = linspace(0,2*pi);
    
    Fx = a .* cos(theta'); 
    Fy = b .* sin(theta'); %Lateral Envelope for each tire
    
    Fy_carMax = sum(b);
    
    
    f_y = (b/Fy_carMax) * fy_car; %Instantaneous Lateral Force per tire
    
    Fx_carMax = sum(a);
    
    figure
    hold on
    
    for c = 1:4
        [~,temp(c)] = min(abs(Fy(:,c) - f_y(c)));
        f_x(c) = Fx(temp(c),c);
        
        plot(Fx(:,c),Fy(:,c));
    end
    
    for c = 1:4
        plot(f_x(c),f_y(c),'o');
    end
    
    legend('Envelope 1','Envelope 2','Envelope 3','Envelope 4','Instanteous 1','Instanteous 2','Instanteous 3','Instanteous 4');
end