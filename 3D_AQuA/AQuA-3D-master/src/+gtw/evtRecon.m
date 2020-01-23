function [evtL,evtRecon,datWarpInt] = evtRecon(spLst,cx,evtMap0,minShow)

[H,W,L] = size(evtMap0);
[nSp,T] = size(cx);

evtRecon = zeros(H*W*L,T);
evtL = zeros(H*W*L,T);
datWarp = zeros(H,W,L,T);
seedMap1 = zeros(H,W,L);
for ii=1:nSp
    sp0 = spLst{ii};
    x0 = cx(ii,:);
    evtRecon(sp0,:) = repmat(x0,numel(sp0),1);
    l0 = mode(evtMap0(sp0));
    t0 = find(x0>=minShow,1);
    t1 = find(x0>=minShow,1,'last');
    evtL(sp0,t0:t1) = l0;
    [ih,iw,il] = ind2sub([H,W,L],sp0);
    datWarp(round(mean(ih)),round(mean(iw)),round(mean(il)),:) = x0;
    seedMap1(round(mean(ih)),round(mean(iw)),round(mean(il))) = ii;
end
evtRecon = reshape(evtRecon,H,W,L,T);
evtL = reshape(evtL,H,W,L,T);

% smoothing
% for tt=1:T
%     tmp = evtRecon(:,:,tt);
%     tmp1 = imgaussfilt(tmp,0.5);
%     tmp1(tmp==0) = 0;
%     evtRecon(:,:,tt) = tmp1;    
% end

% interpolation (optional)
datWarpInt = zeros(H,W,L,T);

end
