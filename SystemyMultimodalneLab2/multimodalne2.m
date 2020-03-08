R = randn([3 3]);
A = uint32(100);
B = R.*double(A);
whos

str0 = 'ćwiczenie 2';
str2 = 'laboratorium 1';
str3 = strvcat(str0,str2);

sent = ['Krasnoludy przeszły przez rzekę w bród, nie zamoczywszy' ... 
    'swych bród i do tego zmywszy ze swych nóg brud'];
reg = 'br[^u].*d';
str1 = regexp(sent, reg);


arr1 = {123 'abc'; R 0.1};
arr1{2,1} = arr1{2,1}.*100 ;

syms x
y = x.^2 - 2.*x + 4;
integ = int(y);
fplot(integ,[0 2])

nazwisko = {'Rafał';'Monika';'Paweł';'Elżbieta';'Mirek'};
matematyka = randi(100,[1,5])';
fizyka = randi(100,[1,5])';
chemia = randi(100,[1,5])';
T = table(nazwisko,matematyka,fizyka,chemia);
writetable(T,'wyniki.csv');
