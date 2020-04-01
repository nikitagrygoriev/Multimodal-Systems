mu1 = getElement(simout.logsout,'mu');
mu2 = mu1.Values.Data;
x = mu2(1,1,:);x=x(:);
y = mu2(1,2,:);y=y(:);
% figure;
% subplot(2,1,1);plot(x)
% subplot(2,1,2);plot(y)
% figure;
% plot(x, y, '-b.')
% figure;
% comet(double(x),double(y))