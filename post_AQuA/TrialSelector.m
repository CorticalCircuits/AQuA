%% Function Selection
% Choose multiple .mat files to compare critical data
clear T; close all;
path_temp = fileparts(which(mfilename));
addpath(genpath(path_temp));
clearvars path_temp; % Add subfolders to path

paths = uipickfiles('FilterSpec','*.mat');
if isnumeric(paths)
    error('No file Selected');
end

Comparison = 'off';        %Option for comparing number of events and AQuA parameters
HotSpot = 'off';    %Option for Using both General and Moving HotSpots
SomaArea = 'off';    %Option for Getting Soma Area plot
plotEvntRaster = 'off'; %Option for adding plotEvntRaster plots
plotVector = 3; %Plots on EvntRaster that will be processed (Go in code to see which each of 8 plot contains)
SmallEventHistogram ='on';
landmarkFile = 'C:\Users\carlo\Research\Cellstoprocess\cell4_1_LandMark.mat'; %Path and File Name of Landmark MAT File
load(landmarkFile);
imageSavePath = 'C:\Users\carlo\Research\Cellstoprocess\Cell4MedianFilterImages'; %Path to save images generated by hotSpot

%% Loading and Extraction

file_number = numel(paths);
thresh = 50;            % Score threshold for moving events
fl = cell(1 , file_number);
names = cell(1 , file_number);
T(1:file_number) = struct('res',[],'SizeThr',[]);
 
for n = 1:file_number
    [p,names{n},ext] = fileparts(paths{n});
    addpath(p)
    filename = strcat(names{n},ext);
    names{n} = erase(names{n} , '_AQuA');

    dummy = load(filename);
    T(n).res = dummy.res;  % Data from all trials is stored here
    fprintf('File %i out of %i Loaded\n' , n , file_number);

    filename = string(strsplit(filename,'_'));
    filename = strsplit(filename(2),'.');
    fl(n) = {filename(1)};

    if ~isfield(T(n).res,'fts')
        error('Landmark was not selected during Pre-Processing');
    end

    rmpath(p)
%  T(n).SizeThr = SizeThr(T(n).res,0);
    clear dummy
end

%% Function Calling and Use
if ~isfolder(imageSavePath)
    mkdir(imageSavePath)
end

if strcmp(Comparison , 'on') %Comparison function initiation
    trialComp(T,names);
    fprintf('Comparison Done\n');
else
    fprintf('Comparison not Selected\n');
end

if strcmp(HotSpot , 'on') %HotSpot functions initiation
    for n = 1:numel(T)
        hotSpotAll(T(n).res , imageSavePath , names{n});
        hotSpotMove(T(n).res , imageSavePath , names{n});
    end
    fprintf('HotSpots Done\n');
else
    fprintf('HotSpots not Selected\n');
end

if strcmp(SomaArea , 'on') %areaCompare function initiation
    ratio = zeros(numel(T) , 1);
    for n = 1:numel(T)
        ratio(n) = areaCompare(T(n).res , bd0 , 'off' ,imageSavePath , names{n});
    end
    fprintf('Soma Area Done\n');
else
    fprintf('Soma Area not Selected\n');
end

if strcmp(plotEvntRaster , 'on') %Plot Event Raster function initiation
    for n = 1:numel(T)
        Ratios(n,:) = plotEvntFun(T(n).res , plotVector , imageSavePath , names{n});
    end
    fprintf('Plot Events Done\n');
else
    fprintf('Plot Events not Selected\n');
end

if strcmp(SmallEventHistogram , 'on') %Plot Event Raster function initiation
    for n = 1:numel(T)
        SmallEventsHist(T(n).res , bd0 , imageSavePath , names{n});
    end
    fprintf('Small Event Histogram Done\n');
else
    fprintf('Small Event Histogram Selected\n');
end

set(groot,'DefaultFigureVisible','on');
