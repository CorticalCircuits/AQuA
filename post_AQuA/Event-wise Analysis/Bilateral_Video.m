%clear; clc; close all;

filename = 'Poster'; % Choose the name of the file to be saved
saving_option = 0; % Choose saving option 1 to save the .mat file
stc = struct;
% p = ['E:\AQuA\Output\TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrials'];
p = ['C:\Users\tomsu\Documents\GitHub\AQuA Data\AQuA Processed\dataSnip27\'];

% Names of the Tiff files to compare
% Note: Have to be same amount of frames (i.e. same video)
% stc(1).name = 'TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrialssmooth1_AQuA';
% stc(2).name = 'TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrialssmooth4_AQuA';
stc(1).name = 'dataSnip27_Propagation1';
stc(2).name = 'dataSnip27_Propagation3';
% Make sure files are in MATLAB's path

for j=1:2
stc(j).name = strcat(p,stc(j).name,'.tif');
stc(j).info = imfinfo(stc(j).name);
stc(j).numframe = length(stc(j).info);
end

if stc(1).numframe > stc(2).numframe
    num = stc(2).numframe;
else
    num = stc(1).numframe;
end

for K = 1 : num
%     rawframes_1(:,:,:,K) = imread(stc(1).name, K);
    rawframes_1 = imread(stc(1).name, K);
    rawframes_2 = imread(stc(2).name, K);
    newframes(:,:,:,K) = [rawframes_1,rawframes_2];
end

cookedframes = mat2gray(newframes);
implay(cookedframes);

if saving_option == 1
    save(filename,'cookedframes','-v7.3');
    disp('#### File Saved ####');
else
    disp('#### File has not been Saved ####');
end