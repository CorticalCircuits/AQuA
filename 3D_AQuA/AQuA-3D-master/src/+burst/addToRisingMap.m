function riseLst = addToRisingMap(riseLst,evtMap,dlyMap,nEvt,nEvt0,rgh,rgw,rgl,rgt,rgtSel)
% split the rising time map to different events
for ii=1:nEvt0
    a = find(evtMap==ii);
    [ihr,iwr,ilr] = ind2sub(size(evtMap),a);
    if ~isempty(ihr)
        rghr = min(ihr):max(ihr);
        rgwr = min(iwr):max(iwr);
        rglr = min(ilr):max(ilr);
        evtMapr = evtMap(rghr,rgwr,rglr);
        dlyMapr = (dlyMap(rghr,rgwr,rglr)+rgt(1)+rgtSel(1)-1-1).*(evtMapr==ii);
        dlyMapr(dlyMapr==0) = nan;
        rr = [];
        rr.dlyMap = dlyMapr;
        rr.rgh = min(rgh)+rghr-1;
        rr.rgw = min(rgw)+rgwr-1;
        rr.rgl = min(rgl)+rglr-1;
        riseLst{nEvt+ii} = rr;
    end
end
end