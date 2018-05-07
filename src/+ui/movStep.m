function datxCol = movStep(f,n,ovOnly)
% use btSt.sbs, btSt.leftView and btSt.rightView to determine what to show

fh = guidata(f);
dat = getappdata(f,'dat');
scl = getappdata(f,'scl');
btSt = getappdata(f,'btSt');

if ~exist('ovOnly','var')
    ovOnly = 0;
end
if ~exist('n','var') || isempty(n)
    n = fh.sldMov.Value;
end

% re-scale movie
dat0 = dat(:,:,n);
if scl.map==1
    dat0 = dat0.^2;
end
dat0 = (dat0-scl.min)/max(scl.max-scl.min,0.01)*scl.bri;
datx = cat(3,dat0,dat0,dat0);
datxCol = ui.mov.addOv(f,datx,n);

if ovOnly>0
    return
end

%% overlay
if btSt.sbs==0
    fh.im.CData = flipud(datxCol);
    ui.mov.addPatchLineText(f,fh.mov);
end
if btSt.sbs==1
    viewName = {'leftView','rightView'};
    imName = {'im2a','im2b'};
    axLst = {fh.movL,fh.movR};
    for ii=1:2
        curType = btSt.(viewName{ii});
        axNow = axLst{ii};
        
        % clean all patches
        types = {'quiver','line','patch','text'};
        for jj=1:numel(types)
            h00 = findobj(axNow,'Type',types{jj});
            if ~isempty(h00)
                delete(h00);
            end
        end
        switch curType
            case 'Raw'
                fh.(imName{ii}).CData = flipud(datx);        
                ui.mov.addPatchLineText(f,axNow,n);
            case 'Raw + overlay'
                fh.(imName{ii}).CData = flipud(datxCol);
                ui.mov.addPatchLineText(f,axNow,n);
            case 'Rising map'
                ui.mov.showRisingMap(f,imName{ii},n);                                                                                                
        end        
    end    
end

%% finish
% adjust area to show
if btSt.sbs==0    
    fh.mov.XLim = scl.wrg;
    fh.mov.YLim = scl.hrg;
else
    fh.movL.XLim = scl.wrg;
    fh.movL.YLim = scl.hrg;
    fh.movR.XLim = scl.wrg;
    fh.movR.YLim = scl.hrg;
end

% frame number
ui.mov.updtMovInfo(f,n,size(dat,3));
% f.Pointer = 'arrow';

end



