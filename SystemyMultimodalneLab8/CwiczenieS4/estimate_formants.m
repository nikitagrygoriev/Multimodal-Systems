function formants = estimate_formants(S3, Fs)
    % Estymacja formant�w LPC
    % Utworzenie: 18.10.2017, R2017b, J.Przyby�o, AGH
    %


    %  Snell, Roy C., and Fausto Milinazzo. "Formant location from LPC analysis data." IEEE� Transactions on Speech and Audio Processing. Vol. 1, Number 2, 1993, pp. 129-134.
    ncoeff=2+Fs/1000;           % ilo�� wsp�czynnik�w LPC (praktyczna zasada)
    A=lpc(S3,ncoeff);

    % wyznaczenie cz�stotliow�ci formant�w
    r=roots(A);                  % pierwiastki wielomianu - wyznaczanie
    r=r(imag(r)>=0);             % wyb�r rozwi�za� tylko dla zakresu < 0Hz do fs/2
    angz = atan2(imag(r),real(r));
    [frqs,indices] = sort(angz.*(Fs/(2*pi)));
    bw = -1/2*(Fs/(2*pi))*log(abs(r(indices)));

    % wyb�r tylko formant�w o f wi�kszych ni� 90Hz i mniejszych ni� 900Hz
    % https://en.wikipedia.org/wiki/Formant
    formants=[];
    nn = 1;
    for kk = 1:length(frqs)
        if (frqs(kk) > 90 && bw(kk) <900)
            formants(nn) = frqs(kk);
            nn = nn+1;
        end
    end
end
