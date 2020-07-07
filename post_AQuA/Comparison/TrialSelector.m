%% Loading and Extraction
% Choose multiple .mat files to compare critical data between them
clear T

imageSavePath = 'Z:\AQuA Data\Figures and Images\HotSpot Data\cell3';
if ~isfolder(imageSavePath)
    mkdir(imageSavePath)
end
paths = uipickfiles;
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

hotSpotAll(T(n).res , imageSavePath , names{n});
hotSpotMove(T(n).res , imageSavePath , names{n});

rmpath(p)
end
clear dummy
