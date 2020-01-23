function [spLst,spSeedVec,spSzVec,spStd] = mov2sp(dF,validMap,spSz,s00)
% mov2sp turn dF map to super pixels

[H,W,L,~] = size(dF);

dFAvg = nanmean(dF,4);
dFAvg = imgaussfilt(dFAvg,1);
dFAvg(validMap==0) = -100;

nSp = round(H*W*L/spSz);

if size(dF,1)>1 && size(dF,2)>1 && size(dF,3)>1
    Label = superpixels3(dFAvg,nSp,'Compactness',10);
else
    Label = superpixels(squeeze(dFAvg),nSp,'Compactness',10);
end

Label(validMap==0) = 0;
lst = label2idx(Label);
spLst = lst(cellfun(@numel,lst)>0);
spSzVec = cellfun(@numel,spLst);
spStd = s00./sqrt(spSzVec);
spSeedVec = zeros(numel(spLst),1);
for ii=1:numel(spLst)
    pix0 = spLst{ii};
    [ih,iw,il] = ind2sub([H,W,L],pix0);
    ih0 = round(mean(ih));
    iw0 = round(mean(iw));
    il0 = round(mean(il));
    spSeedVec(ii) = sub2ind([H,W,L],ih0,iw0,il0);
end

end









