hold on
%trendR = getTrend(daneP.R(12:254))

%plot(daneP.R)
plot(daneP.R(12:254))
xR =  [1:length(daneP.R(12:254))];
yR = daneP.R(12:254)';
pR = polyfit(xR,yR,3);
plot(polyval(pR,xR))

%plot(daneP.G)
plot(daneP.G(10:255))
xG =  [1:length(daneP.G(10:255))];
yG = daneP.G(10:255)';
pG = polyfit(xG,yG,3);
plot(polyval(pG,xG))

%plot(daneP.B)
plot(daneP.B(12:254))
xB =  [1:length(daneP.B(12:254))];
yB = daneP.B(12:254)';
pB = polyfit(xB,yB,3);
plot(polyval(pB,xB))


norm(polyval(pR,xR))./norm(yR)
norm(polyval(pG,xG))./norm(yG)
norm(polyval(pB,xB))./norm(yB)