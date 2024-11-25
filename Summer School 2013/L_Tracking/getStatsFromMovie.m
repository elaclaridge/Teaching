function [STATS]=getStatsFromMovie(M,frame)
% Get statistics from movie M, frame frame

%-- Extract single image

I=M(frame).cdata;
figure; imshow(I)

%-- Threshold
IG=mat2gray(I);
IT=im2bw(IG,0.8); 
figure; imshow(IT)

%-- Label
[L num]=bwlabel(IT);
num
%imshow(L)

%-- Erode
SE=strel('diamond',3)  % Structuring element
IT1=imerode(IT,SE);    % Erode
%figure; imshow(IT1)

[L1 num]=bwlabel(IT1);
num
L2=imdilate(L1,SE);    % Dilate
%figure; imshow(L2)     % Cells now separated

Lrgb = label2rgb(L2);  % Display with pretty colours
%figure; imshow(Lrgb);

STATS = regionprops(L2, 'all'); % Get properties for each region
end