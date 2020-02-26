% Zadanie a
a = 23;
b = 5;
c = round(a/b);
d = mod(a,b);
% Zadanie b
v = [0 5 0 4 0]';
% Zadanie c
R2 = normrnd(3,5,[5,3]);
% Zadanie d
R3 = [R2 v];
% Zadanie e
x = 1:pi/10:2*pi;
y = sin(x);
plot(x,y);
% Zadanie f
meanY = mean(y);
% Zadanie g
syms x1 x2 x3
eqn1 = x1 + 2*x2 + 3*x3 == 5;
eqn2 = -x1 + x2 + 4*x3 == 1;
eqn3 = -x1 -2*x2 -3*x3 == -5;

[A,D] = equationsToMatrix([eqn1, eqn2, eqn3], [x1, x2, x3]);
rankM = rank(A);
det(A);

solEq = linsolve(A,D);

% Zadanie h
R = squeeze(RGB(:,:,1));
G = squeeze(RGB(:,:,2));
B = squeeze(RGB(:,:,3));

R1 = R(:)';
G1 = G(:)';
B1 = B(:)';
A1 = [R1;G1;B1];

addedVec = [0;128;128];

B2 = addedVec + [.299 .587 .114; -.169 -.331 .5; .5 -.419 -.081]*A1;
Y = B2(1,:);
Cb = B2(2,:);
Cr = B2(3,:);

Y = reshape(Y,[650,600]);
Cb = reshape(Cb,[650,600]);
Cr = reshape(Cr,[650,600]);
YCbCr = cat(3, Y, Cb ,Cr);

%image(Y);

% Zadanie i
a2=pi;
b2=ones(1,1, 'uint8');
c2 = a2 + double(b2);

% Zadanie j
letters = char('abcdefg');
lettersLen = length(char('abcdefg'));
word = [];
for i = 1:10
       letter =  letters(randi(lettersLen));
       word = [word, letter];
end
disp(word);