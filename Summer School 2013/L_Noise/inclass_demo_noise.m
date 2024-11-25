% Unit 3_class
%
%% ===============================
% Stripes
clear all; close all;
IV=imread('stripesV.tif');
IV=IV(1:100,1:100);
figure; imshow(IV);

IVW=imread('stripesVW.tif');
figure; imshow(IVW);

ID=imread('stripesD.tif');
ID=ID(35:35+99,35:35+99);
figure; imshow(ID);

I=0.5*ID+0.5*IV;
figure; imshow(I)

figure; mesh(abs(fftshift(fft2(IV))));
%figure; imagesc(abs(fftshift(fft2(IV))));
title('FT Stripes vertical narrow');

figure; mesh(abs(fftshift(fft2(IVW))));
%figure; imagesc(abs(fftshift(fft2(IVW))));
title('FT Stripes vertical wide');

figure; mesh(abs(fftshift(fft2(ID))));
%figure; imagesc(abs(fftshift(fft2(ID))));
title('FT Stripes diagonal');

F=fft2(double(I));
figure; mesh(abs(fftshift(F)));
%figure; imagesc(abs(fftshift(F)));
title('FT Diamond pattern');



% ===============================
%% Gaussian noise
clear all; close all;
% Read a phantom image
X=imread('phantom128.tif');
figure; imshow(imresize(X,2),[]);
XN = imnoise(X,'gaussian',0,0.2);
figure; imshow(imresize(XN,2),[]);

X=double(X);
XN=double(XN);
F=fft2(X);
FN=fft2(XN);
figure; surf(abs(fftshift(F))); ZL=zlim; title('FT Original');
figure; surf(abs(fftshift(FN)));zlim(ZL);  title('FT With noise');



%% Create Gaussian in spatial domain, FFT and convolve in Fourier space
clear all; close all;
X=imread('phantom128.tif');
figure; imshow(imresize(X,2),[]);
X=double(X);
F=fft2(X);

h = fspecial('gaussian',128,5);
H=fft2(h);
G=F.*H;
figure
surf((abs(fftshift(F)))); title('FT Original image');
figure
surf((abs(fftshift(H)))); title('FT Gaussian filter');
figure
surf((abs(fftshift(G)))); title('FT LP Filtered image');
X1=ifftshift(ifft2(G));
figure
imshow(imresize(X1,2),[])



%==================================================
%% Bandpass filter
clear all; close all;
X=imread('phantom128.tif');
figure; imshow(imresize(X,2),[]);
X=double(X);
F=fft2(X);     % Fourier transform, non-optical

[f1,f2] = freqspace(128,'meshgrid');
Hd = ones(128);
r = sqrt(f1.^2 + f2.^2);
Hd((r<0.3)|(r>0.6)) = 0;
figure; mesh(f1,f2,Hd); title('FT HP Filter');
H=fftshift(Hd);
G=F.*H;
figure; surf(abs(fftshift(F))); ZL=zlim; title('FT Original image');
figure; surf(abs(fftshift(G))); zlim(ZL); title('FT HP Filtered image');
X1=ifft2(G);
figure; imshow(imresize(X1,2),[])

%======================================
%% Noise suppression - low-pass filtering
clear all; close all;
% Read a phantom image
X=imread('phantom128.tif');
figure; imshow(imresize(X,2),[]);
XN = imnoise(X,'gaussian',0,0.05);
figure; imshow(imresize(XN,2),[]);
F=fft2(XN);
h = fspecial('gaussian',128,1);
H=fft2(h);
G=F.*H;
figure
surf((abs(fftshift(F))))
figure
surf((abs(fftshift(H))))
figure
surf((abs(fftshift(G))))
X1=ifftshift(ifft2(G));
figure
imshow(imresize(X1,2),[])

figure; plot(X(:,64))
hold on
plot(XN(:,64),'k')
plot(X1(:,64),'r')

%======================================
%% Deconvolution
% --- Using Matlab function
clear all; close all;
X=imread('phantom256.tif');
figure; imshow(X); title('Original undistorted image');
PSF = fspecial('gaussian',7,10);
XB=imfilter(X,PSF);
figure; imshow(XB); title('Blurred image');
X1 = deconvreg(XB,PSF);
figure; imshow(X1); title ('Deconvolved image');
d=abs(X-X1);
figure; imshow(d,[]); title('Difference image');
colormap('jet');












