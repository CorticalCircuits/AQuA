function hotSpotMove(res , savePath , saveName)

firstFrameMap = zeros(size(res.datOrg,1), size(res.datOrg,2));
lastFrameMap = zeros(size(res.datOrg,1), size(res.datOrg,2));

thresh = 250;
% invadingEvents = find(res.ftsFilter.region.landmarkDir.chgTowardBefReach(:,2)>thresh);
invadingEvents = find(res.fts.region.landmarkDir.chgToward(:,1)>thresh);
evadingEvents = find(res.fts.region.landmarkDir.chgAway(:,1)>thresh);
movingEvents = cat(1,invadingEvents,evadingEvents);

for whichEvt = 1:length(movingEvents)

    [x,y,t] = ind2sub(size(res.datOrg),res.fts.loc.x3D{movingEvents(whichEvt)});
    [firstFrameXY] = [x(find(t == min(t))), y(find(t == min(t)))];
    [lastFrameXY] = [x(find(t == max(t))), y(find(t == max(t)))];
    for i = 1:size(firstFrameXY,1)
        firstFrameMap(firstFrameXY(i,1), firstFrameXY(i,2)) = firstFrameMap(firstFrameXY(i,1), firstFrameXY(i,2))+1;
    end
    for i = 1:size(lastFrameXY,1)
        lastFrameMap(lastFrameXY(i,1), lastFrameXY(i,2)) = lastFrameMap(lastFrameXY(i,1), lastFrameXY(i,2))+1;
    end
end
bottom = min(min(min(firstFrameMap)) , min(min(lastFrameMap)));
top = max(max(max(firstFrameMap)) , max(max(lastFrameMap)));

if nargin >= 2; set(0,'DefaultFigureVisible','off'); end

h(1) = figure('units','normalized','outerposition',[0 0 1 1]);
ax(1) = subplot(1,9,1:4);
imagesc(firstFrameMap); colormap(ax(1),hot); axis image;
set(gca,'xtick',[]); set(gca,'ytick',[]);
title('HotSpot  - Moving Rise');
caxis manual; caxis([bottom top]);
ax(2) = subplot(1,9,5:8);
imagesc(lastFrameMap); colormap(ax(2),hot); axis image;
set(gca,'xtick',[]); set(gca,'ytick',[]);
title('HotSpot - Moving Death');
caxis manual; caxis([bottom top]);
colorbar('Position',[0.8510    0.19    0.0540    0.67]);

h(2) = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,2,1);
histogram(nonzeros(firstFrameMap),'BinMethod','integers');
title('Moving Death'); xlim([bottom top]);
subplot(1,2,2);
histogram(nonzeros(lastFrameMap),'BinMethod','integers');
title('Moving Rise'); xlim([bottom top]);

if nargin >= 2
    savefig(h , fullfile(savePath,[saveName,'_hsMove.fig']));
    saveas(h(1) , fullfile(savePath,[saveName,'_hsMove_Map.jpg']));
    saveas(h(2) , fullfile(savePath,[saveName,'_hsMove_Hist.jpg']));
    set(0,'DefaultFigureVisible','on');
end

end