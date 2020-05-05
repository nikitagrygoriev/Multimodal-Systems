%% Uczenie sieci - transfer learning
% CREATED: 06.03.2019, Jaromir Przybylo (przybylo@agh.edu.pl), R2018b
%
clear all;close all;clc

%% Przygotowanie danych do uczenia sieci - zbior uczacy
% - obiekt imageDatastore (poszczegolne klasy obiektow w podkatalogach)
% - podzial na zbior uczacy i walidujacy (70%/30%)
images = imageDatastore('daneUczace',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');
[trainingImages,validationImages] = splitEachLabel(images,0.7,'randomized');

%% Wizualizacja przykladowych danych uczacych
numTrainImages = numel(trainingImages.Labels);
idx = randperm(numTrainImages,16);
figure
for i = 1:16
    subplot(4,4,i)
    [I, finfo] = readimage(trainingImages,idx(i));
    imshow(I)
    title(char(finfo.Label))
end

%% Wczytanie gotowej sieci AlexNet
% - siec AlexNet zostala wytrenowana do rozpoznawania obiektow nalezacych
%   do jednej z 1000 kategorii, do trenowania uzyto ponad 1 milion obrazow
net = alexnet;

% - wizualizacja sieci
analyzeNetwork(net)

% Siec byla uczona obrazami przeskalowanymi do mniejszego rozmiaru
% - zanotuj rozmiar obrazu wejjciowego akceptowanego przez siec
%   (wartwa nr.1 "ImageInput")
inputSize = net.Layers(1).InputSize

%% Uzycie domyslnej sieci Alexnet do rozpoznawania
% - pobierz kilka obrazow ronych obiektow i zanotuj wyniki rozpoznawania
%   - pobierz obrazy przy uzyciu np imaqtool i zapisz do plikow
%   - zmodyfikuj odpowiednio kod ponizej aby wczytac danych obraz
%   - wyeksportuj do sprawozdania utworzone wykresy (odkomentuj odpowienia
%     czsc kodu w tej sekcji)

imFileName = 'example1.png';      % nazwa obrazu (POBIERZ GO WCZESNIEJ - IMAQTOOL)

%- wczytanie obrazu i dostosowanie jego rozmiaru
IM0 = imread(imFileName);               % wczytanie obrazu z pliku
IM1 = imresize(IM0, inputSize(1:2));    % dostosowanie rozmiaru pliku do wejscia sieci

%- rozpoznawanie
[YPred,scores] = classify(net, IM1);

%- wizualizacja
nazwyKlas = net.Layers(end).Classes;    % pobranie nazw klas z ostatniej warstwy
idKlasy = find( YPred == nazwyKlas);    % id rozpoznanej klasy
Pklasy = scores(idKlasy);               % prawdopodobienstwo rozpoznanej klasy
[topTen, id10] = sort(scores,'descend');% 10 najbardziej prawdopodobnych klas
topTen=topTen(1:10);id10=id10(1:10);

fh=figure;
ah1=subplot(2,1,1);
imshow(IM0)
title(['Rozpoznano: ' char(YPred) ', P = ' num2str(Pklasy)])
ah2=subplot(2,1,2);
bar(topTen)
ylim([0 1.1])
xticklabels(cellstr(nazwyKlas(id10)))
ah2.XTickLabelRotation=90;
title('Top 10')

%-eksport wykresu do pliku (nazwa ustawiana automatycznie wg nazwy pliku
% wejsciowego)
% - mozna to takze zrobic "recznie" - w oknie Figure, Manu, Plik>Save As... wybrac PNG
%{
[~,fname1,~]=fileparts(imFileName);
saveas(fh,[fname1 '_output.png'])
%}

%% Wizualizacja dzialania sieci (wagi, aktywacje) dla wybranego obrazu
%% --- Wagi dla warstw ---
% Kazda warstwa sieci konwolucyjnej sklada sie z wielu filtrow w postaci
% wag. W procesie uczenia, siec "wyksztalca" filtry/wagi.
% - zanotuj w sprawozdaniu:
%   - rozmiar kazdego filtru warstwy nr.2 (CONV1)
%     Co oznaczaja parametry: FilterSize, NumChannels, Stride
%   - liczbe filtrow dla warstwy nr.2 (CONV1, NumFilters)
%   - zwroc uwage na wizualizacje wag - jakie cechy Twoim zdaniem bedzie
%     wykrywal dany filtr?
net.Layers(2)
net.Layers(2).NumFilters
w1=net.Layers(2).Weights;
size(w1)
figure;
montage(w1)
title('tablica filtrow/wag warstwy CONV1)')
%-ponizszy kod pozwala zwizualizowac wybrany filtr w IMTOOL
filtrNr = 50;
imtool(w1(:,:,:,filtrNr),[]);


%% --- Wizualizacja aktywacji dla warstwy CONV1 --- 
%  Obraz wejsciowy takiej warstwy, podlega filtracji dajac wiele obrazow
%  wyjsciowych (aktywacji). 
%  Na wizualizacji, jasne obszary odpowiadaja silnym pozytywnym odpowiedziom
%  danego filtru, ciemne - silnym negatywnym. rezultaty w kolorze szarym
%  odpowiadaja slabym aktywacjom.
%  Warstwy konwolucyjne mozna traktowac wiec jak detektory cech obrazu. 
act1 = activations(net, IM1,'conv1');%pobranie aktywacji z wybranej warstwy
sz = size(act1);
act1 = reshape(act1,[sz(1) sz(2) 1 sz(3)]);
I = imtile(mat2gray(act1),'GridSize',[8 12]);
figure;
imshow(I)
title('aktywacje wartstwy CONV1')

% --- Najsilniejsza aktywacja dlawarstwy CONV1 --- 
% - zwroc uwage na to jakie cechy obrazu sa wykrywane przez ten filtr
%   (krawedzie, plamy... jasne, ciemne...)
imgSize = size(IM1);
imgSize = imgSize(1:2);
[maxValue,maxValueIndex] = max(max(max(act1)));
act1chMax = act1(:,:,:,maxValueIndex);
act1chMax = mat2gray(act1chMax);
act1chMax = imresize(act1chMax,imgSize);
figure;
I = imtile({IM1,act1chMax});
imshow(I)
title('najsilniejsza aktywacja wartstwy CONV1')

%% --- Wizualizacja aktywacji dla "glebszej" warstwy CONV5 --- 
act5 = activations(net,IM1,'conv5');
sz = size(act5);
act5 = reshape(act5,[sz(1) sz(2) 1 sz(3)]);
I = imtile(imresize(mat2gray(act5),[48 48]));
figure;
imshow(I)
title('aktywacje wartstwy CONV5')

% --- Najsilniejsza aktywacja dlawarstwy CONV5 --- 
% - zwroc uwage na to jakie cechy obrazu sa wykrywane przez ten filtr
%   (krawedzie, plamy... jasne, ciemne...)
[maxValue5,maxValueIndex5] = max(max(max(act5)));
act5chMax = act5(:,:,:,maxValueIndex5);
figure;
imshow(imresize(mat2gray(act5chMax),imgSize))
title('najsilniejsza aktywacja wartstwy CONV5')


%% Dostosowanie sieci do nowego uczenia
% Ostatnie warstwy sieci konwolycyjnych realizuja klasyfikacje (sa to
% klasyczne warstwy sieci neuronowej - polaczenia kazdy-z-kazdym).
% Daje to mozliwosc latwego dostosowania juz nauczonej sieci do realizacji
% nowego zadania. 
% Poprzez zastapienie ostatnich 3 warstw nowymi warstwami i przeprowadzenie
% uczenia na nowym zbiorze obrazow uczacych, mamy mozliwosc "douczenia"
% sieci aby rozpoznawala nowy zbior klas. 
% Poniewaz nowy zbior uczacy zazwyczaj zawiera niewielka liczbe obrazow,
% poczatkowe warstwy sieci (konwolucyjne...) zmieniaja swoje wagi w
% niewielkim stopniu. Mozna tez ew zablokowac uczenie poczatkowych warstw.
% Dzieki temu, wyksztalcone detektory cech pozostaja niezmienione.
% "Douczamy" tylko ostatnie warstwy realizujace klasyfikacje.
layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(trainingImages.Labels)); % liczba nowych klas ze zbioru uczacego
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

%% Przygotowanie danych do uczenia sieci - data augmentation, resize...
% Ze wzgledu na niewielka liczbe obrazow uczacych, moga wystapic negatywne
% efekty uczenia sieci (np. uczenie "na pamiec"). Dlatego stosuje sie
% technike "data augmentation", ktora sztucznie zwieksza liczbe obrazow
% uczacych poprzez dodanie niewielkich translacji, rotacji...
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),trainingImages, ...
    'DataAugmentation',imageAugmenter);

augimdsValidation = augmentedImageDatastore(inputSize(1:2),validationImages);

%% Uczenie sieci
% - w procesie uczenia wykorzystujemy zarowno zbior uczacy jak i walidujacy

% - parametry uczenia
miniBatchSize = 10;
numIterationsPerEpoch = floor(numel(trainingImages.Labels)/miniBatchSize);
options = trainingOptions('sgdm',...
    'MiniBatchSize',miniBatchSize,...
    'MaxEpochs',4,...
    'InitialLearnRate',1e-4,...
    'Verbose',false,...
    'Plots','training-progress',...
    'ValidationData',augimdsValidation,...
    'ValidationFrequency',numIterationsPerEpoch);

% - uczenie (proces ten moze potrwac dlugo - w zaleznosci od ilosci danych)
netTransfer = trainNetwork(augimdsTrain,layers,options);

%- eksport sieci do pliku MAT
save nauczonaSiec netTransfer

%% Testowanie sieci na danych walidacyjnych
%- zanotuj dokladnosc klasyfikacji
[YPred,scores] = classify(netTransfer,augimdsValidation);

YValidation = validationImages.Labels;
accuracy = 100*mean(YPred == YValidation);
disp(['Dokladnosc (zbior walidujacy) = ' num2str(accuracy,'%2.1f'), '%'])

%% Testowanie sieci - osobny zbior testowy
% - nagrac kilka dodatkowych obrazow testowych dla kazdej klasy (do
%   osobnego katalogu !!!)
% - zanotuj dokladnosc klasyfikacji
testImages = imageDatastore('daneTestowe',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');
% augTest = augmentedImageDatastore((1:1),testImages);% resize
augTest = testImages;
[YPredT,scoresT] = classify(netTransfer,augTest);
YValidationT = testImages.Labels;
accuracyT = 100*mean(YPredT == YValidationT);
disp(['Dokladnosc (zbior testowy) = ' num2str(accuracyT,'%2.1f'), '%'])

%-macierz pomylek (wyeksportuj do sprawozdania)
% - ktore klasy sa ze soba mylone najczeciej?
fh=figure;
confusionchart(YValidationT,YPredT)
%{
saveas(fh,['macierz_pomylek.png'])
%}

%% Wizualizacja "co widzi siec neuronowa"
% Do diagnozowania dzialania sieci glebokich mozna wykorzystac technike
% nazywana "Deep Dream Visualization". Technika ta pozwala na synteze
% obrazu, ktory wywoluje najwieksza aktywacje wybranej warstwy. Dzieki temu
% mozna zwizualizowac cechy obrazu, ktorych "nauczyla sie" siec. 
layer = 23;         % wybor warstwy, dla ktorej bedzie realizowana wizualizacja
channels = [1 2 3]; % wybor klas, dla ktorych bedzie realizowana wizualizacja
netTransfer.Layers(end).Classes(channels)

I = deepDreamImage(netTransfer,layer,channels);
I1 = imtile(I);
figure
imshow(I1)






