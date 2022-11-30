clear
A = readmatrix("Sample4Test3.xlsx");

time = A(:,1);
T1 = A(:,2);
T2 = A(:,3);

figure
hold on
plot(time,T1)
plot(time,T2)