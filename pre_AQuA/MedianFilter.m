%% Selecting Tiff files
% Choose multiple .mat files to compare critical data
clear;
paths = uipickfiles;
if isnumeric(paths)
    error('No file Selected');
end
addpath(genpath('C:\Users\carlo\Research'))
%% Getting Savename of the file
for x = 1:numel(paths)
name = char(paths);
filename(x,:) = name(x,1:58);
savename(x,:) = append(filename(x,:),'MedianFilter.tif');
end
%% Retriving frames from tiff files
for n = 1:numel(paths)
    
    [~,name,ext] = fileparts(paths{n});
    filename = strcat(name,ext);
    info = imfinfo(filename);    
    
    for k = 1:length(info) % Read entire snippet
        frames(:,:,k) = medfilt2(imread(filename,k));
        imwrite(frames(:,:,k),savename(n,:),'writemode','append');
    end
end