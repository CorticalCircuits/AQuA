%% Paths and File Names
clearvars; clc;
file2copy = 'TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrials.tif'; %Name of target file (with extension)
path1 = 'X:\AQuA Data\Raw Data\Cropped Stacks\GoodTrialsNEW'; %Path to the file
[~ , name , ext] = fileparts(file2copy);
path2 = 'C:\Users\Coter027\Documents\CellsToProcess\Cell13'; %Target path where the file will be copied

%% Generation of Directory
if ~isfolder(path2)
    mkdir(path2);
end

%% Copy Generation
copies = 5; % Number of repetitions of file in same folder
for j = 1:copies
    newFileName = [name , '_' , num2str(j) , ext];
    copyfile(fullfile(path1 , file2copy) , fullfile(path2 , file2copy));
    movefile(fullfile(path2 , file2copy) , fullfile(path2 , newFileName));
    fprintf('File %i out of %i Copied\n' , j , copies);
end
