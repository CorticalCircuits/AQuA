function ratio = areaCompare(res , whichevt , savePath , saveName)
%Extract the percentage of the area of an event inside the landmark Input the AQuA result, landmark structure and event number
if ~exist('res','var')
    error('No res structure structure found. Load an AQuA mat file to begin');
end

if nargin >= 2; set(0,'DefaultFigureVisible','off'); end

oneEvent = true;
if ~isnumeric(whichevt)
    oneEvent = false;
    whichevt = 1:length(res.evt);
    coveredSomaArea = zeros(size(res.evt));
    insideSomaArea = zeros(size(res.evt));
end

%% Initialize
%Calculates number of shared pixels shared between the trace of an event
%and a frame with only true values (trueFrame) within the borders of
%landmark
count = 1;
frameSize = [size(res.datOrg,1) , size(res.datOrg,2)];
frameElement = frameSize(1)*frameSize(2);
landmarkmask = res.fts.region.landMark.mask{1,1};
areaofsoma = res.opts.spatialRes * sum(sum(landmarkmask));
picsize = size(res.datOrg);
%% Area Calculation
for ii = whichevt
evtXYpix = [];
somaint = [];
areaint = [];
evtXYpix = res.fts.loc.x2D{(ii)};
evtMap = zeros(picsize(1),picsize(2));
evtMap(evtXYpix) = 2;
somaint = evtMap + landmarkmask;
areaint = evtMap - landmarkmask;
somacovered(ii)  = (nnz(somaint==3)./nnz(landmarkmask)).*100; %percentage of soma covered by soma
areacovered(ii)  = (nnz(areaint==1)./nnz(evtMap)).*100; %percentage of event covered by soma
end

%% Ratio Calculation
% Ratio of events (completely inside soma)smaller than 50um2 divided
% by all events under 50um2 
if ~oneEvent
    significantEvents = all([areacovered==100;res.fts.basic.area<50;somacovered>1]);
    ratio = sum(significantEvents)/sum(all([res.fts.basic.area<50;somacovered>1]));
end

%% Figure Display
fig = figure;
ax = axes('parent',fig);
if oneEvent %Display only one event and the soma border
    fprintf('Percentage of Soma Covered = %2.2f%%\nPercentage of Trace in Soma = %2.2f%%\n',...
        somacovered,areacovered);
    outText = sprintf('Percentage of Soma Covered = %2.2f%%\nPercentage of Event inside Soma = %2.2f%%\n',...
        somacovered,areacovered);
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
    color = ceil(63*(areacovered/100))+1;
    for k = 1:length(somacovered)
        plot(ax,res.fts.basic.area(k) , somacovered(k),...
            'Marker','.' ,'MarkerSize',14, 'Color',h(color(k),:));
        hold on
    end
    hold off
    title(ax,{sprintf('Soma Area Representation Ratio=%.6f',ratio),sprintf('Total Area of Soma = %d microns^2', areaofsoma)});
    xlabel(ax,'Size of Event (\mum^2)');
    ylabel(ax,'%Area of Soma Covered');
%     axis(ax , [0 240 2 102])
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