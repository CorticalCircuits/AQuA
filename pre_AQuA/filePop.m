%% Paths and File Names
clearvars; clc;
file2copy = 'cell11.tif'; %Name of target file (with extension)
path1 = 'Z:\Student Access\AQuA Data\Raw Data\Original Stacks\cell11'; %Path to the file
[~ , name , ext] = fileparts(file2copy);
path2 = 'C:\Users\coter027\Documents\CellsToProcess\Batch2\cell11'; %Target path where the file will be copied

%% Generation of Directory
if ~isfolder(path2)
    mkdir(path2);
end

%% Copy Generation
copies = 9; % Number of repetitions of file in same folder
for j = 1:copies
    newFileName = [name , '_' , num2str(j) , ext];
    copyfile(fullfile(path1 , file2copy) , fullfile(path2 , file2copy));
    movefile(fullfile(path2 , file2copy) , fullfile(path2 , newFileName));
    fprintf('File %i out of %i Copied\n' , j , copies);
end
