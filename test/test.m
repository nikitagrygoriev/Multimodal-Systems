A = readmatrix('matrix2.txt');

m = reshape(A, 512,424);

m(m==0) = 2500;

mesh(m);


