%% Selecting Landmark and Invading Event Index
whicchLandmark = 1;
whichevt = 3
% figure;plot(res.ftsFilter.region.landmarkDir.chgTowardBefReach)
mnIm = mean(res.datOrg,3);
somaBorder = res.fts.region.landMark.border{whicchLandmark};
%% Direction Score Threshold
thresh = 50;

%% Indexing all invading Events
invadingEvents = find(res.fts.region.landmarkDir.chgToward(:,whicchLandmark)>thresh);
%% Text on figure
PreText = {string(res.opts.fileName),"Area of Event: %f \mu^2", "Frames: %f" , "Direction Score Towards: %f", "Direction Score Away: %f"} % Need to add mu ^2 to the area
A(1) = 0
A(2) = res.fts.basic.area(invadingEvents(whichevt));
A(3) = res.fts.basic.area(invadingEvents(whichevt)); % This needs to be fixed to show the frames I wasnt sure how to get this
A(4) = res.fts.region.landmarkDir.chgToward(invadingEvents(whichevt));
A(5) = res.fts.region.landmarkDir.chgAway(invadingEvents(whichevt));
for n = 1:1:5  
PostText{n} = sprintf(PreText{n},A(n));
end
vidname = PostText(1)+"Event"+string((invadingEvents(whichevt)))+".avi";
VidNombre = convertStringsToChars(vidname);
%% Video Writer
%v = VideoWriter(PostText(1)+"Event#:"+string((invadingEvents(whichevt)))+".avi");
v = VideoWriter(VidNombre);
open(v)
for whichEvt = whichevt%1:length(invadingEvents)
    temp = zeros(size(res.datOrg));
    temp(res.evt{invadingEvents(whichEvt)}) = 1;
%     figure
%     imagesc(sum(temp,3))
%     hold on
%     plot(somaBorder(:,2),somaBorder(:,1),'o')
%     colormap hot
    clear M
    ind = 0;
    for t = res.fts.curve.tBegin(invadingEvents(whichEvt)):res.fts.curve.tEnd(invadingEvents(whichEvt))
        ind = ind+1;
%         imagesc(temp(:,:,t));
         overlayImages(mnIm, temp(:,:,t),  temp(:,:,t),.6,'hot',[0 1])
        hold on
        plot(somaBorder(:,2),somaBorder(:,1),'.')
        ylim=get(gca,'ylim');
xlim=get(gca,'xlim');
text(xlim(1),ylim(2),PostText,'Color','white')
        M(ind) = getframe;
        writeVideo(v,M);
        hold on;
    end



end
close(v)

    

