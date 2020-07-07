%% Path and File Names
% Add masks. Cell outside

clearvars; close all; clc;
searchPath = 'Z:\AQuA Data\Raw Data';
dirNames = dir([searchPath , '\cell*']); % Search paths with names cell1 , cell2...
savePath = 'Z:\AQuA Data\Raw Data\FullMasks';

%% Generation of Directory
if ~isfolder(savePath)
    mkdir(savePath);
end


%% Image Reading and Averaging
count = 1;
incongruent = cell(0);
for j = 1:length(dirNames)
    thisFile = fullfile(dirNames(j).folder,dirNames(j).name);
    filename = dir([thisFile , '\*.mat']);
    load(fullfile(thisFile , filename.name));
    if size(cellMask) ~= size(somaMask)
        somaMask = imresize(somaMask , size(cellMask));
        incongruent{count} = dirNames(j).name;
        count = count+1;
    end
    
    MaskIm = uint8(double(cellMask) + somaMask);
    imwrite(MaskIm , fullfile(savePath,['BoundMask-' , dirNames(j).name,'.tif']));
    for ii = 1:14
        imwrite(MaskIm , fullfile(savePath,['BoundMask-' , dirNames(j).name,'.tif']),...
            'WriteMode' , 'append');
    end
    clear filename
    fprintf('File %i Saved out of %i' , j , length(dirNames));
end
% imshow(MnIm);