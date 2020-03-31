%imaqtool
ramka_do_wczytania = 5;
vidObj = VideoReader('video.avi') % nie dawaj średnika i odczytaj z command
 % window FPS pliku
vidObj.CurrentTime = ramka_do_wczytania / 346;
RGB = readFrame(vidObj);
%doc roipoly % zapoznaj się z dokumentacją do funkcji
%edit createSkinModel2 % zapoznaj się z implementacja funkcji
figure;
imshow(RGB)
BW = roipoly;
model_skory = createSkinModel2(RGB,BW);
save dane_modelu model_skory BW RGB % zapis do plik MAT utworzonego modelu
figure;
imagesc(model_skory) % wizualizacja modelu (do sprawozdania)
%xlabel(...);
%ylabel(...);