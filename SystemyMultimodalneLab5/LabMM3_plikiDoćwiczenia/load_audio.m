function data = load_audio(filename)
    % Funkcja wczytuj�ca i wst�pnie przetwarzaj�ca dane dla obiektu
    % datastore
    % Uwagi: identyfikator zbioru danych zak�ada nast�puj�c� struktur�
    % nazwy plik�w: <nazwasamog�oski>_<nr>_<kodOsoby>.wav np. 'o_1_mjk.wav'
    % 
    % Utworzenie: 18.10.2017, R2017b, J.Przyby�o, AGH
    
    % Wczytanie pliku
    [S0,Fs]=audioread(filename);
    if size(S0,2)>1
        S1=S0(1:min([Fs size(S0,1)]),1); % wybierz max. 1 sec audio (mono)
    else
        S1=S0(1:min([Fs size(S0,1)]));   % wybierz max. 1 sec audio 
    end
    if length(S1)<Fs
        warning([filename ' : sygna� audio poni�ej 1 sec (' num2str(1000*(length(S1)/Fs)) ' [ms])'])
    end
    
    % Preprocessing sygna�u
	% - okno czasowe Hamminga
    % - filtr preemfazy
    S2 = S1.*hamming(length(S1));
    preemph = [1 0.63];
    S3 = filter(1,preemph,S2);
    
    % Nazwa zbioru danych
    [~,fname1,~]=fileparts(filename);
    vowelName = fname1(1);
    personId = fname1(5:end);
    
    % Dane wyj�ciowe (struktura)
    data.s = S3;
    data.Fs = Fs;
    data.vowelName = vowelName;
    data.personId = personId;
end