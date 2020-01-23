function [validMap,twMap] = getValidMap(twMap,fiux,pixBad,isInit)
% GetValidMap Initial time windows and correlation for each new pixel from neighbors

% dh = [0 0 0 1 -1];
% dw = [0 -1 1 0 0];
% dh = [0 -1 0 1 -1 1 -1 0 1];
% dw = [0 -1 -1 -1 0 0 1 1 1];

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

% st0 = zeros(3,3); st0(1:3,2)=1; st0(2,1:3)=1;

[H,W,L] = size(fiux);
validMap = zeros(H,W,L);
diStep = 1;

mapStart = fiux;
mapStart(pixBad>0) = 0;
nNew = 0;
for kk=1:diStep
    %validMapNew = imdilate(mapStart,st0);
    validMapNew = imdilate(mapStart,strel('cube',3));
    if ~isInit
        validMapNew = validMapNew - mapStart;        
    end
    nNew = nNew + sum(validMapNew(:));
    validMapNew(pixBad>0) = 0;
    ihw = find(validMapNew);
    [ih,iw,il] = ind2sub([H,W,L],ihw);
    twx = zeros(1,5);  % initial time window
    for ii=1:numel(ihw)
        ih0 = ih(ii);
        iw0 = iw(ii);
        il0 = il(ii);
        for jj=1:numel(dh)
            ih1 = ih0 + dh(jj);
            iw1 = iw0 + dw(jj);
            il1 = il0 + dl(jj);
            if ih1<1 || ih1>H || iw1<1 || iw1>W || il1<1 || il1>L
                continue
            end
            if mapStart(ih1,iw1,il1)>0
                ihw1 = sub2ind([H,W,L],ih1,iw1,il1);
                twx = twMap(ihw1,:);
                break
            end
        end
        twMap(ihw(ii),:) = twx;
    end
    validMap = validMap + validMapNew;
    mapStart = mapStart + validMapNew;
end

end







