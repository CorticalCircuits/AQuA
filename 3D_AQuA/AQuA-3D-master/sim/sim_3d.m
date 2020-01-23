%% Simulate 3D events

% set path, file names, and parameters
f0 = './cfg/cell3d.mat';  % input .mat file for the extracted cell
pOut = './output/data001/';  % output folder for synthetic movie
mOut = './output/data001.mat';  % output .mat file for event list

nameOut = 'test_';  % prefix for each TIFF file

T = 150;  % total frame number
nEvtsLarge = 20;  % number of larger events
nEvtsSmall = 50;  % number of smaller events

%% load cell
s = load(f0);
dat = s.vidx1;

% clean the morphology
template = dat(1:2:end,1:2:end,:);
templateMsk = template>0;
templateMsk = imerode(templateMsk,strel('square',3));
for dd=1:size(templateMsk,3)
    xx = templateMsk(:,:,dd);
    templateMsk(:,:,dd) = bwareaopen(xx,25);
end


%% growing type propagation
[H,W,D] = size(template);
eventsMovie = zeros(H,W,D,T,'uint8');
labelMovie = zeros(H,W,D,T,'uint16');
allowMap = true(size(eventsMovie));

% add larger events
[labelMovie,eventsMovie,allowMap] = addEvents3D(...
    labelMovie,eventsMovie,allowMap,nEvtsLarge,template,templateMsk,0,1);

% add smaller events
kNow = max(labelMovie(:))+1;
[labelMovie,eventsMovie,allowMap] = addEvents3D(...
    labelMovie,eventsMovie,allowMap,nEvtsSmall,template,templateMsk,1,kNow);

%% export for Vaa3D
datOut = uint8(template*255*0.5)+eventsMovie*0.2;

if ~exist(pOut,'dir')
    mkdir(pOut)
end
writeTiff5D(datOut,[],pOut,nameOut,0.03);

evtLst = label2idx(labelMovie);
sz = size(eventsMovie);
save(mOut,'evtLst','sz');











