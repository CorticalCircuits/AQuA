d = dir('E:\AQuA\Output\*.mat')
for i = 1:length(d);
    load(['E:\AQuA\Output\',d(i).name]),
    smEventsTimes(i).smEventsTime = smEventsTime;
    smEventsAreas(i).smEventsArea = smEventsArea;
    smEventsDists(i).smEventsDist = smEventsDist;

    lgEventsTimes(i).lgEventsTime = lgEventsTime;
    lgEventsAreas(i).lgEventsArea = lgEventsArea;
    lgEventsDists(i).lgEventsDist = lgEventsDist;
end

lgEvT = [];
for i = 1:4;lgEvT = cat(2,lgEvT,lgEventsTimes(i).lgEventsTime);end
lgEvA = [];
for i = 1:4;lgEvA = cat(2,lgEvA,lgEventsAreas(i).lgEventsArea);end
lgEvD = [];
for i = 1:4;lgEvD = cat(1,lgEvD,lgEventsDists(i).lgEventsDist(:));end

smEvT = [];
for i = 1:4;smEvT = cat(2,smEvT,smEventsTimes(i).smEventsTime);end
smEvA = [];
for i = 1:4;smEvA = cat(2,smEvA,smEventsAreas(i).smEventsArea);end
smEvD = [];
for i = 1:4;smEvD = cat(1,smEvD,smEventsDists(i).smEventsDist(:));end


evtSizeCutoff = 50;
% figure
% subplot(2,1,1)
% % histogram(smEvT,0:.5:16.5)
% histogram(smEvT,0:1:16.5)
% ylabel('# events')
% title(['event area <',num2str(evtSizeCutoff)]) 
% % ylim([0 maxDist])
% xlim([-.5 14+.5])
% subplot(2,1,2)
% % histogram(lgEvT,0:.5:16.5)
% histogram(lgEvT,0:1:16.5)
% ylabel('# events')
% title(['event area >',num2str(evtSizeCutoff)]) 
% % ylim([0 maxDist])
% xlabel('time (sec)')
% xlim([-.5 14+.5])

for i = 1:4;
    h = histogram(smEventsTimes(i).smEventsTime,0:.5:16.5);
    histsSM(i,:) = h.Values;
    histsSMn(i,:) = h.Values./sum(h.Values);
    h = histogram(lgEventsTimes(i).lgEventsTime,0:.5:16.5);
    histsLG(i,:) = h.Values;
    histsLGn(i,:) = h.Values./sum(h.Values);
    
end

% figure
% hold on
% plot(median(histsLGn(:,1:28))')
% plot(median(histsSMn(:,1:28))')

figure
subplot(3,1,1)
for i = 1:length(smEvT);hold on;scatter(smEvT(i),smEvD(i),'.k','MarkerSize',smEvA(i).^.5.*3);end
return
for i = 1:length(res.evtFilter);if area(i) <= evtSizeCutoff ;plot(mod(t(i),cycleLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
ylabel('distance (microns')
title(['event area <',num2str(evtSizeCutoff)]) 
ylim([0 maxDist])

subplot(2,1,2)
for i = 1:length(res.evtFilter);if area(i) > evtSizeCutoff ;plot(mod(t(i),cycleLength)./framesPerSec,dist(i),'.k','MarkerSize',area(i)^.5.*3);hold on;end;end
xlabel('time (sec)')
ylabel('distance (microns)')
title(['event area >',num2str(evtSizeCutoff)]) 
ylim([0 maxDist])
figure
subplot(2,1,1)
bar(smooth(median(histsLGn(:,1:28))').*100)
set(gca,'xtick',0:4:28)
set(gca,'xticklabel',[0:4:28]./2)
ylabel('% Small events')
ylim([0 10])

subplot(2,1,2)
bar(smooth(median(histsSMn(:,1:28))').*100)
set(gca,'xtick',0:4:28)
set(gca,'xticklabel',[0:4:28]./2)
xlabel('Time (sec)')
ylabel('% Large events')
ylim([0 10])

