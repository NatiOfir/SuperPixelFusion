clc;
%clear;
close all;
dbstop if error;
%% Read Images
folder = 'nirscene1';
sub_folder = 'street';
%idx = 43;
%sub_folder = 'country';
idx = 1;

nir = im2double(imread('0001_nir.tiff'));
rgb = im2double(imread('0001_rgb.tiff'));
gray = rgb2gray(rgb);

figure();
subplot(1,2,1);
imshow(nir);
imwrite(nir, sprintf('%d_nir.png',idx));
title('NIR')
subplot(1,2,2);
imshow(rgb);
imwrite(rgb, sprintf('%d_rgb.png',idx));
title('RGB');

%% Alpha Blending
blending = 0.5*nir+0.5*gray;
figure();
subplot(1,2,1);
imshow(blending);
imwrite(blending, sprintf('%d_blending.png',idx));
title('Blending');

ratio = blending./gray;
blending_rgb = ratio.*rgb;
subplot(1,2,2);
imshow(blending_rgb);
imwrite(blending_rgb, sprintf('%d_blending_rgb.png',idx));
title('Blending RGB');

%% Superpixel Segmentation
[L_nir, NumLabels_nir] = superpixels(nir,100);
[L_gray, NumLabels_gray] = superpixels(gray,100);
h = figure();
subplot(1,2,1);
imagesc(L_nir);
title('Super Pixels NIR');
subplot(1,2,2);
imagesc(L_gray);
title('Super Pixels Gray');
print(h,'-dpng', sprintf('%d_sp.png',idx));


%% Compute Grades
g_nir = getGrades(nir, L_nir, NumLabels_nir);
g_gray = getGrades(gray, L_gray, NumLabels_gray);

h = figure();
subplot(1,2,1);
imagesc(g_nir);
title('Grades NIR');
subplot(1,2,2);
imagesc(g_gray);
title('Grades Gray');
print(h,'-dpng', sprintf('%d_grades.png',idx));

%% Compute Maps
mask = normalize(sigmoid(g_nir-g_gray));
mx = imfilter(mask,[1 -1]);
my = imfilter(mask,[1,-1]');
G = sqrt(mx.^2+my.^2);
figure();
imagesc(G);
title('Gradients');

%mask.*g_nir+(1-mask).*g_gray
figure();
subplot(1,2,1);
imshow(mask);
imwrite(mask, sprintf('%d_mask.png',idx));
title('Mask');
mask_fusion = mask.*nir+(1-mask).*gray;
subplot(1,2,2);
imshow(mask_fusion);
imwrite(mask_fusion, sprintf('%d_mask_fusion.png',idx));
title('Mask Fusion');

%% Blend
pyr_blending = blend(nir,gray,mask);
figure();
subplot(1,2,1);
imshow(mask_fusion);
title('Mask Blending');
subplot(1,2,2);
imshow(pyr_blending);
imwrite(pyr_blending, sprintf('%d_pyr_blend.png',idx));
title('Pyr Blending');

%% Blend RGB
figure();
subplot(1,2,1);

subplot(1,2,1);
imshow(blending_rgb);
title('Blending RGB');
subplot(1,2,2);
ratio = pyr_blending./gray;
pyr_blending_rgb = ratio.*rgb;
imshow(pyr_blending_rgb);
imwrite(pyr_blending_rgb, sprintf('%d_fusion.png',idx));
title('Pyr Blending RGB');

%% Plot
figure();
subplot(1,3,1);
imshow(nir);
title('NIR');
subplot(1,3,2);
imshow(pyr_blending_rgb);
title('Fusion');
subplot(1,3,3);
imshow(rgb);
title('RGB');

