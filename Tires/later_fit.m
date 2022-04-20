%% Lateral Acceleration Information

load('/Users/ansontsang/Documents/vehicle_modeling/Tires/RawData_Cornering_Matlab_USCS_10inch_Round8/A1965raw16.mat')
%Round 8 Run 16 data

%Run 8 L2 loading normal loading schedule: 50, 100, 150, 200, 250, 350
FZ = FZ * (-1);

mask50 = (FZ > 45 & FZ < 51);
mask100 = (FZ > 95 & FZ < 101);
mask150 = (FZ > 145 & FZ < 151);
mask200 = (FZ > 195 & FZ < 201);
mask250 = (FZ > 247 & FZ < 249);
%mask350 = (FZ > 326 & FZ < 367);
						

FY50 = FY(mask50);
FY100 = FY(mask100);
FY150 = FY(mask150);
FY200 = FY(mask200);
FY250 = FY(mask250);
%FY350 = FY(mask350);

SA50 = SA(mask50);
SA100 = SA(mask100);
SA150 = SA(mask150);
SA200 = SA(mask200);
SA250 = SA(mask250);
%SA350 = SA(mask350);

% plot(SA50, FY50, "r*")
% plot(SA100, FY100, "b*")
% plot(SA150, FY150, "g*")
% plot(SA200, FY200, "k*")
% plot(SA250, FY250, "c*")

%Sigmoid function fitting
Nr_50 = normalize(FY50,'range');
Nr_100 = normalize(FY100,'range');
Nr_150 = normalize(FY150,'range');
Nr_200 = normalize(FY200,'range');
Nr_250 = normalize(FY250,'range');
%Nr_350 = normalize(FY350,'range');

logitCoef_50 = glmfit(SA50,Nr_50,'binomial','logit');
logitCoef_100 = glmfit(SA100,Nr_100,'binomial','logit');
logitCoef_150 = glmfit(SA150,Nr_150,'binomial','logit');
logitCoef_200 = glmfit(SA200,Nr_200,'binomial','logit');
logitCoef_250 = glmfit(SA250,Nr_250,'binomial','logit');
%logitCoef_350 = glmfit(SA350,Nr_350,'binomial','logit');

logiFit_50 = glmval(logitCoef_50,SA50,'logit');
logiFit_100 = glmval(logitCoef_100,SA100,'logit');
logiFit_150 = glmval(logitCoef_150,SA150,'logit');
logiFit_200 = glmval(logitCoef_200,SA200,'logit');
logiFit_250 = glmval(logitCoef_250,SA250,'logit');
%logiFit_350 = glmval(logitCoef_350,SA350,'logit');

figure
subplot(2,2,1)
title('Hoosier LZ0 16X7.5: SA vs FY','FontSize', 14);
box on
hold on
grid on


FY_50 = rescale(logiFit_50,min(FY50), max(FY50));
FY_100 = rescale(logiFit_100,min(FY100) ,max(FY100));
FY_150 = rescale(logiFit_150,min(FY150) ,max(FY150));
FY_200 = rescale(logiFit_200,min(FY200) ,max(FY200));
FY_250 = rescale(logiFit_250,min(FY250) ,max(FY250));

plot(SA50,FY_50,'r*');
plot(SA100,FY_100,'g*');
plot(SA150,FY_150,'b*');
plot(SA200,FY_200,'k*');
plot(SA250,FY_250,'c*');
%plot(SA350,rescale(logiFit_350,min(FY350) ,max(FY350)),'c-');
legend("50lb", "100lb", "150lb" ,"200lb", "250lb",'Location','Northeast','Box','Off');
xlabel("Slip Angle [deg]");
ylabel("Lateral Force [N]");
xlim([-15 15])

[m_50] = max(abs(FY_50));
[m_100] = max(abs(FY_100));
[m_150] = max(abs(FY_150));
[m_200] = max(abs(FY_200));
[m_250] = max(abs(FY_250));

loads = [50 100 150 200 250];
data = [m_50 m_100 m_150 m_200 m_250 ];

p = polyfit(loads, data,2);

f_fy = fit(loads',data','poly2');

subplot(2,2,2)
box on
hold on
grid on

plot(loads,data,'.','MarkerSize',16);
plot(f_fy);
%plot(x_1, y_1,'LineWidth',4);
xlabel('Normal Load [lbs]','FontSize',14)
ylabel('Lateral Force [lbs]','FontSize', 14)
title('Hoosier LZ0 16X7.5: FZ vs Max FY','FontSize', 14);
ax = gca;
ax.FontSize = 14;


%% Longitudinal Acceleration Information

load('/Users/ansontsang/Documents/vehicle_modeling/Tires/RawData_DriveBrake_Matlab_USCS_Round9/A2356raw69.mat')

FZ = FZ*(-1);
SR = SL;
FX = FX*(-1);

%L3: 50, 150, 250, 350	
mask50 = (FZ > 35 & FZ < 61);
mask250 = (FZ > 240 & FZ < 260);
mask150 = (FZ > 136 & FZ < 161);
mask200 = (FZ > 189 & FZ < 205);
						

FX50 = FX(mask50);
FX150 = FX(mask150);
FX250 = FX(mask250);
FX200 = FX(mask200);

SR50 = SR(mask50);
SR150 = SR(mask150);
SR250 = SR(mask250);
SR200 = SR(mask200);

% figure
% hold on
% grid on
% box on
% plot(SR50,FX50,'.')
% plot(SR150,FX150,'.')
% plot(SR250,FX250,'.')
% plot(SR200,FX200,'.')
%legend('50 lb', '150 lb', '250 lb', '200 lb')

Nr_50 = normalize(FX50,'range');
Nr_150 = normalize(FX150,'range');
Nr_250 = normalize(FX250,'range');
Nr_200 = normalize(FX200,'range');

logitCoef_50 = glmfit(SR50,Nr_50,'binomial','logit');
logitCoef_150 = glmfit(SR150,Nr_150,'binomial','logit');
logitCoef_250 = glmfit(SR250,Nr_250,'binomial','logit');
logitCoef_200 = glmfit(SR200,Nr_200,'binomial','logit');

logiFit_50 = glmval(logitCoef_50,SR50,'logit');
logiFit_150 = glmval(logitCoef_150,SR150,'logit');
logiFit_250 = glmval(logitCoef_250,SR250,'logit');
logiFit_200 = glmval(logitCoef_200,SR200,'logit');

%figure
subplot(2,2,3)
box on
hold on

FX_50s = rescale(logiFit_50,min(FX50), max(FX50));
FX_150s = rescale(logiFit_150,min(FX150) ,max(FX150));
FX_250s = rescale(logiFit_250,min(FX250) ,max(FX250));
FX_200s = rescale(logiFit_200,min(FX200) ,max(FX200));


title('Hoosier LZ0 16X7.5: SR vs FX','FontSize', 14);
plot(SR50,FX_50s,'r*');
plot(SR150,FX_150s,'b*');
plot(SR200,FX_200s,'c*');
plot(SR250,FX_250s,'k*');


legend("50lb", "150lb" ,"200lb", "250lb",'Location','Northeast',...
    'Box','Off','FontSize',14);
xlabel("Slip Ratio [deg]");
ylabel("Longitudinal Force [N]");
xlim([-0.35 0.35])
grid on


[m_50] = max(abs(FX_50s));
[m_150] = max(abs(FX_150s));
[m_250] = max(abs(FX_250s));
[m_200] = max(abs(FX_200s));

loads = [50 150 250 200];
data = [m_50 m_150 m_250 m_200] * (16/18) * (7.5/6);

f_fx = fit(loads',data','poly2');
subplot(2,2,4)
box on
hold on
grid on

plot(loads,data,'.','MarkerSize',16);
plot(f_fx);
xlabel('Normal Load [lbs]','FontSize',14)
ylabel('Longitudinal Force [lbs]','FontSize', 14)
title('Hoosier R20 16X7.5: FZ vs FX','FontSize', 14);
ax = gca;
ax.FontSize = 14;

fff(100);

%% F-F-F diagram generation


    fz = 100;
    
    a = f_fx(fz) * 2;
    b = f_fy(fz) * 2;
    
    theta = linspace(0,2*pi);
    
    x = a.* cos(theta);
    b = b .* sin(theta);
    
   figure
   plot(x,b)
   grid on
   box on
   title('F-F-F Diagram Fz: 100lbs')
   xlabel('Max Longitudinal Force')
   ylabel('Max Lateral Force')




