lastFrameMap = zeros(size(res.datOrg,1), size(res.datOrg,2));


for whichEvt = 1:length(res.evt);

    [x,y,t] = ind2sub(size(res.datOrg),res.fts.loc.x3D{whichEvt});
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
