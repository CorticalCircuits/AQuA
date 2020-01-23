function [lmLoc,lmVal,lm3Idx] = getLocalMax3D(dat,mskST,mskSig,fsz)
% getLocalMax3D find local maximum after smoothing

if ~exist('mskST','var')
    mskST = ones(size(dat));
end

[H,W,L,T] = size(dat);
% datV = zeros(size(dat));
% gap = 3;
% for tt=1:T
%     datV(:,:,tt) = std(dat(:,:,max(tt-gap,1):min(tt+gap,T)),[],3);
% end
datSmo1 = zeros(size(dat));
for i = 1:L
    datIn = permute(dat(:,:,i,:),[1,2,4,3]);
    datSmo1(:,:,i,:) = imgaussfilt3(datIn,fsz);
end

lm3 = imregionalmax(datSmo1);
lm3(:,:,:,1) = zeros(H,W,L);
lm3(:,:,:,end) = zeros(H,W,L);
tmp = lm3(mskST>0);
if sum(tmp(:))>0
    lm3(mskST==0) = 0;
else
    lm3(mskSig==0) = 0;
end

lm3Idx = 1*lm3; lm3Idx(lm3>0) = 1:sum(lm3(:)>0);

lmLoc = find(lm3>0);
% lmVal = dTatV(lm3>0);
lmVal = [];
end