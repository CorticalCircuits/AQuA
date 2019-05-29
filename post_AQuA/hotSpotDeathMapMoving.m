lastFrameMap = zeros(size(res.datOrg,1), size(res.datOrg,2));

thresh = 50;
% invadingEvents = find(res.ftsFilter.region.landmarkDir.chgTowardBefReach(:,2)>thresh);
invadingEvents = find(res.ftsFilter.region.landmarkDir.chgToward(:,2)>thresh);
evadingEvents = find(res.ftsFilter.region.landmarkDir.chgAway(:,2)>thresh);
movingEvents = cat(1,invadingEvents,evadingEvents);

for whichEvt = 1:length(movingEvents);

    [x,y,t] = ind2sub(size(res.datOrg),res.fts.loc.x3D{movingEvents(whichEvt)});
    [lastFrameXY] = [x(find(t == max(t))), y(find(t == max(t)))];
    for i = 1:size(lastFrameXY,1)
        lastFrameMap(lastFrameXY(i,1), lastFrameXY(i,2)) = lastFrameMap(lastFrameXY(i,1), lastFrameXY(i,2))+1;
    end
end
figure
imagesc(lastFrameMap)
axis image
colormap hot
colorbar
