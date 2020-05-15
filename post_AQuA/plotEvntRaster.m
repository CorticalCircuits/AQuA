%% cell-specific parameters (ideally saved with the AQuA data file)
if ~exist('cell_stim_db','var')
    if exist('cell_stim_db.mat','file')
        load('cell_stim_db.mat');
    else
        error('Database not found. Include cell stimulus database in Matlab path');
    end
end

cellName = 'cell3';
expNum = sscanf(cellName,'cell%i');

cycleLength = cell_stim_db(expNum).stim.cycleLength;
stimLength = cell_stim_db(expNum).stim.nFrames;
nStims = stimLength/cycleLength;
nBlanks = cell_stim_db(expNum).stim.nBlanks;
frameRate = res.opts.frameRate;
framesPerSec = 1/frameRate;

evtSizeCutoff = 50;

%% extract the time, area, and distance of all events, as well as the dFF
area = res.fts.basic.area; % need to calibrate this
dFF = res.dffMat;

%% Plot 1 - Distance from Event to Soma
for i = 1:length(res.evt);t(i) = min(min(res.riseLst{i}.dlyMap(:)));end
dist = res.fts.region.landmarkDist.distAvg;
% dist = dist(:,2); % For this cell, there was an accidental incorrect landmark #1

% distribution of distances
figure
histogram(dist,0:2.5:50)
[h,x] = histcounts(dist,0:2.5:50);
maxDist = x(min(find(h==0)));
xlim([0 maxDist])
xlabel('Distance (\mum)')
ylabel('# Events')
title('Event Distance from Soma');

%% Plot 2 - Small and Big Events After Onset
% the cycle-wise plots of large and small events
smEventsTime = mod(t(area<=evtSizeCutoff),cycleLength)./framesPerSec;
lgEventsTime = mod(t(area>evtSizeCutoff),cycleLength)./framesPerSec;
smEventsArea = area(area<=evtSizeCutoff);
lgEventsArea = area(area>evtSizeCutoff);
smEventsDist = dist(area<=evtSizeCutoff);
lgEventsDist = dist(area>evtSizeCutoff);

timeCut = [1.5 5.5];
figure
subplot(2,1,1)
histogram(smEventsTime,0:.5:16.5)
[~,cutSmEdges] = histcounts(smEventsTime,0:.5:16.5);
[~,minSmIn] = min(abs(cutSmEdges-timeCut(1)));
[~,maxSmIn] = min(abs(cutSmEdges-timeCut(2)));
targetSm = sum(double(smEventsTime>timeCut(1)).*double(smEventsTime<timeCut(2)));
sizeSmRatio = targetSm/(numel(smEventsTime)-targetSm);
xline(timeCut(1)); xline(timeCut(2));
ylabel('# Events')
xlabel('Time (sec)')
title(['Event Area <',num2str(evtSizeCutoff)]) 
% ylim([0 maxDist])
xlim([-.5 cycleLength/framesPerSec+.5])
subplot(2,1,2)
histogram(lgEventsTime,0:.5:16.5);
[~, cutLgEdges] = histcounts(lgEventsTime,0:.5:16.5);
[~,minLgIn] = min(abs(cutLgEdges-timeCut(1)));
[~,maxLgIn] = min(abs(cutLgEdges-timeCut(2)));
targetLg = sum(double(lgEventsTime>timeCut(1)).*double(lgEventsTime<timeCut(2)));
sizeLgRatio = targetLg/(numel(lgEventsTime)-targetLg);
xline(timeCut(1)); xline(timeCut(2));
ylabel('# Events')
title(['Event Area >',num2str(evtSizeCutoff)]) 
% ylim([0 maxDist])
xlabel('Time (sec)')
xlim([-.5 cycleLength/framesPerSec+.5])
sgtitle('Event Count After Onset');
Ratios = [sizeSmRatio , sizeLgRatio];

% return

%% Plot 3 - Event Size Raster
figure
subplot(2,1,1)
% for i = 1:length(smEventsTime);hold on;plot(smEventsTime(i),smEventsDist(i),'.k','MarkerSize',area(i).^.5.*3);end
for i = 1:length(res.evt);if area(i) <= evtSizeCutoff ;plot(mod(t(i),cycleLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
ylabel('Distance (\mum)')
xlabel('Time (sec)')
title(['Event Area <',num2str(evtSizeCutoff)]) 
ylim([0 maxDist])

subplot(2,1,2)
for i = 1:length(res.evt);if area(i) > evtSizeCutoff ;plot(mod(t(i),cycleLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
xlabel('Time (sec)')
ylabel('Distance (\mum)')
title(['Event Area >',num2str(evtSizeCutoff)])
ylim([0 maxDist])

% the cycle-wise plot of event time vs. distance, including size
%% Plot 4 - All Events Raster
figure
for i = 1:length(res.evt);plot(mod(t(i),cycleLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end
title('All Events Size and Distance')
xlabel('Time (sec)')
ylabel('Distance (\mum)')
ylim([0 maxDist])



%% Plot 5 - All Event Raster by Orientation
% the orientation tuning plot of event time vs. distance, including size
figure
for i = 1:length(res.evt);plot(mod(t(i),stimLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end
for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
set(gca,'xtick',0:nStims:195)
set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks]) 0:360/12:359])
xlabel('Orientation (deg)')
ylabel('Distance (\mum))')
ylim([0 maxDist])
title('All Events Size and Distance by Orientation');

%% Plot 6 - Small and Large Events Raster by Orientation
% the orientation tuning plots of large and small events
figure
subplot(2,1,1)
for i = 1:length(res.evt);if area(i) <= evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
title(['Event Area <',num2str(evtSizeCutoff)]) 
 
subplot(2,1,2)
for i = 1:length(res.evt);if area(i) > evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
title(['Event Area >',num2str(evtSizeCutoff)]) 
sgtitle('Small and Large Events Distance by Orientation');

%% Plot 7 - Large and Small Event by Orientation
% histograms of large and small events by orientation
figure
subplot(2,1,1)
histogram(mod(t(find(area<=evtSizeCutoff)),stimLength)./framesPerSec,nStims , 'FaceColor' , 'g')
set(gca,'XTick',[1:nBlanks.*-cycleLength./framesPerSec [0:cycleLength:stimLength-1]./framesPerSec]+cycleLength/8)
% set(gca,'XTick',[[0:cycleLength:stimLength-1]./framesPerSec]+cycleLength/8)
% set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks])  0:360/12:359])
set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks])  0:360/12:359])
ylabel('# Events')
title(['Event Area <',num2str(evtSizeCutoff)]) 

subplot(2,1,2)
histogram(mod(t(find(area>evtSizeCutoff)),stimLength)./framesPerSec,nStims , 'FaceColor' , 'g')
set(gca,'XTick',[1:nBlanks.*-cycleLength./framesPerSec [0:cycleLength:stimLength-1]./framesPerSec]+cycleLength/8)
set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks])  0:360/12:359])
% set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks]) 0:360/12:359])
ylabel('# Events')
title(['Event Area >',num2str(evtSizeCutoff)]) 
sgtitle('Event Count by Orientation');
% towInd = res.fts.region.landmarkDir.chgTowardBefReach(:,2);
awyInd = res.fts.region.landmarkDir.chgAwayThr(:,2);
towInd = res.fts.region.landmarkDir.chgTowardThr(:,2);

%% Plot 8 - Histogram Small and Large Events by Orientation
% the orientation tuning plots of towards events
figure
subplot(2,1,1)
for i = 1:length(res.evt);if awyInd(i) > evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
title(['away >',num2str(evtSizeCutoff)]) 
 
subplot(2,1,2)
for i = 1:length(res.evt);if towInd(i) > evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
title(['Towards >',num2str(evtSizeCutoff)]) 


% for i = 1:length(res.evt);plot(mod(t(i),stimLength)./framesPerSec,dist(i)
    
    
    return
  
%save('E:\AQuA\Output\TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrialssmooth4_AQuA_postProc.mat', 'smEventsTime', 'lgEventsTime', 'smEventsArea', 'lgEventsArea', 'smEventsDist', 'lgEventsDist')

