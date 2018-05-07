function [im1,im2a,im2b] = addCon_dat(f,pDat)

% top level panels
bDat = uix.VBox('Parent',pDat);
pImgTool = uix.HBox('Parent',bDat);  % zoom in/out, pan, jump, frame number ...
uix.Empty('Parent',bDat);
pMovTop = uix.CardPanel('Parent',bDat,'Tag','movTop');  % movies
uix.Empty('Parent',bDat);
pImgCon = uix.HBox('Parent',bDat);  % play, scroll bar ...
uix.Empty('Parent',bDat);
pCurve = axes('Parent',bDat,'ActivePositionProperty','Position','Tag','curve');
bDat.Heights = [15,5,-1,5,20,15,200];

% movie views ---------------
% single movie view
pMov1 = axes('Parent',pMovTop,'ActivePositionProperty','Position','Tag','mov');
pMov1.XTick = [];
pMov1.YTick = [];
d0 = zeros(100,100);
pMov1.XLim = [1 100];
pMov1.YLim = [1 100];
im1 = image(pMov1,'CData',flipud(d0));
im1.CDataMapping = 'scaled';
im1.ButtonDownFcn = {@ui.mov.movClick,f,'sel','evt'};  % show clicked event
pMov1.DataAspectRatio = [1 1 1];

% side by side view
bMov2Top = uix.VBox('Parent',pMovTop);
bMov2Pop = uix.HBox('Parent',bMov2Top);
bMov2 = uix.HBox('Parent',bMov2Top);
bMov2Top.Heights = [25,-1];

pMov2a = axes('Parent',bMov2,'ActivePositionProperty','Position','Tag','movL');
pMov2a.XTick = [];
pMov2a.YTick = [];
d0 = randn(100,100);
pMov2a.XLim = [1 100];
pMov2a.YLim = [1 100];
im2a = image(pMov2a,'CData',flipud(d0));
im2a.CDataMapping = 'scaled';
im2a.ButtonDownFcn = {@ui.mov.movClick,f,'sel','evt'};  % show clicked event
pMov2a.DataAspectRatio = [1 1 1];

pMov2b = axes('Parent',bMov2,'ActivePositionProperty','Position','Tag','movR');
pMov2b.XTick = [];
pMov2b.YTick = [];
d0 = randn(100,100);
pMov2b.XLim = [1 100];
pMov2b.YLim = [1 100];
im2b = image(pMov2b,'CData',flipud(d0));
im2b.CDataMapping = 'scaled';
im2b.ButtonDownFcn = {@ui.mov.movClick,f,'sel','evt'};  % show clicked event
pMov2b.DataAspectRatio = [1 1 1];
bMov2.Spacing = 3;
pMovTop.Selection = 1;

% controls --------------
% image tools
uix.Empty('Parent',pImgTool);
uicontrol(pImgTool,'String','Pan','Tag','pan','Callback',{@ui.mov.movPan,f});
uicontrol(pImgTool,'String','Zoom','Tag','zoom','Callback',{@ui.mov.movZoom,f});
uicontrol(pImgTool,'Style','text','String','Jump to');
uicontrol(pImgTool,'Style','edit','String','1','Callback',{@ui.mov.jumpTo,f},'Tag','jumpTo');
uicontrol(pImgTool,'Style','text','String','Playback frame rate');
uicontrol(pImgTool,'Style','edit','String','5','Tag','playbackRate');
uicontrol(pImgTool,'String','Side by side','Tag','sbs','Callback',{@ui.mov.movSideBySide,f});
uix.Empty('Parent',pImgTool);
uicontrol(pImgTool,'Style','text','String','1/1','HorizontalAlignment','right','Tag','curTime');
uix.Empty('Parent',pImgTool);
pImgTool.Spacing = 10;
pImgTool.Widths = [10,60,60,40,50,100,50,80,-1,200,10];

% view control
str00 = {'Raw','Raw + overlay','Rising map'};
uicontrol(bMov2Pop,'Style','popupmenu','String',str00,'Tag','movLType','Callback',{@ui.mov.movViewSel,f},'Value',2);
uix.Empty('Parent',bMov2Pop);
uicontrol(bMov2Pop,'Style','popupmenu','String',str00,'Tag','movRType','Callback',{@ui.mov.movViewSel,f},'Value',1);
uix.Empty('Parent',bMov2Pop);
bMov2Pop.Widths = [70,-1,70,-1];

% image play
uix.Empty('Parent',pImgCon);
uicontrol(pImgCon,'String','Play','Callback',{@ui.mov.playMov,f},'Tag','play');
uicontrol(pImgCon,'String','Pause','Callback',{@ui.mov.pauseMov,f});
h00 = uicomponent(pImgCon,'style','javax.swing.JScrollBar','Tag','sldMov','Orientation',0);  % Java
h00.AdjustmentValueChangedCallback = {@ui.mov.stepOne,f};
% uicontrol(pImgCon,'Style','slider','Min',0,'Max',100,'Value',1,'SliderStep',[0.01 0.1],...
%     'Tag','sldMov','Callback',{@stepOne,f});
uix.Empty('Parent',pImgCon);
pImgCon.Widths = [15,50,50,-1,15];

% curves
pCurve.XTick = [];
pCurve.YTick = [];
pCurve.YLim = [-0.1,0.1];

end



















