clear all
videoObject = VideoReader("./video.avi");
thisFrame = read(videoObject, 1);
imwrite(thisFrame, 'frame2.jpg')

videoObject = VideoReader("./video2.avi");
thisFrame = read(videoObject, 1);
imwrite(thisFrame, 'frame4.jpg')

detector = vision.CascadeObjectDetector();
RGB = imread('frame2.jpg');
bboxes = detector(RGB);
liczbaWykrytychTwarzy = size(bboxes,1)


GRAY=rgb2gray(RGB);
corners = detectMinEigenFeatures(GRAY);
corners
figure; imshow(RGB)
hold on; plot(corners.selectStrongest(50))

corners2 = detectMinEigenFeatures(GRAY, 'ROI', bboxes(1, :));
xyPoints = corners2.Location;
bboxPoints = bbox2points(bboxes(1, :));
bboxPolygon = reshape(bboxPoints', 1, []);

RGB2 = insertShape(RGB, 'Polygon', bboxPolygon, 'LineWidth', 3);
RGB2 = insertMarker(RGB2, xyPoints, '+', 'Color', 'white');
figure; imshow(RGB2)