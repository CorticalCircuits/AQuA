%% Batch Setup

close all
clearvars
startup;  % initialize

% Path for AQuA
AQuA_path = fileparts(which(mfilename));
addpath(genpath(AQuA_path));

% All folders must contain the same cell movie file copied.
% All folders need to have the same number of copies of the file

% add the path for each folder with tiff movies, one folder per row
paths = {'C:\Users\tomsu\Documents\GitHub\AQuA Data\BatchTest' ; ...
    'C:\Users\tomsu\Documents\GitHub\AQuA Data\SuperBatch'};

% add landmark and cell boundaries for same cell in same row
boundary = {'TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrials_Cell.mat' , ...
    'TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrialsLandMark.mat' ; ...
    'TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrials_Cell.mat' , ...
    'TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrials_Cell.mat'};

for Trial = 1:length(paths)
    fprintf('############################### Batch Number %i ############################### \n', Trial);
    T_aqua_cmd_batch
end