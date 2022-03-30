%% Lateral Acceleration Information

FY50 = FY(mask50);
FY100 = FY(mask100);
FY150 = FY(mask150);
FY200 = FY(mask200);
FY250 = FY(mask250);

SA50 = SA(mask50);
SA100 = SA(mask100);
SA150 = SA(mask150);
SA200 = SA(mask200);
SA250 = SA(mask250);

% plot(SA50, FY50, "r*")
% plot(SA100, FY100, "b*")
% plot(SA150, FY150, "g*")
% plot(SA200, FY200, "k*")
% plot(SA250, FY250, "c*")

%Sigmoid function fitting
figure
hold on
Nr_50 = normalize(FY50,'range');
Nr_100 = normalize(FY100,'range');
Nr_150 = normalize(FY150,'range');
Nr_200 = normalize(FY200,'range');
Nr_250 = normalize(FY250,'range');

logitCoef_50 = glmfit(SA50,Nr_50,'binomial','logit');
logitCoef_100 = glmfit(SA100,Nr_100,'binomial','logit');
logitCoef_150 = glmfit(SA150,Nr_150,'binomial','logit');
logitCoef_250 = glmfit(SA200,Nr_200,'binomial','logit');
logitCoef_250 = glmfit(SA250,Nr_250,'binomial','logit');

logiFit_50 = glmval(logitCoef_50,SA50,'logit');
logiFit_100 = glmval(logitCoef_100,SA100,'logit');
logiFit_150 = glmval(logitCoef_150,SA150,'logit');
logiFit_200 = glmval(logitCoef_250,SA200,'logit');
logiFit_250 = glmval(logitCoef_250,SA250,'logit');

figure
box on
hold on
plot(SA50,rescale(logiFit_50,min(FY50), max(FY50)),'r-');
plot(SA100,rescale(logiFit_100,min(FY100) ,max(FY100)),'g-');
plot(SA150,rescale(logiFit_150,min(FY150) ,max(FY150)),'b-');
plot(SA200,rescale(logiFit_200,min(FY200) ,max(FY200)),'k-');
plot(SA250,rescale(logiFit_250,min(FY250) ,max(FY250)),'c-');
legend("50lb", "100lb", "150lb" ,"200lb", "250lb",'Location','Northeast','Box','Off');
xlabel("Slip Angle [deg]");
ylabel("Lateral Force [N]");
xlim([-15 15])

%% Longitudinal Acceleration Information

load('/Users/ansontsang/Documents/vehicle_modeling/Performance Envelope Modeling/RunData_DriveBrake_Matlab_SI_Round9/B2356run69.mat');

FZ = FZ*(-1);
SR = SL;
FX = FX*(-1);

%L3: 50, 150, 250, 350	
mask50 = (FZ > 129 & FZ < 295);
mask250 = (FZ > 750 & FZ < 1040);
mask150 = (FZ > 550 & FZ < 790);
mask350 = (FZ > 950 & FZ < 1290);
						

FX50 = FX(mask50);
FX150 = FX(mask150);
FX250 = FX(mask250);
FX350 = FX(mask350);

SR50 = SR(mask50);
SR150 = SR(mask150);
SR250 = SR(mask250);
SR350 = SR(mask350);

figure
hold on
grid on
box on
plot(SR50,FX50,'.')
plot(SR150,FX150,'.')
plot(SR250,FX250,'.')
plot(SR350,FX350,'.')

legend('50 lb', '150 lb', '250 lb', '350 lb')
%% Logistic Fit

figure
hold on
Nr_50 = normalize(FX50,'range');
Nr_150 = normalize(FX150,'range');
Nr_250 = normalize(FX250,'range');
Nr_350 = normalize(FX350,'range');

logitCoef_50 = glmfit(SR50,Nr_50,'binomial','logit');
logitCoef_150 = glmfit(SR150,Nr_150,'binomial','logit');
logitCoef_250 = glmfit(SR250,Nr_250,'binomial','logit');
logitCoef_350 = glmfit(SR350,Nr_350,'binomial','logit');

logiFit_50 = glmval(logitCoef_50,SR50,'logit');
logiFit_150 = glmval(logitCoef_150,SR150,'logit');
logiFit_250 = glmval(logitCoef_250,SR250,'logit');
logiFit_350 = glmval(logitCoef_350,SR350,'logit');

figure
box on
hold on

FX_50s = rescale(logiFit_50,min(FX50), max(FX50));
FX_150s = rescale(logiFit_150,min(FX150) ,max(FX150));
FX_250s = rescale(logiFit_250,min(FX250) ,max(FX250));
FX_350s = rescale(logiFit_350,min(FX350) ,max(FX350));

plot(SR50,FX_50s,'r.');
plot(SR150,FX_150s,'b.');
plot(SR250,FX_250s,'k.');
plot(SR350,FX_350s,'c.');

legend("50lb", "150lb" ,"250lb", "350lb",'Location','Northeast',...
    'Box','Off','FontSize',14);
xlabel("Slip Ratio [deg]");
ylabel("Longitudinal Force [N]");
xlim([-0.35 0.35])
grid on


%% Linear Value

[m_50] = max(abs(FX_50s));
[m_150] = max(abs(FX_150s));
[m_250] = max(abs(FX_250s));
[m_350] = max(abs(FX_350s));

loads = [50 150 250 350];
data = [m_50 m_150 m_250 m_350] * (16/18) * (7.6/6);

p = polyfit(loads, data,2);

f = fit(loads',data','a + b*log(x)');

x_1 = linspace(loads(1),loads(4),100);
y_1 = polyval(p,x_1);
figure
box on
hold on
grid on

plot(loads,data,'.','MarkerSize',16);
plot(f);
%plot(x_1, y_1,'LineWidth',4);
xlabel('Normal Load [lbs]','FontSize',14)
ylabel('Longitudinal Force [lbs]','FontSize', 14)
title('Hoosier R20 16X7.5: FZ vs FX');
ax = gca;
ax.FontSize = 14;
