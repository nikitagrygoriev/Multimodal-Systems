%% Uczenie maszynowe, rozwiazanie
% - utworzony: 27.09.2018, R2017b-R2018b, J.Przyby�o, AGH
%
clear all;close all;clc

%% (1) Dost�p do danych i przetwarzanie wst�pne
%      - import danych
%      - przetwarzanie wst�pne : okno czasowe Hamminga, filtr preemfazy
%  (2) Ekstrakcja cech
%      - estymacja formant�w LPC
%
folderName = 'audioFiles/';  % UZUPELNIJ KOD - podkatalog z plikami audio 

fds = fileDatastore(folderName,'ReadFcn',@load_audio,'FileExtensions','.wav');
N = 5; % liczba formant�w brana pod uwag�
formants=zeros(length(fds.Files),N);
vowelClass=cell(length(fds.Files),1);
sampleName=cell(length(fds.Files),1);
i = 1;
warning off
while hasdata(fds)
    audioD = read(fds);
    tmp = estimate_formants(audioD.s, audioD.Fs);
    formants(i,:) = tmp(1:N);
    vowelClass{i}=audioD.vowelName;
    [~,sampleName{i},~]=fileparts(fds.Files{i});
    i = i + 1;
end
warning on
% Przygotowanie tablicy danych
formantsTable = table(vowelClass, formants,'RowNames',sampleName);
disp(formantsTable)

%% Liczebno�� element�w dla danej klasy
uWovels = unique(vowelClass);           % unikalne nazwy samog�osek
nrOfVowels = length(uWovels);           % liczba samog�osek
nrOfexamples = zeros(nrOfVowels,1);     % rezultat: liczba element�w danej klasy
for i=1:nrOfVowels
    select1 = strcmp(vowelClass,uWovels(i));            % wyb�r element�w (okre�lona samog�oska), wektor logiczny
    % UZUPELNIJ KOD PONIZEJ
    nrOfexamples(i) = sum(select1);
end
table_nrOfexamples = table(uWovels, nrOfexamples);
disp(table_nrOfexamples)

%% Podzia� na zbi�r ucz�cy (70%) i testowy (30%)
zbiorUczacyP = .7;
% UZUPELNIJ KOD tak aby podzieli� zbi�r 70/30%
trainingDataId=[];testDataId=[];
for i=1:nrOfVowels
    idx1 = find(strcmp(vowelClass,uWovels(i)));         % indeksy element�w (okre�lona samog�oska), wektor
    idx2 = floor(zbiorUczacyP*length(idx1));                     % podzia�
    trainingDataId = [trainingDataId idx1(1:idx2)];     % indeksy zb. ucz�cego okre�lonej samog�oski
    testDataId = [testDataId idx1(idx2+1:end)];         % indeksy zb. testowego okre�lonej samog�oski
end
% zbi�r ucz�cy i zbi�r testowy
formantsTableTraining = formantsTable(trainingDataId,:);
formantsTableTest = formantsTable(testDataId,:);
% zapis do pliku MAT
save trainingData formantsTableTraining formantsTableTest
