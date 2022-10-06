function [] = entropicHeatGen()
%data input
%format: ocv0 means open circuit voltage rise at 0 SOC
ocv0 = [0 1 -2 -8 -14];
temp0 = [0 6.1 11.9 19.8 28.6];
ocv10 = [0 -3 -6 -9 -13 -24];
temp10 = [0 2.1 6.6 12 19.2 30.7];
ocv20 = [0 -3 -6 -12 -18];
temp20 = [0 3.6 8.1 18.8 27.4];
ocv30 = [0 -1 -2 -4 -8 -10];
temp30 = [0 2.4 6.5 12.7 19.9 27.6];
ocv40 = [0 -1 -1 -3 -4 -6];
temp40 = [0 1.1 4.4 12.3 16.9 25.4];
ocv50 = [0 -1 -2 -3 -4 -5 -6];
temp50 = [1.1 5.8 9.2 14.4 17.8 23.6 30.4];
ocv60 = [0 0 -1 -2 -3 -4];
temp60 = [0 3.9 11.9 21 24.3 33.2];
ocv70 = [0 0 -1 -2 -3 -5 -6];
temp70 = [0 5.3 8.8 11.7 15.7 25.6 29.8];
ocv80 = [0 0 3 4 6 8 8];
temp80 = [0 4.6 13.4 16.1 19.3 27.9 31.6];
ocv90 = [0 -1 -2 -3 -5 -6 -7 -9 -11 -13];
temp90 = [0 2.3 5.9 6.8 11.9 14.7 16.6 21.1 28.5 32.6];
%ocv100 = [needs data]
%temp100 = [needs data]

allTemps = {temp0, temp10, temp20, temp30, temp40, temp50, temp60, temp70, temp80, temp90};
allOCV = {ocv0, ocv10, ocv20, ocv30, ocv40, ocv50, ocv60, ocv70, ocv80, ocv90};

%find the slopes
dVdt = [];
count = 1;
while count < 11
coeffs = polyfit(allTemps{count},allOCV{count},1);
slope = coeffs(1);
dVdt = [dVdt slope];

count = count + 1;
end

SOC = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
figure
plot(SOC,dVdt)
xlabel('SOC')
ylabel('dOCV/dt [mV/C]')

end