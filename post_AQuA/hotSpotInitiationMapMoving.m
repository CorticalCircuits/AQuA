firstFrameMap = zeros(size(res.datOrg,1), size(res.datOrg,2));

thresh = 50;
% invadingEvents = find(res.ftsFilter.region.landmarkDir.chgTowardBefReach(:,2)>thresh);
invadingEvents = find(res.ftsFilter.region.landmarkDir.chgToward(:,2)>thresh);
evadingEvents = find(res.ftsFilter.region.landmarkDir.chgAway(:,2)>thresh);
movingEvents = cat(1,invadingEvents,evadingEvents);

for whichEvt = 1:length(movingEvents);

    [x,y,t] = ind2sub(size(res.datOrg),res.fts.loc.x3D{movingEvents(whichEvt)});

    [firstFrameXY] = [x(find(t == min(t))), y(find(t == min(t)))];
    for i = 1:size(firstFrameXY,1)
        firstFrameMap(firstFrameXY(i,1), firstFrameXY(i,2)) = firstFrameMap(firstFrameXY(i,1), firstFrameXY(i,2))+1;
    end
end
figure
imagesc(firstFrameMap)
axis image
colormap hot
colorbar
