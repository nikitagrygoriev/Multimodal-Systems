%% Detekcja i sledzenie twarzy
% - Detekcja twarzy i jej cech (Viola-Jones, harr object detector)
% - sledzenie twarzy (KLT)
% COMMENTS:
% > na podstawie przykladwo z MATLABa
% CREATED: 30.11.2012, Jaromir Przybylo, R2012b
% MODIFIED: 29.11.2013, Jaromir Przybylo, R2013b
%           - drobne poprawki do pracy z kamera
%           06.12.2019, Jaromir Przybylo, R2018b i R2019b
%           - dostosowanie kodu do dzia�ania (kilka funkcji zosta�o
%             usuni�te w nowej wersji i zamienione na nowe)
%
clear all;close all;clc
delete(imaqfind); %usuniecie wszystkich pozostalosci obiektow akwizycji

%% ------------------------------------------------------------------------
% Parametry
%  ------------------------------------------------------------------------
camera=1;               % jesli 1 to kamera, w innym przypadku plik
camNr=1;                % numer kamery (nr urzadzenia)
camTryb='YUY2_320x240';% tryb akwizycji obrazow z kamery
%camTryb='MJPG_320x240';% tryb akwizycji obrazow z kamery
%-
filename1='face1.avi';  % nazwa pliku video do analizy

%% ------------------------------------------------------------------------
% Detekcja twarzy i punktow charakterystycznych
%  ------------------------------------------------------------------------
% Utworzenie detektorow cech
faceDetector = vision.CascadeObjectDetector();                  % detektor twarzy
pointTracker = vision.PointTracker('MaxBidirectionalError', 2); % detektor cech

if camera
    % Akwizycja obrazu z kamery
    vid = videoinput('linuxvideo', camNr, camTryb);
    src = getselectedsource(vid);
    vid.FramesPerTrigger = 1;
    start(vid);
    videoFrame = ycbcr2rgb(getdata(vid));
    stop(vid);
else
    % Wczytanie obrazu z pliku AVI
    videoFileReader = VideoReader(filename1);
    videoFrame      = readFrame(videoFileReader);
end
videoFrameGray = rgb2gray(videoFrame);

% Detekcja twarzy i punktow charakterystycznych
bbox = step(faceDetector, videoFrameGray);
if isempty(bbox)
    disp('--- Nie znaleziono twarzy')
    imshow(videoFrame);title('Nie znaleziono twarzy')
    return;
end
%-konwersja wspolrzednych prostokata [x, y, w, h] na
%  tablice Mx2 wspolrzednych [x,y] 4 rogow prostokata.
bboxPoints = bbox2points(bbox(1, :));
            
% - detekcja cech charakterystycznych
points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));
if isempty(points)
    warning('Nie znaleziono punktow charakterystycznych w obrebie  twarzy')
end
xyPoints = points.Location;

% Wizualizacja rezultatow
%- wizualizacja
bboxPolygon = reshape(bboxPoints', 1, []);
videoOut = insertShape(videoFrameGray, 'Polygon', bboxPolygon, 'LineWidth', 3);
videoOut = insertMarker(videoOut, xyPoints, '+', 'Color', 'white');
figure, imshow(videoOut), title('Wykryta twarz');

%% ------------------------------------------------------------------------
% Sledzenie twarzy na podstawie cech charakterystycznych (algorytm KLT)
%  ------------------------------------------------------------------------
% PARAMETRY OPCJONALNE DO WIZUALIZACJI (USTAWIC ODPOWIEDNIO)
startTime = 0;%0.35;   % czas startu dla pliku video
pauseS    = 0;%0.5;    % zwolnienie wizualizacji o X secund

% Inicjalizacja okna wizualizacji
videoPlayer  = figure;
uicontrol(videoPlayer,'units','normalized','position',[0 0 0.2 0.1],...
 'string','stop','callback','stopCond=0;');    

% - utworzenie dodatkowych detektorow cech twarzy (usta, nos)
noseDetector = vision.CascadeObjectDetector('Nose');
mouthDetector = vision.CascadeObjectDetector('Mouth');

%- inicjalizacja zrodla video
if camera
    % Inicjalizacja kamery
    vid = videoinput('linuxvideo', camNr, camTryb);
    triggerconfig(vid,'manual');
    vid.FramesPerTrigger = 1;
    start(vid);
    pause(1);
else
    % Wczytanie obrazu z pliku AVI
    videoFileReader = VideoReader(filename1);
    videoFileReader.CurrentTime = startTime;    
    videoFrame      = readFrame(videoFileReader);
end
stopCond=1;

% Petla przetwarzania video
numPts = 0;
while stopCond
    % - pobranie ramki
    if camera
        videoFrame = ycbcr2rgb(peekdata(vid,1));
    else
        videoFrame = readFrame(videoFileReader);
        stopCond=hasFrame(videoFileReader);
    end
    videoFrameGray = rgb2gray(videoFrame);
    
    if numPts < 10
        disp('re-inicjalizacja trackera')
        % Detekcja punktow
        
        bbox = faceDetector.step(videoFrameGray);% detekcja twarzy
        if ~isempty(bbox)
            % znalezienie punktow wewnatrz ROI twarzy
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));

            % re-inicjalizacja trackera
            xyPoints = points.Location;
            numPts = size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);

            % zapamietanie kopii punktow
            oldPoints = xyPoints;

            %-konwersja wspolrzednych prostokata [x, y, w, h] na
            %  tablice Mx2 wspolrzednych [x,y] 4 rogow prostokata.
            %  (wymagane do funkcji transformacji przestrzenych)
            bboxPoints = bbox2points(bbox(1, :));

            %-konwersja wspolrzednych naroznikow prostokata do formatu 
            % wymaganego przez insertShape
            bboxPolygon = reshape(bboxPoints', 1, []);
            
            % Wizualizacja
            videoOut = insertShape(videoFrameGray, 'Polygon', bboxPolygon, 'LineWidth', 3);
            videoOut = insertMarker(videoOut, xyPoints, '+', 'Color', 'white');
            
        end
        
    else
        % Sledzenie punktow 
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);

        numPts = size(visiblePoints, 1);

        if numPts >= 10
            % Estymacja transformacji geometrycznej pomiedzy starymi a
            % nowymi punktami.
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);

            % Zastosowanie transformacji geometrycznej do prostokata twarzy
            bboxPoints = transformPointsForward(xform, bboxPoints);
            bboxPolygon = reshape(bboxPoints', 1, []);

            % Detekcja cech twarzy
            noseBBox=step(noseDetector,videoFrame);
            mouthBBox=step(mouthDetector,videoFrame);                                   
            
            % TODO
            % - zastanow sie jak mozna wyeliminowac falszywe detekcje 
            %   cech twarzy (oczy i usta), majac do dyspozycji wspolrzedne
            %   prostokata cech twarzy (bboxPoints) oraz wspolrzedne
            %   prostokatow potencjalnych obiektow ust (mouthBBox) i nosa (noseBBox)
            % bbox2 = [min(bboxPoints) max(bboxPoints)-min(bboxPoints)];
            % overlapRatio = bboxOverlapRatio(bbox2,noseBBox(1,:))
            
            % Wizualizacjawinvideo
            videoOut = insertShape(videoFrameGray, 'Polygon', bboxPolygon, 'LineWidth', 3);
            videoOut = insertMarker(videoOut, visiblePoints, '+', 'Color', 'white');
            for j=1:size(noseBBox,1)
                nosePoints = bbox2points(noseBBox(j, :));
                nosePoints = transformPointsForward(xform, nosePoints);            
                nosePolygon = reshape(nosePoints', 1, []);
                videoOut = insertShape(videoOut, 'Polygon', nosePolygon, 'LineWidth', 2, 'Color', 'blue');
            end
            for j=1:size(mouthBBox,1)                
                mouthPoints = bbox2points(mouthBBox(j, :));
                mouthPoints = transformPointsForward(xform, mouthPoints);
                mouthPolygon = reshape(mouthPoints', 1, []);
                videoOut = insertShape(videoOut, 'Polygon', mouthPolygon, 'LineWidth', 2, 'Color', 'green');
            end           

            % Reset punktow
            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
        end        
    end
                
    imshow(videoOut);
    if ~camera
        title(['Time = ' num2str(videoFileReader.CurrentTime)])
    end
    drawnow;  
    pause(pauseS);
end

% Usuwanie utworzonych obiektow akwizycji
if camera
    stop(vid);
end
close all

%
figure;
imshow(videoOut);
if ~camera
    title(['Time = ' num2str(videoFileReader.CurrentTime)])
end

%% References
%{
[1] Viola, Paul A. and Jones, Michael J. "Rapid Object Detection using a Boosted Cascade of Simple Features", IEEE CVPR, 2001.
[2] Bruce D. Lucas and Takeo Kanade. An Iterative Image Registration Technique with an Application to Stereo Vision. 
    International Joint Conference on Artificial Intelligence, 1981.
[3] Carlo Tomasi and Takeo Kanade. Detection and Tracking of Point Features. Carnegie Mellon University Technical Report CMU-CS-91-132, 1991.
[4] Jianbo Shi and Carlo Tomasi. Good Features to Track. IEEE Conference on Computer Vision and Pattern Recognition, 1994.
[5] Zdenek Kalal, Krystian Mikolajczyk and Jiri Matas. Forward-Backward Error: Automatic Detection of Tracking Failures. 
    International Conference on Pattern Recognition, 2010
%}



