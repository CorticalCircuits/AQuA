function addConLayer(f,bLayer)
% movie
bL1 = uix.VBox('Parent',bLayer,'Spacing',1,'Padding',3);
uicontrol(bL1,'Style','text','String','--- Movie brightness/contrast ---');
% uix.Empty('Parent',bL1);
uicontrol(bL1,'Style','text','String','Min','HorizontalAlignment','left');
uicontrol(bL1,'Style','slider','Tag','sldMin','Callback',{@adjMov,f});
uix.Empty('Parent',bL1);
uicontrol(bL1,'Style','text','String','Max','HorizontalAlignment','left');
uicontrol(bL1,'Style','slider','Tag','sldMax','Callback',{@adjMov,f});
uix.Empty('Parent',bL1);
uicontrol(bL1,'Style','text','String','Brightness','HorizontalAlignment','left');
uicontrol(bL1,'Style','slider','Tag','sldBri','Callback',{@adjMov,f});
bL1.Heights = [18,15,15,3,15,15,3,15,15];

uix.Empty('Parent',bLayer);

% overlays
bL2 = uix.VBox('Parent',bLayer,'Spacing',1,'Padding',3);
uicontrol(bL2,'Style','text','String','--- Feature overlay ---');
% uix.Empty('Parent',bL2);
uicontrol(bL2,'Style','text','String','Type','HorizontalAlignment','left');
uicontrol(bL2,'Style','popupmenu','Tag','overlayDat','String',{'None'},'Callback',{@ui.chgOv,f,1});
uix.Empty('Parent',bL2);
x0 = [18,15,20,3];

uicontrol(bL2,'Style','text','String','Feature','HorizontalAlignment','left');
uicontrol(bL2,'Style','popupmenu','Tag','overlayFeature','String',{'Index'},'Enable','off');
uicontrol(bL2,'Style','text','String','Color','HorizontalAlignment','left');
uicontrol(bL2,'Style','popupmenu','Tag','overlayColor','String',{'Random','GreenRed'},'Enable','off');
x1a = [15,20,15,20];
uicontrol(bL2,'Style','text','String','Transform','HorizontalAlignment','left');
uicontrol(bL2,'Style','popupmenu','Tag','overlayTrans','String',{'None','Square root','Log10'},'Enable','off');
uicontrol(bL2,'Style','text','String','Divide','HorizontalAlignment','left');
uicontrol(bL2,'Style','popupmenu','Tag','overlayScale','String',{'None','Size'},'Enable','off');
x1b = [15,20,15,20];
uicontrol(bL2,'Style','text','String','Propagation direction','HorizontalAlignment','left');
uicontrol(bL2,'Style','popupmenu','Tag','overlayPropDi','String',{'Top','Bottom','Left','Right'},'Enable','off');
uicontrol(bL2,'Style','text','String','Landmark ID','HorizontalAlignment','left');
uicontrol(bL2,'Style','edit','Tag','overlayLmk','String','0','Enable','off','HorizontalAlignment','left');
x1c = [15,20,15,20];
uix.Empty('Parent',bL2);
x1 = [x1a,x1b,x1c,5];

bDrawBt = uix.HButtonBox('Parent',bL2,'Spacing',10,'ButtonSize',[120,20]);
uicontrol(bDrawBt,'String','Update overlay','Tag','updtFeature','Callback',{@ui.chgOv,f,2});
uicontrol(bDrawBt,'String','Read user feature','Tag','addUserFeature','Callback',{@ui.chgOv,f,0});
uix.Empty('Parent',bL2);
x2 = [20,12];

uicontrol(bL2,'Style','text','String','Min','HorizontalAlignment','left','Tag','txtMinOv','ForegroundColor',[0 0.5 0]);
uicontrol(bL2,'Style','slider','Tag','sldMinOv','Callback',{@adjMov,f},'Enable','off');
uicontrol(bL2,'Style','text','String','Max','HorizontalAlignment','left','Tag','txtMaxOv','ForegroundColor','r');
uicontrol(bL2,'Style','slider','Tag','sldMaxOv','Callback',{@adjMov,f},'Enable','off');
uicontrol(bL2,'Style','text','String','Brightness','HorizontalAlignment','left');
uicontrol(bL2,'Style','slider','Tag','sldBriOv','Callback',{@adjMov,f});
x3 = [15,15,15,15,15,15];

bL2.Heights = [x0,x1,x2,x3];
bLayer.Heights = [130,-1,440];
end


function adjMov(~,~,f)
fh = guidata(f);
scl = getappdata(f,'scl');
scl.min = fh.sldMin.Value;
scl.max = fh.sldMax.Value;
scl.bri = fh.sldBri.Value;
scl.minOv = fh.sldMinOv.Value;
scl.maxOv = fh.sldMaxOv.Value;
scl.briOv = fh.sldBriOv.Value;
setappdata(f,'scl',scl);
ui.movStep(f);
end



