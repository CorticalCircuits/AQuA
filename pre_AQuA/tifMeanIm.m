%% Path and File Names
clearvars; close all; clc;
vidNames = {'TSeries-04082015-1027_EpOriRand_site2_0.8ISO_128um_2Hz-000_ALGoodTrials.tif',...
    'TSeries-04132015-1532_EpOriRand_site1_Astro1_4Hz_0.75ISO-000_ALGoodTrials.tif'}; %Names of videos to be averaged
savePath = 'C:\Users\tomsu\Documents\GitHub\AQuA Data\AQuA Raw\TrialMnIm';

%% Generation of Directory
if ~isfolder(savePath)
    mkdir(savePath);
end

%% Image Reading and Averaging
for j = 1:length(vidNames)
    count = 1;
    for k = 1:4:101 %Frames to be averaged (keep low for code efficiency
        Im(:,:,count) = imread(vidNames{j} , k);
        count = count + 1;
    end

    MnIm = uint8(mean(Im,3));
    imwrite(MnIm , fullfile(savePath,['OnlyMean - ',vidNames{j}]));
    for ii = 1:14
        imwrite(MnIm , fullfile(savePath,['OnlyMean - ',vidNames{j}]),...
            'WriteMode' , 'append');
    end
end
% imshow(MnIm);