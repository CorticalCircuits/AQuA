tic
%% Selecting Landmark and Invading Event Index (If running non batch here make sure to uncomment this section)
% whicchLandmark = 1;
% whichevt = 8;
% % figure;plot(res.ftsFilter.region.landmarkDir.chgTowardBefReach)

%% Direction Score Threshold + mean image + soma border
thresh = 50;
mnIm = mean(res.datOrg,3);
somaBorder = res.fts.region.landMark.border{whicchLandmark};
%% Indexing all invading Events
% This creates a new index of all the events that invade the soma with a
% value greater than the set threshold above
% = find(res.fts.region.landmarkDir.chgToward(:,whicchLandmark)>thresh);
%% Text on figure
%Here below is the use of string in a pre than post process in order to
%refrence the variables from AQUA and then print those feature values into
%the movie that will be played
PreText = {string(res.opts.fileName),"Event #: %.0f ","Area of Event: %.1f  mu^2", "Frames: %.0f " , "Time: %.1f s ", "Direction Score Towards: %.1f", "Direction Score Away: %.1f"};% Need to add mu ^2 to the area was having issues with the printing but this is a minor issue as we can just add a mu in text in the plot window
A(1) = string(res.opts.fileName)
A(2) = whichevt
A(3) = (res.fts.basic.area(whichevt)); %Area
A(4) = (res.fts.loc.t1(whichevt) - res.fts.loc.t0(whichevt)) % Frames
A(5) = (res.fts.loc.t1(whichevt) - res.fts.loc.t0(whichevt))*(res.opts.frameRate)
A(6) = (res.fts.region.landmarkDir.chgToward(whichevt));
A(7) = (res.fts.region.landmarkDir.chgAway(whichevt));
for n = 1:1:(numel(A(:)))  
charText{n} = sprintf(PreText{n},(A(n)));
PostText = convertCharsToStrings(charText);
end

vidname = charText(1)+"Event"+string(whichevt);
VidNombre = convertStringsToChars(vidname);

%% Video Writer
%This is the video writer code that is saved in the form of an .avi file. I
%attempted to make this into a mp4 howver when I do this the video does not
%really save as well and is not the same speed as the original shown in the
%plot
%v = VideoWriter(PostText(1)+"Event#:"+string(((whichevt)))+".avi");
v = VideoWriter(VidNombre,'MPEG-4');
v.FrameRate = 8;
v.Quality = 100;
open(v)
%% Plot Creation
fig = figure(1)
preIm = zeros([250 256]);
x = imshow(preIm)
hold on 
set(fig, 'Position', get(0, 'Screensize'));
plot(somaBorder(:,2),somaBorder(:,1),'.')
hold on
%% Plotting Data and overlay
plot(somaBorder(:,2),somaBorder(:,1),'-')
hold on
for whichEvt = whichevt%1:length()
    temp = zeros(size(res.datOrg));
    temp(res.evt{(whichEvt)}) = 1;
%     figure
%     imagesc(sum(temp,3))
%     hold on
%     plot(somaBorder(:,2),somaBorder(:,1),'o')
%     colormap hot
    clear M
    ind = 0;
    for t = res.fts.curve.tBegin((whichEvt)):res.fts.curve.tEnd((whichEvt))
        ind = ind+1;
%         imagesc(temp(:,:,t));
      overlayImages(mnIm, temp(:,:,t),  temp(:,:,t),.6,'hot',[0 1])
             text(.15,.15,PostText,'Color','w','Units','Normalized')
             hold on
             plot(somaBorder(:,2),somaBorder(:,1),'.')
             axis tight manual
             ax = gca
   M(ind) = getframe(fig)
   
    end

end
   writeVideo(v,M);
close(v)
toc