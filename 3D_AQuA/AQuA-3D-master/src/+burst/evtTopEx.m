function [riseLst,datR,evtLst,seLst] = evtTopEx(dat,dF,seLst,opts,ff)
% extend and align detected events
% mainly for glutamate data, later will be used for other data types

[H,W,L,T] = size(dat);

seMap = zeros(size(dat),'uint32');
for nn=1:numel(seLst)
    seMap(seLst{nn}) = nn;
end

% extend event time windows
if opts.extendEvtRe>0
    opts.extendSV = 1;
    seMap = burst.getSpDelay(dat,seMap,opts);
    seLst = label2idx(seMap);
end

if exist('ff','var')
    waitbar(0.2,ff);
end

% super event to events
fprintf('Detecting events ...\n')
riseLst = cell(0);
datR = zeros(H,W,L,T,'uint8');
datL = zeros(H,W,L,T);
nEvt = 0;
for nn=1:numel(seLst)
    se0 = seLst{nn};
    if isempty(se0)
        continue
    end
    fprintf('SE %d \n',nn)
    if exist('ff','var')
        waitbar(0.2+nn/numel(seLst)*0.55,ff);
    end
    
    [ih0,iw0,il0,it0] = ind2sub([H,W,L,T],se0);    
    rgh = min(ih0):max(ih0); rgw = min(iw0):max(iw0); rgl = min(il0):max(il0);
    ihw0 = unique(sub2ind([numel(rgh),numel(rgw),numel(rgl)],ih0-min(rgh)+1,iw0-min(rgw)+1,il0-min(rgl)+1));
    gapt = max(max(it0)-min(it0),5); rgt = max(min(it0)-gapt,1):min(max(it0)+gapt,T);
    
    dF0 = double(dF(rgh,rgw,rgl,rgt));
    seMap0 = seMap(rgh,rgw,rgl,rgt);
    [evtRecon,evtL,evtMap,dlyMap,nEvt0,rgtx,rgtSel] = burst.se2evt(...
        dF0,seMap0,nn,ihw0,rgh,rgw,rgl,rgt,it0,T,opts,2);

    seMap00 = seMap(rgh,rgw,rgl,rgtx);
    evtL(seMap00~=nn) = 0;  % avoid interfering other events
    evtL(evtL>0) = nEvt+1;  % only one event for each super event
    dLNow = datL(rgh,rgw,rgl,rgtx);
    dRNow = datR(rgh,rgw,rgl,rgtx);
    ixOld = evtRecon<dRNow;
    evtL(ixOld) = dLNow(ixOld);
    datR(rgh,rgw,rgl,rgtx) = max(datR(rgh,rgw,rgl,rgtx),evtRecon);  % combine events
    datL(rgh,rgw,rgl,rgtx) = evtL;
    riseLst = burst.addToRisingMap(riseLst,evtMap,dlyMap,nEvt,nEvt0,rgh,rgw,rgl,rgt,rgtSel);
    nEvt = nEvt + 1;
    %nEvt = nEvt + nEvt0;
end

evtLst = label2idx(datL);

if exist('ff','var')
    waitbar(0.8,ff);
end

end



