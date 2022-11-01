A = readmatrix("Entropic Heat Generation Testing","Sheet","Cell 24");
SOC = A(:,1);
RiseOCV = A(:,3);
RiseTemp = A(:,5);

scatter3(SOC,RiseTemp,RiseOCV)
xlabel('SOC')
ylabel('Temperature Rise (C)')
zlabel('OCV Change (mV)')

SOCvec = unique(SOC);
figure
hold on

for i = 1:length(SOCvec)
    mask = SOC == SOCvec(i);
    intSOC = SOC(mask);
    intRiseOCV = RiseOCV(mask);
    intRiseTemp = RiseTemp(mask);
    poly = fit(intRiseTemp,intRiseOCV,'poly1');
    plot(intRiseTemp,intRiseOCV,'.')
    plot(poly)
    
    storeSOC(i) = intSOC(1);
    entropicTerm(i) = poly.p1;
end
    
