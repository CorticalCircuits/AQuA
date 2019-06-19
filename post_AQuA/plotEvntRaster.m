%% cell-specific parameters (ideally saved with the AQuA data file)
cycleLength = 32;
stimLength = 576;
nStims = stimLength/cycleLength;
nBlanks = 2;
frameRate = res.opts.frameRate;
framesPerSec = 1/frameRate;
% framesPerSec = 4;

evtSizeCutoff = 50; %% could do something more rational, like fitting the distribution, something like this:
% area2 = area;
% area2(area2>150) = 150;
% h = hist(area2,0:150);
% figure
% plot(scale_clip(h));
% hold on
% plot(0:150,scale_clip(gampdf(0:150,2,4)));

%% extract the time, area, and distance of all events, as well as the dFF
area = res.fts.basic.area; % need to calibrate this
dFF = res.dffMat;
for i = 1:length(res.evt);t(i) = min(min(res.riseLst{i}.dlyMap(:)));end
dist = res.fts.region.landmarkDist.distAvg;
% dist = dist(:,2); % For this cell, there was an accidental incorrect landmark #1

% distribution of distances
figure
hist(dist,0:2.5:50)
[h,x] = hist(dist,0:2.5:50);
maxDist = x(min(find(h==0)));
xlim([0 maxDist])
xlabel('distance (microns')
ylabel('# events')

% the cycle-wise plots of large and small events
smEventsTime = mod(t(area<=evtSizeCutoff),cycleLength)./framesPerSec;
lgEventsTime = mod(t(area>evtSizeCutoff),cycleLength)./framesPerSec;
smEventsArea = area(area<=evtSizeCutoff);
lgEventsArea = area(area>evtSizeCutoff);
smEventsDist = dist(area<=evtSizeCutoff);
lgEventsDist = dist(area>evtSizeCutoff);

figure
subplot(2,1,1)
hist(smEventsTime,0:.5:16.5)
ylabel('# events')
title(['event area <',num2str(evtSizeCutoff)]) 
% ylim([0 maxDist])
xlim([-.5 cycleLength/framesPerSec+.5])
subplot(2,1,2)
hist(lgEventsTime,0:.5:16.5)
ylabel('# events')
title(['event area >',num2str(evtSizeCutoff)]) 
% ylim([0 maxDist])
xlabel('time (sec)')
xlim([-.5 cycleLength/framesPerSec+.5])

% return

figure
subplot(2,1,1)
% for i = 1:length(smEventsTime);hold on;plot(smEventsTime(i),smEventsDist(i),'.k','MarkerSize',area(i).^.5.*3);end
for i = 1:length(res.evt);if area(i) <= evtSizeCutoff ;plot(mod(t(i),cycleLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
ylabel('distance (microns')
title(['event area <',num2str(evtSizeCutoff)]) 
ylim([0 maxDist])

subplot(2,1,2)
for i = 1:length(res.evt);if area(i) > evtSizeCutoff ;plot(mod(t(i),cycleLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
xlabel('time (sec)')
ylabel('distance (microns)')
title(['event area >',num2str(evtSizeCutoff)]) 
ylim([0 maxDist])

% the cycle-wise plot of event time vs. distance, including size
figure
for i = 1:length(res.evt);plot(mod(t(i),cycleLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end
title('All events')
xlabel('Time (sec)')
ylabel('dist (microns)')
ylim([0 maxDist])

% the orientation tuning plot of event time vs. distance, including size
figure
for i = 1:length(res.evt);plot(mod(t(i),stimLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end
for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
set(gca,'xtick',0:nStims:195)
set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks]) 0:360/12:359])
xlabel('Orientation')
ylabel('dist (microns)')
ylim([0 maxDist])

% the orientation tuning plots of large and small events
figure
subplot(2,1,1)
for i = 1:length(res.evt);if area(i) <= evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
title(['event area <',num2str(evtSizeCutoff)]) 
 
subplot(2,1,2)
for i = 1:length(res.evt);if area(i) > evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
title(['event area >',num2str(evtSizeCutoff)]) 


% histograms of large and small events by orientation
figure
subplot(2,1,1)
histogram(mod(t(find(area<=evtSizeCutoff)),stimLength)./framesPerSec,nStims)
set(gca,'XTick',[1:nBlanks.*-cycleLength./framesPerSec [0:cycleLength:stimLength-1]./framesPerSec]+cycleLength/8)
% set(gca,'XTick',[[0:cycleLength:stimLength-1]./framesPerSec]+cycleLength/8)
% set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks])  0:360/12:359])
set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks])  0:360/12:359])
ylabel('# events')
title(['event area <',num2str(evtSizeCutoff)]) 

subplot(2,1,2)
histogram(mod(t(find(area>evtSizeCutoff)),stimLength)./framesPerSec,nStims)
set(gca,'XTick',[1:nBlanks.*-cycleLength./framesPerSec [0:cycleLength:stimLength-1]./framesPerSec]+cycleLength/8)
set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks])  0:360/12:359])
% set(gca,'XTickLabel',[repmat(NaN,[1, nBlanks]) 0:360/12:359])
ylabel('# events')
title(['event area >',num2str(evtSizeCutoff)]) 

% towInd = res.fts.region.landmarkDir.chgTowardBefReach(:,2);
awyInd = res.fts.region.landmarkDir.chgAwayThr(:,2);
towInd = res.fts.region.landmarkDir.chgTowardThr(:,2);
% the orientation tuning plots of towards events
figure
subplot(2,1,1)
for i = 1:length(res.evt);if awyInd(i) > evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
title(['away >',num2str(evtSizeCutoff)]) 
 
subplot(2,1,2)
for i = 1:length(res.evt);if towInd(i) > evtSizeCutoff ;plot(mod(t(i),stimLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
for i = 0:cycleLength:stimLength;line([i i]./framesPerSec,[0 maxDist]);end
title(['towards >',num2str(evtSizeCutoff)]) 


% for i = 1:length(res.evt);plot(mod(t(i),stimLength)./framesPerSec,dist(i)
    
    
    return
  
save('E:\AQuA\Output\TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrialssmooth4_AQuA_postProc.mat', 'smEventsTime', 'lgEventsTime', 'smEventsArea', 'lgEventsArea', 'smEventsDist', 'lgEventsDist')

