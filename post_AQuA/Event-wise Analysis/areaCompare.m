function areaCompare(res , bd0 , whichevt)
%Extract the percentage of the area of an event inside the landmark 
%Input the AQuA result, landmark structure and event number
if ~exist('res','var') || ~exist('bd0','var')
    error('No res structure or landmark structure found. Load an AQuA mat file and a landmark file to begin');
end

%% Traces
vidFrames = false(size(res.datOrg));
vidFrames(res.evt{(whichevt)}) = true;
trace = logical(sum(vidFrames,3));
landMk = bd0{1}{1}{1};

%% Area
[yInd , xInd] = find(trace == true);
in = inpolygon(xInd,yInd,landMk(:,2),landMk(:,1));
trueFrame = true(size(trace));
[yTrue , xTrue] = find(trueFrame == true);
pin = inpolygon(yTrue,xTrue,landMk(:,2),landMk(:,1));
overlapArea = 100*numel(find(in==true))/numel(find(pin==true));
fprintf('Overlapping Area = %2.2f%%\n',overlapArea);
outText = sprintf('Overlapping Area = %2.2f%%\n',overlapArea);

%% Figure Display
fig = figure;
ax = axes('parent',fig);
imshow(trace);
hold(ax,'on');
plot(landMk(:,2),landMk(:,1),'g','LineWidth',2);
hold(ax,'on');
plot(xInd(in) , yInd(in),'m.');
hold(ax,'off');
text(.05,.05,outText,'Color','w','Units','Normalized');

end