%TODO: Fy vs SA vs Fz
%Fx_max vs Fz

SR = B1965raw53.SR;
FX = B1965raw53.FX;
FZ = B1965raw53.FZ * (-1);
SA = B1965raw53.SA;

FZ = FZ(1:20000);

% convert to lbs
FZ_lb = FZ; %abs(FZ) / 4.4482216152605;
FX_lb = FX / 4.4482216152605;


% create masks for when FZ is 50, 100, 150, 200, 250 lbs
mask1500 = (FZ_lb > 1450 & FZ_lb < 1550);
mask1050 = (FZ_lb > 1000 & FZ_lb < 1100);
mask200 = (FZ_lb > 150 & FZ_lb < 250);
mask500 = (FZ_lb > 580 & FZ_lb < 660);
mask300 = (FZ_lb > 250 & FZ_lb < 350);

%mask target data 
SR1500 = SR(mask1500);
SR1050 = SR(mask1050);
SR200 = SR(mask200);
SR500 = SR(mask500);
SR300 = SR(mask300);


FX1500 = FX_lb(mask1500);
FX1050 = FX_lb(mask1050);
FX200 = FX_lb(mask200);
FX500 = FX_lb(mask500);
FX300 = FX_lb(mask300);


%fx_max = [min(FX50) min(FX100) min(FX150) min(FX200) min(FX250)];
figure

subplot(2,1,1), plot(SR200, FX200, "r*");
subplot(2,1,2), plot(SR300, FX300, "r*");
% subplot(3,3,3), plot(SR500, FX500, "b*");
% subplot(3,3,4), plot(SR1050, FX1050, "g*");
% subplot(3,3,5), plot(SR1500, FX1500, "k*");
% plot(SR250, FX250, "c*")

figure
subplot(3,1,1), plot(FZ(mask200));
subplot(3,1,2), plot(FX200);
subplot(3,1,3),plot(SR200);