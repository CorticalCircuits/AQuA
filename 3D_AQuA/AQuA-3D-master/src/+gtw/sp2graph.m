function [ref,tst,refBase,s,t,idxGood] = sp2graph(df0ip,vMap0,spLst,seedIn,gapSeedHW)
% sp2graph convert super pixels to curves and graph nodes for GTW
% Input super pixels are not perfect:
% Empty or too small
% Bad corresponding curves

[H0,W0,L0,T0] = size(df0ip);

% test and refererence curves
% optionally, ignore signals after arriving peak
df0ipSmo = zeros(size(df0ip));
for i = 1:L0
    datIn = permute(df0ip(:,:,i,:),[1,2,4,3]);
    df0ipSmo(:,:,i,:) = imgaussfilt3(datIn,[1 1 1]);
end

[ih,iw,il] = ind2sub([H0,W0,L0],seedIn);
rgh = max(ih-gapSeedHW,1):min(ih+gapSeedHW,H0);
rgw = max(iw-gapSeedHW,1):min(iw+gapSeedHW,W0);
rgl = max(il-gapSeedHW,1):min(il+gapSeedHW,L0);
df00Vec = reshape(df0ip(rgh,rgw,rgl,:),[],T0);
vm00 = vMap0(rgh,rgw,rgl);
df00Vec = df00Vec(vm00>0,:);
refBase = nanmean(df00Vec,1);
refBase = imgaussfilt(refBase,1);
refBase = refBase - nanmin(refBase);

r1 = refBase;
[~,ix] = max(r1);
bw = r1*0;
bw(ix) = 1;
r2 = -imimposemin(-r1,bw);
r2(ix) = r1(ix);
r2(isinf(r2)) = nan;
refBase = r2;

df0Vec = reshape(df0ip,[],T0);
df0VecSmo = reshape(df0ipSmo,[],T0);

nSp = numel(spLst);
tst = zeros(nSp,T0);
ref = zeros(nSp,T0);
for ii=1:numel(spLst)
    sp0 = spLst{ii};
    %     if numel(sp0)>2
    % scale and baseline
    tst0smo = nanmean(df0VecSmo(sp0,:),1);
    tst0smo = tst0smo - min(tst0smo);
    k0 = max(tst0smo)/max(refBase);
    
    tst0 = nanmean(df0Vec(sp0,:),1);
    tst0g = imgaussfilt(tst0,1);
    tst0 = tst0 - min(tst0g);
    
    ref0 = refBase*k0;
    tst(ii,:) = tst0;
    ref(ii,:) = ref0;
    %     end
end

idxGood = var(tst,0,2)>1e-10;
spLst = spLst(idxGood);
tst = tst(idxGood,:);
ref = ref(idxGood,:);

% graph, at most one pair between two nodes
s = nan(nSp,1);
t = nan(nSp,1);
nPair = 0;

dh = zeros(1,27);
dw = zeros(1,27);
dl = zeros(1,27);

cnt = 1;
for i = -1:1
    for j = -1:1
        for k = -1:1
            dh(cnt) = i;
            dw(cnt) = j;
            dl(cnt) = k;
            cnt = cnt + 1;
        end
    end
spMap1 = zeros(H0,W0,L0);

for ii=1:numel(spLst)
    spMap1(spLst{ii}) = ii;
end

for ii=1:numel(spLst)
    sp0 = spLst{ii};
    [ih0,iw0,il0] = ind2sub([H0,W0,L0],sp0);
    neib0 = [];
    for jj=1:numel(dh)  % find neighbors in eight directions
        ih = ih0+dh(jj);
        iw = iw0+dw(jj);
        il = il0+dl(jj);
        idxOK = ih>0 & ih<=H0 & iw>0 & iw<=W0 & il>0 & il<=L0;
        ih = ih(idxOK);
        iw = iw(idxOK);
        il = il(idxOK);
        ihw = sub2ind([H0,W0,L0],ih,iw,il);
        if ~isempty(ihw)
            newMap = spMap1(ihw);
            newMap = unique(newMap(newMap>ii));
            newMap = setdiff(newMap,neib0);
            neib0 = union(newMap,neib0);
            for kk=1:numel(newMap)
                nPair = nPair+1;
                s(nPair) = ii;
                t(nPair) = newMap(kk);
            end
        end
    end
end
s = s(~isnan(s));
t = t(~isnan(t));

end



