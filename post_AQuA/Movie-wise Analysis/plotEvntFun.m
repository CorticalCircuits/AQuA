function Ratios = plotEvntFun(res , plotVector , imageSavePath , saveName)
%% cell-specific parameters (ideally saved with the AQuA data file)
% Use plotVector as a list of plots to be saved
% Add imageSavePath and saveName to save images generated
% Only input res structure to show all possible graphs without saving

if ~exist('cell_stim_db' , 'var')
    if exist('cell_stim_db.mat','file')
        load('cell_stim_db.mat');
    else
        error('Database not found. Include cell stimulus database in Matlab path');
    end
end

if ~exist('plotVector' , 'var')
    plotVector = 1:8;
    set(0,'DefaultFigureVisible','on');
else
   if ~isnumeric(plotVector)
        error('No plot vector input detected');
   end
   set(0,'DefaultFigureVisible','off');
end

cellName = 'cell3';
expNum = sscanf(cellName,'cell%i');

cycleLength = cell_stim_db(expNum).stim.cycleLength;
stimLength = cell_stim_db(expNum).stim.nFrames;
nStims = stimLength/cycleLength;
nBlanks = cell_stim_db(expNum).stim.nBlanks;
frameRate = res.opts.frameRate;
framesPerSec = 1/frameRate;

evtSizeCutoff = 150;
nFig = 1;

%% extract the time, area, and distance of all events, as well as the dFF
Area = res.fts.basic.area;
dFF = res.dffMat;
for i = 1:length(res.evt);t(i) = min(min(res.riseLst{i}.dlyMap(:)));end
distance = res.fts.region.landmarkDist.distAvg;

%% Plot 1 - Distance from Event to Soma
if any(plotVector == 1)
    
    % dist = dist(:,2); % For this cell, there was an accidental incorrect landmark #1
    % distribution of distances
    figArray(nFig) = figure;
    nFig = nFig + 1;
    histogram(distance,0:2.5:50)
    [h,x] = histcounts(distance,0:2.5:50);
    maxDist = x(min(find(h==0)));
    xlim([0 maxDist])
    xlabel('Distance (\mum)')
    ylabel('# Events')
    title('Event Distance from Soma');
end

%% Plot 2 - Small and Big Events After Onset
% the cycle-wise plots of large and small events
if any(plotVector == 2)
    smEventsTime = mod(t(Area<=evtSizeCutoff),cycleLength)./framesPerSec;
    lgEventsTime = mod(t(Area>evtSizeCutoff),cycleLength)./framesPerSec;
    smEventsArea = Area(Area<=evtSizeCutoff);
    lgEventsArea = Area(Area>evtSizeCutoff);
    smEventsDist = distance(Area<=evtSizeCutoff);
    lgEventsDist = distance(Area>evtSizeCutoff);
    
    timeCut = [0 1.5 5.5 8];
    figArray(nFig) = figure;
    nFig = nFig + 1;
    subplot(2,1,1)
    histogram(smEventsTime,0:.5:16.5)
    [~,cutSmEdges] = histcounts(smEventsTime,0:.5:16.5);
    [~,minSmIn] = min(abs(cutSmEdges-timeCut(1)));
    [~,maxSmIn] = min(abs(cutSmEdges-timeCut(2)));
    targetSm = sum(double(smEventsTime>timeCut(2)).*double(smEventsTime<timeCut(3)));
    outSm = sum(double(smEventsTime>timeCut(3)).*double(smEventsTime<timeCut(4)) + ...
        double(smEventsTime<timeCut(2)));
    sizeSmRatio = targetSm/outSm;
    xline(timeCut(2)); xline(timeCut(3));
    ylabel('# Events')
    xlabel('Time (sec)')
    title(['Event Area <',num2str(evtSizeCutoff)])
    % ylim([0 maxDist])
    xlim([-.5 cycleLength/framesPerSec+.5])
    subplot(2,1,2)
    histogram(lgEventsTime,0:.5:16.5);
    targetLg = sum(double(lgEventsTime>timeCut(2)).*double(lgEventsTime<timeCut(3)));
    outLg = sum(double(lgEventsTime>timeCut(3)).*double(lgEventsTime<timeCut(4)) + ...
        double(lgEventsTime<timeCut(2)));
    sizeLgRatio = targetLg/outLg;
    xline(timeCut(2)); xline(timeCut(3));
    ylabel('# Events')
    title(['Event Area >',num2str(evtSizeCutoff)])
    % ylim([0 maxDist])
    xlabel('Time (sec)')
    xlim([-.5 cycleLength/framesPerSec+.5])
    sgtitle('Event Count After Onset');
    Ratios = [sizeSmRatio , sizeLgRatio];
else
    Ratios = NaN;
end

%% Plot 3 - Event Size Raster
if any(plotVector == 3)
    figArray(nFig) = figure;
    nFig = nFig + 1;
    subplot(2,1,1);
    for i = 1:length(res.evt);if Area(i) <= evtSizeCutoff ;plot(mod(t(i),cycleLength)./framesPerSec,distance(i),'.k','MarkerSize',Area(i)^.5.*3);hold on;end;end
    ylabel('Distance (\mum)')
    xlabel('Time (sec)')
    title(['Event Area <',num2str(evtSizeCutoff)])
    ylim([0 maxDist])
    
    subplot(2,1,2)
    for i = 1:length(res.evt);if Area(i) > evtSizeCutoff ;plot(mod(t(i),cycleLength)./framesPerSec,distance(i),'.k','MarkerSize',Area(i)^.5.*3);hold on;end;end
    xlabel('Time (sec)')
    ylabel('Distance (\mum)')
    title(['Event Area >',num2str(evtSizeCutoff)])
    ylim([0 maxDist])
    
    % the cycle-wise plot of event time vs. distance, including size
end

%% Plot 4 - All Events Raster
if any(plotVector == 4)
    figArray(nFig) = figure;
    nFig = nFig + 1;
    for i = 1:length(res.evt);plot(mod(t(i),cycleLength)./framesPerSec,distance(i),'.k','MarkerSize',Area(i)^.5.*3);hold on;end
    title('All Events Size and Distance')
    xlabel('Time (sec)')
    ylabel('Distance (\mum)')
    ylim([0 maxDist])
end

%% Plot 5 - All Event Raster by Orientation
% the orientation tuning plot of event time vs. distance, including size
if plotVector == 5
    figArray(nFig) = figure;
    nFig = nFig + 1;
    for i = 1:length(res.evt);plot(mod(t(i),stimLength)./framesPerSec,distance(i),'.k','MarkerSize',Area(i)^.5.*3);hold on;end
    for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
    set(gca,'xtick',0:nStims:195)
    set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks]) 0:360/12:359])
    xlabel('Orientation (deg)')
    ylabel('Distance (\mum))')
    ylim([0 maxDist])
    title('All Events Size and Distance by Orientation');
end

%% Plot 6 - Small and Large Events Raster by Orientation
% the orientation tuning plots of large and small events
if any(plotVector == 6)
    figArray(nFig) = figure;
    nFig = nFig + 1;
    subplot(2,1,1)
    for i = 1:length(res.evt);if Area(i) <= evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,distance(i),'.k','MarkerSize',Area(i)^.5.*3);hold on;end;end
    for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
    title(['Event Area <',num2str(evtSizeCutoff)])
    
    subplot(2,1,2)
    for i = 1:length(res.evt);if Area(i) > evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,distance(i),'.k','MarkerSize',Area(i)^.5.*3);hold on;end;end
    for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
    title(['Event Area >',num2str(evtSizeCutoff)])
    sgtitle('Small and Large Events Distance by Orientation');
end

%% Plot 7 - Large and Small Event by Orientation
% histograms of large and small events by orientation
if any(plotVector == 7)
    figArray(nFig) = figure;
    nFig = nFig + 1;
    subplot(2,1,1)
    histogram(mod(t(find(Area<=evtSizeCutoff)),stimLength)./framesPerSec,nStims , 'FaceColor' , 'g')
    set(gca,'XTick',[1:nBlanks.*-cycleLength./framesPerSec [0:cycleLength:stimLength-1]./framesPerSec]+cycleLength/8)
    % set(gca,'XTick',[[0:cycleLength:stimLength-1]./framesPerSec]+cycleLength/8)
    % set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks])  0:360/12:359])
    set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks])  0:360/12:359])
    ylabel('# Events')
    title(['Event Area <',num2str(evtSizeCutoff)])
    
    subplot(2,1,2)
    histogram(mod(t(find(Area>evtSizeCutoff)),stimLength)./framesPerSec,nStims , 'FaceColor' , 'g')
    set(gca,'XTick',[1:nBlanks.*-cycleLength./framesPerSec [0:cycleLength:stimLength-1]./framesPerSec]+cycleLength/8)
    set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks])  0:360/12:359])
    % set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks]) 0:360/12:359])
    ylabel('# Events')
    title(['Event Area >',num2str(evtSizeCutoff)])
    sgtitle('Event Count by Orientation');
    % towInd = res.fts.region.landmarkDir.chgTowardBefReach(:,2);
    awyInd = res.fts.region.landmarkDir.chgAwayThr(:,2);
    towInd = res.fts.region.landmarkDir.chgTowardThr(:,2);
end

%% Plot 8 - Histogram Small and Large Events by Orientation
% the orientation tuning plots of towards events
if any(plotVector == 8)
    figArray(nFig) = figure;
    nFig = nFig + 1;
    subplot(2,1,1)
    for i = 1:length(res.evt);if awyInd(i) > evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,distance(i),'.k','MarkerSize',Area(i)^.5.*3);hold on;end;end
    for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
    title(['away >',num2str(evtSizeCutoff)])
    
    subplot(2,1,2)
    for i = 1:length(res.evt);if towInd(i) > evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,distance(i),'.k','MarkerSize',Area(i)^.5.*3);hold on;end;end
    for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
    title(['Towards >',num2str(evtSizeCutoff)])
    
end

if nargin > 2
    for ii = 1:numel(figArray)
        newSaveName = sprintf('%s_rasterMap_%i.jpg' , saveName , plotVector(ii));
        saveas(figArray(ii) , fullfile(imageSavePath,newSaveName));
    end
    set(0,'DefaultFigureVisible','on');
end

end