

% figure;plot(res.ftsFilter.region.landmarkDir.chgTowardBefReach)

somaBorder = res.fts.region.landMark.border{:};

thresh = 100;
invadingEvents = find(res.ftsFilter.region.landmarkDir.chgTowardBefReach>thresh);

for whichEvt = 1%1:length(invadingEvents)
    temp = zeros(size(res.datOrg));
    temp(res.evt{invadingEvents(whichEvt)}) = 1;
    figure
    imagesc(sum(temp,3))
    hold on
    plot(somaBorder(:,2),somaBorder(:,1),'o')
    colormap hot
    clear M
    figure
    ind = 0;
    for t = res.fts.curve.tBegin(invadingEvents(whichEvt)):res.fts.curve.tEnd(invadingEvents(whichEvt))
        ind = ind+1;
        imagesc(temp(:,:,t));
        hold on
        plot(somaBorder(:,2),somaBorder(:,1),'o')
        M(ind) = getframe;
        hold off
    end



end

