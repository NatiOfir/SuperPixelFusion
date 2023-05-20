clc;
clear;
close all;
dbstop if error;

s = 101;
I = randn(s);
gauss = fspecial('gaussian',[s,s],s/3);
F = imfilter(I, gauss);
F = F-min(F(:));
F = F./max(F(:));
imshow(F>0.5);