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
paths = {'C:\Users\Coter027\Documents\CellsToProcess\Cell5'};

% add {cell,landmark} boundaries for same cell in same row in that order
cellbound = {'BoundMask-cell5_Cell.mat','BoundMask-cell5_LandMark.mat';
    'BoundMask-cell5_Cell.mat','BoundMask-cell5_LandMark.mat';
    'BoundMask-cell5_Cell.mat','BoundMask-cell5_LandMark.mat';
    'BoundMask-cell5_Cell.mat','BoundMask-cell5_LandMark.mat';
    'BoundMask-cell5_Cell.mat','BoundMask-cell5_LandMark.mat';
    'BoundMask-cell5_Cell.mat','BoundMask-cell5_LandMark.mat';
    'BoundMask-cell5_Cell.mat','BoundMask-cell5_LandMark.mat';
    'BoundMask-cell5_Cell.mat','BoundMask-cell5_LandMark.mat';
    'BoundMask-cell5_Cell.mat','BoundMask-cell5_LandMark.mat'};

for Trial = 1:length(paths)
    fprintf('############################### Batch Number %i ############################### \n', Trial);
    T_aqua_cmd_batch
end