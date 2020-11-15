function ratio = areaCompare(res , bd0 , whichevt , savePath , saveName)
%Extract the percentage of the area of an event inside the landmark Input the AQuA result, landmark structure and event number
if ~exist('res','var') || ~exist('bd0','var')
    error('No res structure or landmark structure found. Load an AQuA mat file and a landmark file to begin');
end
oneEvent = true;
if ~exist('whichevt','var')
    oneEvent = false;
    whichevt = 1:length(res.evt);
    coveredSomaArea = zeros(size(res.evt));
    insideSomaArea = zeros(size(res.evt));
end

%% Area Calculation
count = 1;
for ii = whichevt
    %Traces
    vidFrames = false(size(res.datOrg));
    vidFrames(res.evt{(ii)}) = true;
    trace = logical(sum(vidFrames,3));
    landMk = bd0{1}{1}{1};
    %Area
    [yInd , xInd] = find(trace == true);
    in = inpolygon(xInd,yInd,landMk(:,2),landMk(:,1));
    trueFrame = true(size(trace));
    [yTrue , xTrue] = find(trueFrame == true);
    pin = inpolygon(yTrue,xTrue,landMk(:,2),landMk(:,1));
    coveredSomaArea(count) = 100 * numel(find(in==true))/numel(find(pin==true));
    insideSomaArea(count) = 100 * numel(find(in==true))/numel(find(trace==true));
    count = count+1;
end

%% Ratio Generation
significantEvents = all([insideSomaArea>90;res.fts.basic.area<200;coveredSomaArea>2]);
ratio = sum(significantEvents)/sum(all([res.fts.basic.area<200;coveredSomaArea>2]));

%% Figure Display
fig = figure;
ax = axes('parent',fig);
if oneEvent
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
else
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
end