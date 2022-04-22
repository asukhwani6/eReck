%Parameters: [Fn_rearIn, Fn_rearOut, Fn_frontIn, Fn_frontOut]
function [f_x, f_y] = fff(FzTires, v,r,Parameters,graph)

    mass = Parameters.mass;
    f_fx = @(x) .50*(-0.001379*x.^2 + 3.542*x + 7.922);
    f_fy = @(x) .50*(-0.002103*x.^2 + 2.892*x + 13.71);
    
    
    fy_car = (mass*v^2)/r;
    
      
    a = f_fx(FzTires/4.4482216153) * 4.4482216153; %Convert to N
    b = f_fy(FzTires/4.4482216153) * 4.4482216153; %Convert to N
    
    theta = linspace(0,pi/2);
    
    Fx = a .* cos(theta'); 
    Fy = b .* sin(theta'); %Lateral Envelope for each tire
    
    Fy_carMax = sum(b);
    
    
    f_y = (b/Fy_carMax) * fy_car; %Instantaneous Lateral Force per tire
    
    Fx_carMax = sum(a);
    if graph == 1
%         figure
%         hold on
    end
    
    for c = 1:4
        [~,temp(c)] = min(abs(Fy(:,c) - f_y(c)));
        f_x(c) = Fx(temp(c),c);
        if graph == 1
            plot(Fx(:,c),Fy(:,c));
        end
    end
    
    for c = 1:4
        if graph == 1
            plot(f_x(c),f_y(c),'o');
        end
    end
    if graph == 1
          legend('Envelope 1','Envelope 2','Envelope 3','Envelope 4','Instanteous 1','Instanteous 2','Instanteous 3','Instanteous 4');
    end
end