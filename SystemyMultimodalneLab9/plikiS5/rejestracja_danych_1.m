%% Pobieranie ramek obrazow z kamery
% CREATED: 15.11.2019, Jaromir Przybylo (przybylo@agh.edu.pl), R2018b

clear all;close all;clc

%% Konfiguracja kamery i katalogow wyjsciowych
% - podkatalog wyjsciowy jest automatycznie tworzony
% - w przypadku gdy podkatalog istnieje poprzednie pliki nie sa usuwane,
%   ale moga zostac nadpisane
% camera       = videoinput('winvideo', 1, 'RGB24_320x240');% ustawic odpowiedni nr kamery oraz rozdzielczosc
camera       = videoinput('linuxvideo', 1, 'YUY2_320x240');% ustawic odpowiedni nr kamery oraz rozdzielczosc
% camera       = webcam(1);           % ustawic odpowiedni nr kamery
nazwaObiektu = 'objectA';           % nazwa obiektu (ustaw odpowiednio - bez polskich znakow!)
typZbioru    = 1;                   % typ zbioru: 0 - uczacy, 1 - testowy
                            % uwaga - dane sa nadpisywane do odpowiednich katalogow
                            % w zaleznosci od wyboru "typZbioru"
                            
%---nie zmieniaj kodu ponizej
camera.FramesPerTrigger = 1;
camera.TriggerRepeat = inf;
camera.ReturnedColorspace = 'rgb';
if typZbioru==0
    outputFolder = ['Documents/MATLAB/' nazwaObiektu];       % nazwa podkatalogu do zapisu danych
else
    outputFolder = ['daneTestowe/' nazwaObiektu];       % nazwa podkatalogu do zapisu danych
end
if exist(outputFolder)~=7
    mkdir(outputFolder)
end

%% Rejestracja danych w trybie ciaglym (po kazdej ramce pauza ~0.5sec), 30 ramek
figure
keepRolling = true;
set(gcf,'CloseRequestFcn','keepRolling = false; closereq');
iter=1;maxIter = 30;

start(camera);
while keepRolling & iter <= maxIter 
%     im = snapshot(camera);
    im = peekdata(camera,1);
    if ~isempty(im)
        image(im)

        title(['ramka ' num2str(iter) ' z ' num2str(maxIter)]);
        iter=iter+1;
        drawnow

        imwrite(im, fullfile(outputFolder,[nazwaObiektu '_' num2str(iter) '.png']));
    end
    pause(0.5)
end
stop(camera)
    
%% Usuniecie obiektu kamery 
% (wymagane bo innaczej MATLAB nie zwolni zasobow sprzetowych)
clear camera
close all
