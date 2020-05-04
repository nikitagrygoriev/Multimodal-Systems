%% Uczenie maszynowe, rozwiazanie
% - utworzony: 27.09.2018, R2017b-R2018b, J.Przyby³o, AGH
%
clear all;close all;clc

%% Wczytanie danych ucz¹cych i testowych
load trainingData

%% Uczenie klasyfikatora
% - uruchom narzêdzie "classificationLearner" i postêpuj wg instrukcji do
%   æwiczenia
classificationLearner

%% Uruchom wygenerowany kod tworz¹cy klasyfikator
[trainedClassifier, validationAccuracy] = trainClassifier(formantsTableTraining);

%% SprawdŸ klasyfikator na danych testowych
% predykcja
testResults = trainedClassifier.predictFcn(formantsTableTest);

% macierz pomylek
C = confusionmat(formantsTableTest.vowelClass,testResults)

% dok³adnoœæ klasyfikatora
accuracy1 = mean(cellfun(@eq,testResults, formantsTableTest.vowelClass))
