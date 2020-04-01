ramka_do_wczytania = 5;
vidObj = VideoReader('video.avi');
vidObj.CurrentTime = ramka_do_wczytania / 250;
RGB = readFrame(vidObj);

%figure;
%imshow(RGB)
% BW = roipoly;
%model_skory = createSkinModel2(RGB,BW);
%save dane_modelu model_skory BW RGB % zapis do plik MAT utworzonego modelu
% 
%figure;
%plot(model_skory)
%figure;
%imagesc(model_skory) % wizualizacja modelu (do sprawozdania)
%xlabel(...);
%ylabel(...);
simout = sim('lab6');

Lab6_2()
x1 = double(x);
y1 = double(y);
figure ('Name','Raw Data','NumberTitle','off');
plot(x1, y1, '-b.')

% ox = 107;
% oy = 109;
%x2 = x1 - ox;
%y2 = y1 - oy;
sx = max(x1) - min(x1);
sy = max(y1) - min(y1);
ox = max(x1)- sx;
oy = max(y1)- sy;
x3 = x1 / sx;
y3 = y2 / sy;
figure ('Name','Normalized','NumberTitle','off');
plot(x3, y3, '-b.')

mu_f = getElement(simout.logsout,'mu_filtered');
mu_f2 = mu_f.Values.Data;
x_f = mu_f2(1,1,:);x_f=x_f(:);
y_f = mu_f2(1,2,:);y_f=y_f(:);
figure ('Name','Filtered','NumberTitle','off');
plot(x_f, y_f, '-b.')