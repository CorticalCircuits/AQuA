%% Paths and File Names
clearvars; clc;
path1 = 'Z:\AQuA Data\Processed Data\Batches V1.1\cell5Crp'; %Path folder with AQuA output
cd(path1);
files = [dir('**/*.mat') , dir('**/*.tif') , dir('**/*.xlsx')]; %Find all files with mat, tif and xlsx extension

%% File Relocation
for j = 1:numel(files) %go trhough every file discovered with the dir command
    movefile(fullfile(files(j).folder , files(j).name) , fullfile(path1 , files(j).name));
    fprintf('File %i out of %i Relocatied\n' , j , numel(files));
end