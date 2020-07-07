%% Path to Res file of Cell
paths = uipickfiles;
tic
%% Selecting Landmark and Invading Event Index
whicchLandmark = 1;%Set as Soma to define the direction scores
whichevt = [1:10]; %Events to visualize, if want multiple for one mat file then put the array here of evt #
forlooper = numel(whichevt)
% %% Vid maker for loop set for multiple mat files
% for n = 1:numel(paths)
%     whichevt = whichevt(n) %% if multiple events for one mat file then change numel(paths) to numel(whichevt)
%     load(paths{n}) %% Comment this out and load single res file if only working with one mat file
%     AstroVidMaker
%     close all
% end

%% Vid maker for loop set for single mat files
for n = 1:forlooper
load(paths{1})
    whichevt = n %% if multiple events for one mat file then change numel(paths) to numel(whichevt)
    AstroVidMaker
    close all
end
toc