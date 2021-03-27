%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%傅里叶变换测试
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clc;  
    close all;  
    clear;
    i=3;
    tic;
    %A=['测试\',num2str(i)];
    I1=imread([num2str(i),'\1.jpg']);  
    
    II=rgb2gray(I1);
    
    
    II=double(II)/max(max(double(II)));
    maxII=max(max(II));
    %II=zeros(100,100);
    %II=II+1;
    
    figure(1);
    imshow(II);
    
    aaa=fft2(double(II));
    figure(2);
    imshow(aaa);
    aaamax=max(max(aaa));
   
   
    III=ifft2(aaa);
    figure(3);
    imshow(III);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%维纳滤波测试
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %————读入图片
% i=1;
% I = im2double(imread([num2str(i),'\1.jpg']));
% 
% %————添加运动模糊————
% LEN = 21;
% THETA = 11;
% PSF = fspecial('motion', LEN, THETA);
% blurred = imfilter(I, PSF, 'conv', 'circular');%添加运动模糊后的图像
% figure(1);
% imshow(blurred);
% 
% 
% %————图像维纳复原
% wnr1 = deconvwnr(blurred, PSF, 0);
% subplot(2,3,3),imshow(wnr1);
% title('Restored Image');
% 
% %Simulate blur and noise
% noise_mean = 0;
% noise_var = 0.0001;
% blurred_noisy = imnoise(blurred, 'gaussian', ...
%                         noise_mean, noise_var);
% subplot(2,3,4),imshow(blurred_noisy)
% title('Simulate Blur and Noise')
% 
% %Restore the blurred and noisy image:First attempt
% wnr2 = deconvwnr(blurred_noisy, PSF, 0);
% subplot(2,3,5);imshow(wnr2);title('Restoration of Blurred, Noisy Image Using NSR = 0')
% 
% %Restore the Blurred and Noisy Image: Second Attempt
% signal_var = var(I(:));
% wnr3 = deconvwnr(blurred_noisy, PSF, noise_var / signal_var);
% subplot(2,3,6),imshow(wnr3)
% title('Restoration of Blurred, Noisy Image Using Estimated NSR');