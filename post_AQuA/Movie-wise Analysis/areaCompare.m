function ratio = areaCompare(res , bd0 , whichevt , savePath , saveName)
%Extract the percentage of the area of an event inside the landmark Input the AQuA result, landmark structure and event number
if ~exist('res','var') || ~exist('bd0','var')
    error('No res structure or landmark structure found. Load an AQuA mat file and a landmark file to begin');
end

if nargin >= 2; set(0,'DefaultFigureVisible','off'); end

oneEvent = true;
if ~isnumeric(whichevt)
    oneEvent = false;
    whichevt = 1:length(res.evt);
    coveredSomaArea = zeros(size(res.evt));
    insideSomaArea = zeros(size(res.evt));
end

%% Area Calculation
%Calculates number of shared pixels shared between the trace of an event
%and a frame with only true values (trueFrame) within the borders of
%landmark
count = 1;
landMk = bd0{1}{1}{1};
frameSize = [size(res.datOrg,1) , size(res.datOrg,2)];
frameElement = frameSize(1)*frameSize(2);
for ii = whichevt
    %Find trace of Event
    firstFrame = floor(min(res.evt{(ii)})/frameElement); %First frame of event in movie
    lastFrame = ceil(max(res.evt{(ii)})/frameElement); %Last frame of event in movie
    vidFrames = false(frameSize(1) , frameSize(2) , lastFrame-firstFrame);
    vidFrames(res.evt{(ii)} - firstFrame*frameElement) = true; %Binary movie of event
    trace = logical(sum(vidFrames,3)); %Trace of event (one frame)
    %Area
    [yInd , xInd] = find(trace == true); %x,y indexes of active pixels
    in = inpolygon(xInd,yInd,landMk(:,2),landMk(:,1));
    trueFrame = true(size(trace));%dummy variable for true comparison
    [yTrue , xTrue] = find(trueFrame == true);
    pin = inpolygon(yTrue,xTrue,landMk(:,2),landMk(:,1));
    coveredSomaArea(count) = 100 * numel(find(in==true))/numel(find(pin==true)); %Area of soma covered by an event
    insideSomaArea(count) = 100 * numel(find(in==true))/numel(find(trace==true)); %Area of event inside the soma
    count = count+1;
end

%% Ratio Calculation
% Ratio of yellow events (completely inside soma)smaller than 200um2 divided
% by all events under 200um2
if ~oneEvent
    significantEvents = all([insideSomaArea>90;res.fts.basic.area<50;coveredSomaArea>2]);
    ratio = sum(significantEvents)/sum(all([res.fts.basic.area<50;coveredSomaArea>2]));
end

%% Figure Display
fig = figure;
ax = axes('parent',fig);
if oneEvent %Display only one event and the soma border
    fprintf('Percentage of Soma Covered = %2.2f%%\nPercentage of Trace in Soma = %2.2f%%\n',...
        coveredSomaArea,insideSomaArea);
    outText = sprintf('Percentage of Soma Covered = %2.2f%%\nPercentage of Event inside Soma = %2.2f%%\n',...
        coveredSomaArea,insideSomaArea);
    imshow(trace);
    hold(ax,'on');
    plot(ax,landMk(:,2),landMk(:,1),'g','LineWidth',2);
    hold(ax,'on');
    plot(ax,xInd(in) , yInd(in),'m.');
    hold(ax,'off');
    text(.05,.05,outText,'Color','w','Units','Normalized');
    title(['Event #',num2str(whichevt),' Trace']);
    ratio = [];
else %Display chart with colors and calculate ratio    
    h = parula;
    colormap parula
    color = ceil(63*(insideSomaArea/100))+1;
    for k = 1:length(coveredSomaArea)
        plot(ax,res.fts.basic.area(k) , coveredSomaArea(k),...
            'Marker','.' ,'MarkerSize',14, 'Color',h(color(k),:));
        hold on
    end
    hold off
    title(ax,sprintf('Soma Area Representation Ratio=%.6f',ratio));
    xlabel(ax,'Size of Event (\mum^2)');
    ylabel(ax,'%Area of Soma Covered');
    axis(ax , [0 240 2 102]);
    c = colorbar(ax);
    title(c,'%Event Inside Soma');
    c.TickLabels = num2cell(0:10:100);
   if exist('savePath','var') && exist('saveName','var')
    savefig(fig , fullfile(savePath,[saveName,'_SomaArea.fig']));
    saveas(fig , fullfile(savePath,[saveName,'_SomaArea.jpg']));
   end
end
set(0,'DefaultFigureVisible','on');
end