%% Selecting Landmark and Invading Event Index
whicchLandmark = 1;
whichevt = 3
% figure;plot(res.ftsFilter.region.landmarkDir.chgTowardBefReach)
mnIm = mean(res.datOrg,3);
somaBorder = res.fts.region.landMark.border{whicchLandmark};
%% Direction Score Threshold
thresh = 50;

%% Indexing all invading Events
% This creates a new index of all the events that invade the soma with a
% value greater than the set threshold above
invadingEvents = find(res.fts.region.landmarkDir.chgToward(:,whicchLandmark)>thresh);
%% Text on figure
%Here below is the use of string in a pre than post process in order to
%refrence the variables from AQUA and then print those feature values into
%the movie that will be played
PreText = {string(res.opts.fileName),"Area of Event: %f \mu^2", "Frames: %f" , "Direction Score Towards: %f", "Direction Score Away: %f"} % Need to add mu ^2 to the area was having issues with the printing but this is a minor issue as we can just add a mu in text in the plot window
A(1) = 0
A(2) = res.fts.basic.area(invadingEvents(whichevt));
A(3) = res.fts.basic.area(invadingEvents(whichevt)); % This needs to be fixed to fins the frames which the event is occuring
A(4) = res.fts.region.landmarkDir.chgToward(invadingEvents(whichevt));
A(5) = res.fts.region.landmarkDir.chgAway(invadingEvents(whichevt));
muu = ' \mu ^{2} '
for n = 1:1:5  
PostText{n} = sprintf(PreText{n},A(n));
end
vidname = PostText(1)+"Event"+string((invadingEvents(whichevt)));
VidNombre = convertStringsToChars(vidname);
%% Video Writer
%This is the video writer code that is saved in the form of an .avi file. I
%attempted to make this into a mp4 howver when I do this the video does not
%really save as well and is not the same speed as the original shown in the
%plot
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
text(xlim(1),ylim(1),PostText,'Color','black')
        M(ind) = getframe;
        writeVideo(v,M);
        hold on;
    end
 

end

close(v)

    

