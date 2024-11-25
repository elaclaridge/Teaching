%% ======================================================

% Manual rigid registration
clear all; close all;
  

base=imread('fish_vis.tif');
figure; imshow(base);
floatingC=imread('fish_cfp.tif');
figure; imshow(floatingC);
pause()

cpselect(floatingC(:,:,2), base);
pause()

base_points
input_points
pause()

TFORM = cp2tform(input_points,base_points,'affine');
TFORM.tdata.T
pause()

registered = imtransform(floatingC,TFORM,...
                          'FillValues', 0,...
                          'XData', [1 size(base,2)],...
                          'YData', [1 size(base,1)]);

% R(:,:,1)=uint8(zeros(size(registered)));
% R(:,:,2)=registered;
% R(:,:,3)=registered;
figure; imshow(registered)
pause()

hold on
h = imshow(base, gray(256));
set(h, 'AlphaData', 0.6);

%% ======================================================

% Automatic affine registration

clear all; close all;

cpd_rigid_example5
cpd_affine_example2

% base=imread('fish_vis.tif'); 
% figure; imshow(base);
% floatingC=imread('fish_cfp_53.tif');
% figure; imshow(floatingC);
% pause()
% 
% base=imresize(base,0.5);
% floatingI=floatingC(:,:,2);floatingI=imresize(floatingI,0.5);
% registered = cpdRegistration2D(floatingI,base,'affine')
% 
% figure; imshow(registered,[]);

%% ======================================================

% Automatic elastic registration

clear all; close all;

mirt2D_example2

% base=imread('fish_vis.tif'); 
% %figure; imshow(base);
% floatingC=imread('Z:\Teach\Summer School\Registration_Prep\FishImageFiles\fish-cfp-53.tif');
% %figure; imshow(floatingC);
% %pause()
% 
% base=imresize(base,0.5); base=(double(base))/max(double(base(:)));
% floatingI=floatingC(:,:,2);
% floatingI=imresize(floatingI,0.5); floatingI=(double(floatingI))/max(double(floatingI(:)));
% 
% registered = mirt2D_MI(floatingI,base,8,10)
% 


