firstFrameMap = zeros(size(res.datOrg,1), size(res.datOrg,2));


for whichEvt = 1:length(res.evt);

    [x,y,t] = ind2sub(size(res.datOrg),res.fts.loc.x3D{whichEvt});
    [firstFrameXY] = [x(find(t == min(t))), y(find(t == min(t)))];
    for i = 1:size(firstFrameXY,1)
        firstFrameMap(firstFrameXY(i,1), firstFrameXY(i,2)) = firstFrameMap(firstFrameXY(i,1), firstFrameXY(i,2))+1;
    end
end
figure
imagesc(firstFrameMap)


