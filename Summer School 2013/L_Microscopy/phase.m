% Phase demo
clear all; close all;
t1=imread('fourier.tif');
t2=imread('phantom256.tif');
f1 = fft2(double(t1));
a1 = angle(f1);   % computes phase on complex data
m1 = abs(f1);     % abs on complex data is equivalent to real(F1)^2+imag(F1)^2
f2 = fft2(double(t2));
a2 = angle(f2);
m2 = abs(f2);

% Mixing 
%-- Magnitude alone
z=double(zeros(256,256));
f3=complex(m1.*cos(z), m1.*sin(z) );
t3=ifft2(f3);
% figure; imshow(log(abs(t3)),[]); title('Amplitude of fig 1 alone');

%-- Phase alone
o=ones(256,256);
f4=complex(o.*cos(a1), o.*sin(a1) );
t4=ifft2(f4);
% figure; imshow(abs(t4),[]); title('Phase of fig 1 alone');

%-- Mixture
f5=complex(m1.*cos(a2), m1.*sin(a2) );
f6=complex(m2.*cos(a1), m2.*sin(a1) );
t5=ifft2(f5);
t6=ifft2(f6);
% figure; imshow(abs(t5),[]); title('Amplitude of fig 1, phase of fig 2');
% figure; imshow(abs(t6),[]); title('Amplitude of fig 2, phase of fig 1');

subplot(5,2,1); imshow(t1,[]); title('Fig 1');
subplot(5,2,2); imshow(log(double(t2)),[]); title('Fig 2');
subplot(5,2,3); imshow(log(fftshift(m1)),[]); title('Power spectrum fig 1');
subplot(5,2,4); imshow(log(fftshift(m2)),[]); title('Power spectrum  fig 2');
subplot(5,2,5); imshow(a1,[]); title('Phase of fig 1');
subplot(5,2,6); imshow(a2,[]); title('Phase of fig 2');
subplot(5,2,7); imshow(log(abs(t3)),[]); title('Magnitude fig 1');
subplot(5,2,8); imshow(abs(t4),[]); title('Phase fig 1');
subplot(5,2,9); imshow(abs(t5),[]); title('Amplitude fig 1, phase  fig 2');
subplot(5,2,10); imshow(abs(t6),[]); title('Amplitude fig 2, phase fig 1');


