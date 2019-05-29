whicchLandmark = 1;


% figure;plot(res.ftsFilter.region.landmarkDir.chgTowardBefReach)
mnIm = mean(res.datOrg,3);
somaBorder = res.fts.region.landMark.border{whicchLandmark};

thresh = 50;
% invadingEvents = find(res.ftsFilter.region.landmarkDir.chgTowardBefReach(:,2)>thresh);
invadingEvents = find(res.ftsFilter.region.landmarkDir.chgToward(:,whicchLandmark)>thresh);

for whichEvt = 3%1:length(invadingEvents)
    temp = zeros(size(res.datOrg));
    temp(res.evt{invadingEvents(whichEvt)}) = 1;
%     figure
%     imagesc(sum(temp,3))
%     hold on
%     plot(somaBorder(:,2),somaBorder(:,1),'o')
%     colormap hot
    clear M
    figure
    ind = 0;
    for t = res.fts.curve.tBegin(invadingEvents(whichEvt)):res.fts.curve.tEnd(invadingEvents(whichEvt))
        ind = ind+1;
%         imagesc(temp(:,:,t));
         overlayImages(mnIm, temp(:,:,t),  temp(:,:,t),.6,'hot',[0 1])
        hold on
        plot(somaBorder(:,2),somaBorder(:,1),'.')
        M(ind) = getframe;
        hold off
    end



end
movie(M,2,3)
