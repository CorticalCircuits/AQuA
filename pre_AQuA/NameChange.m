%% Startup
close all; clear;
thispath = fileparts(which(mfilename));
addpath(genpath(thispath)); % add subfolders to path

filepath = 'C:\Users\tomsu\Documents\GitHub\AQuA Data\AQuA Processed\Cell Batches\Cell11 Processed';
addpath(genpath(filepath));
fileInfo = dir(filepath);
cell = 'cell11';

for n = 1:numel(fileInfo)
    if fileInfo(n).isdir ~= 1
        del = strfind(fileInfo(n).name , cell);
        if numel(del) >= 2
            newname = fileInfo(n).name;
            newname(1:del(2)-1) = [];
            movefile([filepath,'\',fileInfo(n).name]...
                , [filepath,'\',newname]);
            fprintf('File %i out of %i renamed\n' , n , numel(fileInfo));
        end
    end
end



