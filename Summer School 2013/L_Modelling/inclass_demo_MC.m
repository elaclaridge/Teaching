close all;
clear all;

% Read in all the model data
% Ensure that the files are in the current directory; else modify the filename
load absCoe % haemAbsCoe oxyHaemAbsCoe emelAbsCoe pmelAbsCoe epiDerAbsCoe papDerAbsCoe absBLCoe
load scatCoe % epiDerScatCoe papDerScatCoe retDerScatCoe
load skinNDG % refIndex dLayer gLayer

Wavelengths=300:50:800;

% Display
figure; hold on
plot(haemAbsCoe(:,1),haemAbsCoe(:,2),'m');
plot(oxyHaemAbsCoe(:,1),oxyHaemAbsCoe(:,2),'r')
title('Absorption coefficients for haemoglobins');
legend('Hb','HbO');

figure; hold on
plot(emelAbsCoe(:,1),emelAbsCoe(:,2),'m')
plot(pmelAbsCoe(:,1),pmelAbsCoe(:,2),'r')
title('Absorption coefficients for melanins')
legend('euM','phM');

figure; hold on
plot(epiDerScatCoe(:,1),epiDerScatCoe(:,2),'b')
plot(papDerScatCoe(:,1),papDerScatCoe(:,2),'c')
title('Scatter coefficients for skin layers')
legend('Epidermis','Dermis');

pause()

% Specify parameters in physiological ranges
% Below are just examples, choose values as appropriate
emel=0.0030;
melBal=0.4;
bvf=0.0100;
dpd=0.050;

% === Specify optical properties of the layers ===

% Epidermis coefficients
absEM   =  emelAbsCoe(:,2)*melBal + pmelAbsCoe(:,2)*(1-melBal);
absEL   =  epiDerAbsCoe(:,2);
scatE  =   epiDerScatCoe(:,2);

% Papillary dermis coefficients
haeglobBal=0.7;
absDB      = oxyHaemAbsCoe(:,2)*haeglobBal + haemAbsCoe(:,2)*(1.0-haeglobBal);
absDL      = papDerAbsCoe(:,2);
scatPD     = papDerScatCoe(:,2);

% Reticular Dermis coefficients
absRD   = 0.8*oxyHaemAbsCoe(:,2)*haeglobBal + haemAbsCoe(:,2)*(1.0-haeglobBal);
scatRD  = retDerScatCoe(:,2);

% Baseline absorption coefficient
absBL  = epiDerAbsCoe(:,2); 

% === Package data for MC and run ===

nLayers=3; % Epidermis, Papillary Dermis, reticular dermis

% Set the absorption and scattering coefficients for each layer
abs{1} = emel*absEM + absEL;
abs{2} = bvf*absDB + absDL;
abs{3} = absRD;
scat{1} = scatE;
scat{2} = scatPD;
scat{3} = scatRD;

% Plot
figure; hold on
plot(Wavelengths, abs{1},'r')
plot(Wavelengths, abs{2},'g')
plot(Wavelengths, abs{3},'b')
title('Total absorption coefficients');
legend('Epidermis','Dermis','Ret. Dermis');

figure; hold on
plot(Wavelengths, scat{1},'r')
plot(Wavelengths, scat{2},'g')
plot(Wavelengths, scat{3},'b')
title('Total scatter coefficients');
legend('Epidermis','Dermis','Ret. Dermis');

pause()

% Package values of variable parameters
par=[emel melBal bvf dpd];

% Compute MC outputs
mco = skinMCL(Wavelengths,par,nLayers,abs,scat,refIndex,dLayer,gLayer);

% === Inspect / analyse the data ====

% As an example display absorption of each layer as a function of wavelength
for iw=1:length(Wavelengths)
    layerAbs(iw,:)=mco{iw}.layerAbs;
end
plot(Wavelengths,layerAbs,'b'); title('Absorption per layer');

display('Look at mco ...');




