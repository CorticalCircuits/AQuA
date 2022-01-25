function ratio = SmallEventsHist(res , bd0 , savePath , saveName)
%Extract the percentage of the area of an event inside the landmark Input the AQuA result, landmark structure and event number
if ~exist('res','var') || ~exist('bd0','var')
    error('No res structure or landmark structure found. Load an AQuA mat file and a landmark file to begin');
end

if nargin >= 2; set(0,'DefaultFigureVisible','off');
end

%% Initialize
whichevt = 1:length(res.evt);
coveredSomaArea = zeros(size(res.evt));
insideSomaArea = zeros(size(res.evt));

%% Area Calculation
%Calculates number of shared pixels shared between the trace of an event
%and a frame with only true values (trueFrame) within the borders of
%landmark
count = 1;
landMk = bd0{1}{1}{1};
frameSize = [size(res.datOrg,1) , size(res.datOrg,2)];
frameElement = frameSize(1)*frameSize(2);
for ii = whichevt
    %Find trace of Event
    firstFrame = floor(min(res.evt{(ii)})/frameElement); %First frame of event in movie
    lastFrame = ceil(max(res.evt{(ii)})/frameElement); %Last frame of event in movie
    vidFrames = false(frameSize(1) , frameSize(2) , lastFrame-firstFrame);
    vidFrames(res.evt{(ii)} - firstFrame*frameElement) = true; %Binary movie of event
    trace = logical(sum(vidFrames,3)); %Trace of event (one frame)
    %Area
    [yInd , xInd] = find(trace == true); %x,y indexes of active pixels
    in = inpolygon(xInd,yInd,landMk(:,2),landMk(:,1));
    trueFrame = true(size(trace));%dummy variable for true comparison
    [yTrue , xTrue] = find(trueFrame == true);
    pin = inpolygon(yTrue,xTrue,landMk(:,2),landMk(:,1));
    coveredSomaArea(count) = 100 * numel(find(in==true))/numel(find(pin==true)); %Area of soma covered by an event
    insideSomaArea(count) = 100 * numel(find(in==true))/numel(find(trace==true)); %Area of event inside the soma
    count = count+1;
end
%% Finding events and saving if greater than 25 microns and are inside more than 90 % of Soma
Events = all([res.fts.basic.area<25;coveredSomaArea>2]);
BothEvents = all([insideSomaArea>90;res.fts.basic.area<25;coveredSomaArea>2]);
smallevents = res.fts.basic.area(Events);
sigevents = res.fts.basic.area(BothEvents);

%% Histogram
[N1,Edges1] = histcounts(smallevents,10);
[N2,Edges2] = histcounts(sigevents,10);
%% Figure of histograms
fig = figure;
set(fig, 'Position', get(0, 'Screensize'));
subplot(1,2,1);
histogram(sigevents,10);
title({'Events < 25 um^2';'& 90% inside Soma'});
ylabel('# of events');
xlabel('Area (Microns.^2)');
subplot(1,2,2);
histogram(smallevents,10);
title('All events < than 25 um^2');
ylabel('# of events');
xlabel('Area (Microns.^2)');
if exist('savePath','var') && exist('saveName','var');
    savefig(fig , fullfile(savePath,[saveName,'_SmallEventsHist.fig']));
    saveas(fig , fullfile(savePath,[saveName,'_SmallEventsHist.jpg']));
end