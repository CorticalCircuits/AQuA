%% Max Extent of events Hot Spot Map
function hotSpotMax(res , savePath , saveName)
mnIm = mean(res.datOrg,3);
picsize = size(res.datOrg);
evtMap = zeros(picsize(1),picsize(2));
totalmap = zeros(picsize(1),picsize(2));
for evtNumber = 1:length(res.evt)
evtXYpix = res.fts.loc.x2D{evtNumber};
evtMap(evtXYpix) = 1;
totalmap = totalmap + evtMap;
evtMap = zeros(picsize(1),picsize(2));
end
if nargin >= 2; set(0,'DefaultFigureVisible','off'); end
bottom = min(min(totalmap))
top = max(max(totalmap))
h(1) = figure('units','normalized');
imagesc(totalmap); 
colormap(hot); 
axis image;
set(gca,'xtick',[]); set(gca,'ytick',[]);
title('Max Spatial Extent Heat Map of Cell');
caxis manual; caxis([bottom top]);
hcb = colorbar
set(get(hcb,'label'),'string','Times Pixel is in a Event Maximum spatial footprint');
%% Saving images
if nargin >= 2
    savefig(h , fullfile(savePath,[saveName,'HS_Max.fig']));
    saveas(h , fullfile(savePath,[saveName,'HS_Max_Map.jpg']));
    set(0,'DefaultFigureVisible','on');
end
set(0,'DefaultFigureVisible','on');
end