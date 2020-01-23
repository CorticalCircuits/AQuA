function ftsPg = getPropagationCentroidQuad(voli0,volr0,muPerPix,nEvt,ftsPg,northDi,minShow1)
% getFeatures extract local features from events
% specify direction of 'north', or anterior
% not good at tracking complex propagation

[H,W,L,T] = size(voli0);
if T==1
%     keyboard
%     return
end

% make coordinate correct
voli0 = voli0(end:-1:1,:,:,:);
volr0 = volr0(end:-1:1,:,:,:);

a = northDi(1);
b = northDi(2);
c = northDi(3);
kDi = zeros(6,3);
kDi(1,:) = [a,b,c];
kDi(2,:) = [-a,-b,-c];
kDi(3,:) = [-b,a,0];
kDi(4,:) = [b,-a,0];
kDi(5,:) = [c*a,c*b,-a*a-b*b]/sqrt(a*a+b*b);
kDi(6,:) = [-c*a,-c*b,a*a+b*b]/sqrt(a*a+b*b);

% propagation features
thr0 = minShow1:0.1:0.8;  % significant propagation (increase of reconstructed signal)
% thr0 = 0.2:0.1:0.8;
nThr = numel(thr0);
volr0(voli0==0) = 0;  % exclude values outside event
volr0(volr0<min(thr0)) = 0;
sigMap = sum(volr0>=min(thr0),4);
nPix = sum(sigMap(:)>0);

% time window for propagation
volr0Vec = reshape(volr0,[],T);
idx0 = find(max(volr0Vec,[],1)>=min(thr0));
t0 = min(idx0);
t1 = max(idx0);

% centroid of earlist frame as starting point
sigt0 = volr0(:,:,:,t0);
pospos = find(sigt0>=min(thr0));
[ih,iw,il] = ind2sub(size(sigt0),pospos);
wt = sigt0(sigt0>=min(thr0));
seedhInit = sum(ih.*wt)/sum(wt);
seedwInit = sum(iw.*wt)/sum(wt);
seedlInit = sum(il.*wt)/sum(wt);
h0 = max(round(seedhInit),1);
w0 = max(round(seedwInit),1);
l0 = max(round(seedlInit),1);
% mask for directions: north, south, west, east,forth, back
msk = zeros(H,W,L,6);
for ii=1:6
     pospos = find(ones(H,W,L));    
     [y,x,z] = ind2sub([H,W,L],pospos);
    switch ii
        case 1
            ixSel = a*(x-w0)+b*(y-h0)+c*(z-l0)>0;
        case 2
            ixSel = a*(x-w0)+b*(y-h0)+c*(z-l0)<0;
        case 3
            ixSel = -b*(x-w0)+a*(y-h0)>0;
        case 4
            ixSel = c*a*(x-w0)+c*b*(y-h0)-(a*a+b*b)*(z-l0)>0;
        case 5
            ixSel = c*a*(x-w0)+c*b*(y-h0)-(a*a+b*b)*(z-l0)<0;
        case 6
    end
    msk0 = zeros(H,W,L);
    msk0(sub2ind([H,W,L],y(ixSel),x(ixSel),z(ixSel))) = 1;
    msk(:,:,:,ii) = msk0;    
end

msk(1:h0,:,:,1) = 1;
msk(h0:end,:,:,2) = 1;
msk(:,1:w0,:,3) = 1;
msk(:,w0:end,:,4) = 1;
msk(:,:,1:l0,5) = 1;
msk(:,:,l0:end,6) = 1;

% locations of centroid
sigDist = nan(T,6,nThr);  % weighted distance for each frame (six directions)
pixNum = zeros(T,nThr);  % pixel number increase
for tt=t0:t1
    imgCur = volr0(:,:,:,tt);
    for kk=1:nThr
        imgCurThr = 1*(imgCur>=thr0(kk));
        pixNum(tt,kk) = sum(imgCurThr(:));
        for ii=1:6            
            img0 = imgCurThr.*msk(:,:,:,ii);
            pospospos = find(img0>0);
            [ih,iw,il] = ind2sub(size(img0),pospospos);
            if numel(ih)<9
                continue
            end
            seedh = mean(ih);
            seedw = mean(iw);
            seedl = mean(il);
            dh = seedh-seedhInit;
            dw = seedw-seedwInit; 
            dl = seedl-seedlInit;
            sigDist(tt,ii,kk) = sum([dw,dh,dl].*[kDi(ii,1),kDi(ii,2),kDi(ii,3)]);
        end 
    end
end

prop = nan(size(sigDist));
prop(2:end,:,:) = sigDist(2:end,:,:) - sigDist(1:end-1,:,:);

propGrowMultiThr = prop; 
propGrowMultiThr(propGrowMultiThr<0) = nan; 
propGrow = nanmax(propGrowMultiThr,[],3);
propGrow(isnan(propGrow)) = 0;
propGrowOverall = nansum(propGrow,1);

propShrinkMultiThr = prop; 
propShrinkMultiThr(propShrinkMultiThr>0) = nan; 
propShrink = nanmax(propShrinkMultiThr,[],3);
propShrink(isnan(propShrink)) = 0;
propShrinkOverall = nansum(propShrink,1);

pixNumChange = zeros(size(pixNum));
pixNumChange(2:end,:) = pixNum(2:end,:)-pixNum(1:end-1,:);
pixNumChangeRateMultiThr = pixNumChange/nPix;
pixNumChangeRate = nanmax(pixNumChangeRateMultiThr,[],2);

% output
% not sure about the resolution
ftsPg.propGrow{nEvt} = propGrow*muPerPix;
ftsPg.propGrowOverall(nEvt,:) = propGrowOverall*muPerPix;
ftsPg.propShrink{nEvt} = propShrink*muPerPix;
ftsPg.propShrinkOverall(nEvt,:) = propShrinkOverall*muPerPix;
ftsPg.areaChange{nEvt} = pixNumChange*muPerPix*muPerPix*muPerPix;
ftsPg.areaChangeRate{nEvt} = pixNumChangeRate;

ftsPg.areaFrame{nEvt} = pixNum*muPerPix*muPerPix*muPerPix;

end









