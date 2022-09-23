%% Batch Setup

close all
clearvars
startup;  % initialize

%% Path for AQuA

AQuA_path = 'C:\Users\coter027\Documents\CellsToProcess\ZscoreTest_2022\';
addpath(genpath(AQuA_path));

%% Folder Path for each folder containing TIF
% Each Respective folder must contain the same cell movie file copied.
% All folders need to have the same number of copies of the file

% add the path for each folder with tiff movies, one folder per row
paths = {
    'C:\Users\coter027\Documents\CellsToProcess\ZscoreTest_2022\Cell6\';
    'C:\Users\coter027\Documents\CellsToProcess\ZscoreTest_2022\Cell8\';
    'C:\Users\coter027\Documents\CellsToProcess\ZscoreTest_2022\Cell11\';
    };
% 'C:\Users\coter027\Documents\CellsToProcess\ZscoreTest_2022\Cell3\';
%     'C:\Users\coter027\Documents\CellsToProcess\ZscoreTest_2022\Cell4\'

%% Adding The Boundary and Landmark of the Cell
% add {cell,landmark} boundaries for Folder in same row
% Rows must be in same order as the Paths in section above
cellbound = {
% 'cell3_Cell.mat','cell3_Landmark.mat';
% 'cell4_Cell.mat','cell4_Landmark.mat';
'cell6_Cell.mat','cell6_Landmark.mat';
'cell8_Cell.mat','cell8_Landmark.mat';
'cell11_Cell.mat','cell11_Landmark.mat';};

%% Adding spatial resolution for each cell
% Add the spatial resolution for each Folder from XML file to the vector in same order as
% above
% SpatialRes = [.4345 .326 .1935 .3265 .281];
SpatialRes = [.1935 .3265 .281];

%% Adding Frame rate of each cell
%Add the Frame rate of the TIFs of each Folder in same order as above

% FrameRate = [.25 .25 .5 .25 .25];
FrameRate = [.5 .25 .25];



%% Adding MinSize ased of Spatial res to meet specific threshold
% smallestevt is the threshold of how many um event needs to be to meet
% size threhold
smallestevt = 10; % microns
minSizee = round(smallestevt./SpatialRes);



for Trial = 1:length(paths)
    fprintf('*****     Starting Batch Number %i     ***** \n', Trial);
    T_aqua_cmd_batch
    fprintf('*****     Finished Batch Number %i     ***** \n', Trial);
end
