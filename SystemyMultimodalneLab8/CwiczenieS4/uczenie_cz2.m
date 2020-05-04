%% Uczenie maszynowe, rozwiazanie
% - utworzony: 27.09.2018, R2017b-R2018b, J.Przyby�o, AGH
%
clear all;close all;clc

%% Wczytanie danych ucz�cych i testowych
load trainingData

%% Uczenie klasyfikatora
% - uruchom narz�dzie "classificationLearner" i post�puj wg instrukcji do
%   �wiczenia
classificationLearner

%% Uruchom wygenerowany kod tworz�cy klasyfikator
[trainedClassifier, validationAccuracy] = trainClassifier(formantsTableTraining);

%% Sprawd� klasyfikator na danych testowych
% predykcja
testResults = trainedClassifier.predictFcn(formantsTableTest);

% macierz pomylek
C = confusionmat(formantsTableTest.vowelClass,testResults)

% dok�adno�� klasyfikatora
accuracy1 = mean(cellfun(@eq,testResults, formantsTableTest.vowelClass))
