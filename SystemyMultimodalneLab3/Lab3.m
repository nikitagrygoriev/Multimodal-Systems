addpath('BazaObrazow')

detect('testowy_0_0000.jpeg')

detect('testowy_1_0003.jpeg')

detect('testowy_4_0002.jpeg')



% testowy = imread('testowy_2_0004.jpeg');
% faceDetector = vision.CascadeObjectDetector('ProfileFace');
% bbox = step(faceDetector, testowy)
% Out = insertObjectAnnotation(testowy,'rectangle',bbox,'Face');
% figure, imshow(Out), title('Face Detection');