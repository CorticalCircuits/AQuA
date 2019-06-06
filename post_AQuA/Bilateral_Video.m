clear; clc; close all;

filename = 'Propagation_3_4'; % Choose the name of the file to be saved
saving_option = 1; % Choose saving option 1 to save the .mat file
stc = struct;

% Names of the Tiff files to compare
% Note: Have to be same amount of frames (i.e. same video)
stc(1).name = 'TSeries-08312015-EpiOri180deg4on12off-Site2-area2-Ast1-9x-4Hz-ISO0.5-V1-000_Propagation3';
stc(2).name = 'TSeries-08312015-EpiOri180deg4on12off-Site2-area2-Ast1-9x-4Hz-ISO0.5-V1-000_Propagation4';
% Make sure files are in MATLAB's path

for j=1:2
stc(j).name = strcat(stc(j).name,'.tif');
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