function [x1, x2, twarz] = szukaj_twarz(BW)
%SZUKAJ_TWARZY Szuka ksztaltu twarzy w podanym obrazie binarnym
%                                                                         
%       [X1, X2, TWARZ] = SZUKAJ_TWARZY(BW) szuka obiektow na na obrazie
%       ktore moga byc twarzami. Uzywa do tego zamkniecia, odrzucenia
%       malych obiektow oraz szukania dziury wewnatrz obiektu. Jesli jest 
%       wiecje nic jeden to zwraca obiekt o najwiekszym obszarze.
%       
%INPUT:
%     BW    - zbinaryzowany obraz wejsciowy
%
%OUTPUT:                                                                         
%     X1    - I wierzcholek ramki, gorny  lewy naroznik                                  
%     X2    - III wierzcholek ramki, dolny prawy naro�nik                                  
%     TWARZ - obraz binarny zawieraj�cy tylko obiekt sklasyfikowany 
%             jako twarz, lub czarna obraz gdy nie znaleziono
%
%CREATED:
%    Pawel Miczko & Krzysztof Morcinek 2006
%
%VERSION: 1.2

x1 = 0;
x2 = 0;

twarz = zeros(size(BW,1), size(BW,2) );         % jako twarz zwroc zera
    
[L, ilosc_obj] = bwlabel(BW, 8);                % oznacza kolejne obiekty kolejnymi liczbami naturalnymi

wielkosc_max = 0;

for i=1:ilosc_obj
    [x,y] = find(L == i);                       % pod x i y podstawia wszytkie piksele danego obiektu
    bwsegment = bwselect(BW, y, x, 8);          % wybieramy wylko ten obiekt
    
    wys = max(x) - min(x);
    szer = max(y) - min(y);

    if  ( (wys < 1.4 * szer ) & (wys > 0.7 * szer ) )  % odpowiedni stosunek wysokosci do szerokosci
        ilosc_dziur = 1 - bweuler(bwsegment, 8);     

        if (ilosc_dziur > 0)                    % ma przynajmniej jedna dziure (oko, usta)
            wielkosc = sum( sum(bwsegment) );   % wielkosc obiektu

            if ( wielkosc > wielkosc_max)
                wielkosc_max = wielkosc;        % szukamy najwiekszego
                twarz = bwsegment;
                x1=[min(x), min(y)];        
                x2=[max(x), max(y)];            %skrajne punkty ramki dookola twarzy
 
            end;                  
        end;
    end;
end;