% Unit 2
%% Back-projections

K=[1 1 0 0;
0 0 1 1;
1 0 1 0;
0 1 0 1;
1 0 0 1
0 1 1 0]

b=([7 7 6 8 5 9])'

a = inv(K'*K) * K' * b
permute(reshape(a,2,2),[2 1])


%% Projections, Radon transform, Fourier transform
%
% Read a phantom image
X=imread('phantom_2.tif');
X=double(X);


% Fourier transform

F1=fft2(X);     % Fourier transform, non-optical
figure; surf(real(F1)^2+imag(F1)^2);     % Surface display, power spectrum

F=fft2(X,128,128);  % Padded FT
F2 = fftshift(F);   % Fourier transform, optical
figure; surf(real(F2)^2+imag(F2)^2);     % Surface display, power spectrum


% Radon transform

[R,xp] = radon(X,[0 90]);    % the angles of the transform

% Compute Fourier transform of 0 and 90 degrees
FR0=fft(R(:,1),128);    % Padded FT
FR02=fftshift(FR0);     % Optical
FR90=fft(R(:,2),128);    % Padded FT
FR902=fftshift(FR90);     % Optical

% Compare by display
figure; plot(-64:63,conj(F2(:,65)));
hold on
plot(-64:63,conj(FR02),'red');

% Compare zero frequency
F2(65,65)
FR02(65)

%% Matlab demo
iptsetpref('ImshowAxesVisible','on')
% X = zeros(100,100);
% X(25:75, 25:75) = 1;

% Read a phantom image
X=imread('phantom256.tif');
X=double(X);
figure; imshow(imresize(X,2),[])

theta = 0:15:180;
[R,xp] = radon(X,theta);
figure; imshow(R,[],'Xdata',theta,'Ydata',xp,...
            'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('x''')
colormap(hot), colorbar
iptsetpref('ImshowAxesVisible','off')

I = iradon(R, theta);
figure; imshow(imresize(I,2),[])


