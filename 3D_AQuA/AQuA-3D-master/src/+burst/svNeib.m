function [neibLst,exldLst] = svNeib(lblMapS,riseMap,maxRiseDly,minOverRate)

spVoxLst = label2idx(lblMapS);
nSp = numel(spVoxLst);
[H,W,L,T] = size(lblMapS);

% dh = [-1 0 1 -1 1 -1 0 1];
% dw = [-1 -1 -1 0 0 1 1 1];

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
end

% spatial location of super pixel for conflicting
spPixLst = cell(nSp,1);
for nn=1:nSp
    vox = spVoxLst{nn};
    [ih,iw,il,~] = ind2sub([H,W,L,T],vox);
    spPixLst{nn} = unique(sub2ind([H,W,L],ih,iw,il));
end

% neighbors and conflicts
lblMapSVec = reshape(lblMapS,[],T);
neibLst = cell(nSp,1);
exldLst = cell(nSp,1);
for nn=1:nSp
    if mod(nn,1000)==0; fprintf('%d\n',nn); end
    vox0 = spVoxLst{nn};
    [ih,iw,il,it] = ind2sub([H,W,L,T],vox0);
    neib0 = [];
    for ii=1:numel(dh)
        ih1 = min(max(ih + dh(ii),1),H);
        iw1 = min(max(iw + dw(ii),1),W);
        il1 = min(max(il + dl(ii),1),L);
        vox1 = sub2ind([H,W,L,T],ih1,iw1,il1,it);
        x = lblMapS(vox1);
        idxSel = find(x>0 & x~=nn);
        if ~isempty(idxSel)
            vox1Sel = vox1(idxSel);
            vox0Sel = vox0(idxSel);
            
            % delay difference in boundary pixels
            rise0 = double(riseMap(vox0Sel));
            rise1 = double(riseMap(vox1Sel));
            riseDif = abs(rise0-rise1);  % !! uint16 subtraction gives nonnegative values
            
            xSel = x(idxSel);
            xGood = xSel(riseDif<maxRiseDly);
            x = unique(xGood);
            if ~isempty(x)
                neib0 = union(neib0,x);
            end
        end
    end
    neibLst{nn} = neib0;
    
    % conflicting SPs
    ihw = unique(sub2ind([H,W,L],ih,iw,il));
    x = lblMapSVec(ihw,:);
    x = x(x>0);
    u = unique(x);
    u = u(u~=nn);
    e0 = [];
    for ii=1:numel(u)
        u1 = u(ii);
        ihw1 = spPixLst{u1};
        nInter = numel(intersect(ihw,ihw1));
        if nInter/numel(ihw)>minOverRate || nInter/numel(ihw1)>minOverRate
            e0 = union(e0,u1);
        end
    end
    exldLst{nn} = e0;
end

end




