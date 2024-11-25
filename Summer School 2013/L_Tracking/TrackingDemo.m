% Motion detection

%% ====================================================
% Displacement in cell images

%-- Read movie
clear all; close all

M=aviread('whole-P-sel.avi');
fileinfo = aviinfo('whole-P-sel.avi');

%-- Extract two images
I1=M(38).cdata;
figure; imshow(I1); title('Frame 38');
I2=M(40).cdata;
figure; imshow(I2); title('Frame 40');

%----- Show subtraction

S=I1-I2;
figure; imshow(S); title('Difference between Frame 38 and frame 40');
T=uint8(d_threshold(S,80,256));
figure; imshow(T,[]);  title('Thresholded difference image');

boundaries = bwboundaries(T);
figure(1);
hold on;
for i=length(boundaries)
    plot(boundaries{i}(:,2),boundaries{i}(:,1),'r','LineWidth',2);
end

%% ====================================================
% Labelling

clear all; close all
%-- Read movie
M=aviread('whole-P-sel.avi');

%-- Extract single image
i=16;
I=M(16).cdata;
figure; imshow(I)

%-- Threshold
IG=mat2gray(I);
IT=im2bw(IG,0.8);   %See C=colormap; 0.8 ~ 205
figure; imshow(IT)

%-- Label
[L num]=bwlabel(IT);
num
imshow(L)

%-- Erode
SE=strel('diamond',3)  % Structuring element
IT1=imerode(IT,SE);    % Erode
figure; imshow(IT1)

[L1 num]=bwlabel(IT1);
num
L2=imdilate(L1,SE);    % Dilate
figure; imshow(L2)     % Cells now separated

Lrgb = label2rgb(L2);  % Display with pretty colours
figure; imshow(Lrgb);

STATS = regionprops(L2, 'all'); % Get properties for each region

% Extract coordinates of all the centroids
for i=1:size(STATS,1)
    C(i,:)=STATS(i).Centroid;
end

% get info from movie file

%% =====================================================
% Flow field

STATS1=getStatsFromMovie(M,38);
STATS2=getStatsFromMovie(M,40);

for i=1:size(STATS1,1)
    X(i)=STATS1(i).Centroid(1);
    Y(i)=STATS1(i).Centroid(2);
    U(i)=STATS2(i).Centroid(1)-STATS1(i).Centroid(1);
    V(i)=STATS2(i).Centroid(2)-STATS1(i).Centroid(2);
end

% Visualisation

I1=M(38).cdata;
I2=M(40).cdata;

figure; imshow(I1);
hold on
h=imshow(I2,gray(256));
set(h,'AlphaData',0.5);
hold on
quiver(X,Y,U,V,0,'Color','red','LineWidth',1);




%% ==========================================================

% Fourier domain detection through cross-correlation
im=imread('cells_G.tif');
I1=im(100:356,130:130+256);
I2=im(80:336,130:130+256);
clear im;
figure; imshow(I1)
figure; imshow(I2)

%-- FT
F1=fft2(double(I1));
F2=fft2(double(I2));

figure; imshow(log(abs(fftshift(F1))),[]); colormap('jet');
figure; imshow(log(abs(fftshift(F2))),[]); colormap('jet');

%-- Compute cross-spectrum (Correlation with complex conjugate)
C=F1.*conj(F2);

figure; imshow(log(abs(fftshift(C))),[]); colormap('jet');

%-- Inverse FT of the cross-spectrum
%CI=ifft2(C);
CI=fftshift(ifft2(C));

figure; imshow(CI,[]);
figure; surf(CI);

%--- Compute the displacement

%------ Find the location of the maximum (function argmax)
[my mx] = find(CI==max(max(CI)))

%------ Find the location of the transform's (0,0)
[y x]=size(C);
cx=int16(x/2)
cy=int16(y/2)

%------ Displacement
dx=mx-cx
dy=my-cy

%% ======================================================================

% Displacement in cell images

%-- Read movie
M=aviread('whole-P-sel.avi');

%-- Extract two images
I1=M(37).cdata;
figure; imshow(I1)
I2=M(38).cdata;
figure; imshow(I2)

%----- Show subtraction

%----- Continue cross-correlation as above


%% ====================================================
% Feature detection via cross-correlation
%-- Extract a single cell (a template)
T=I1(177:208,119:158);
figure; imshow(T);
F2=fft2(double(T),514,722);
%----- Continue cross-correlation as above


