function [arLst,dActVoxDi] = getAr(dF,opts,evtSpatialMask)
% candidate regions (legacy mode)

T = size(dF,4);
dActVoxDi = false(size(dF));
for tt=1:T
    tmp = dF(:,:,:,tt);
    tmp = bwareaopen(tmp>opts.thrARScl*sqrt(opts.varEst),opts.minSize,6);     
    tmp = tmp.*evtSpatialMask;
    dActVoxDi(:,:,:,tt) = tmp;
end
arLst = bwconncomp(dActVoxDi);
arLst = arLst.PixelIdxList;

end