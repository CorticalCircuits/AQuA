function ftsBase = getBasicFeatures(voli0,muPerPix,nEvt,ftsBase)
% getFeatures extract local features from events

% basic features
ftsBase.map{nEvt} = sum(voli0,4);
vol = ftsBase.map{nEvt}>0;
a = find(vol);
[ih,iw,il] = ind2sub(size(vol),a);
surface = 0;
for l = min(il):max(il)
    v0 = vol(:,:,l);
    if l == min(il) || l == max(il)
        surface =  surface + sum(v0(:));
    else
        cc = regionprops(vol(:,:,l),'Perimeter');
        surface = surface + sum([cc.Perimeter]);
    end
end
ftsBase.surface(nEvt) = surface*muPerPix*muPerPix;
ftsBase.volume(nEvt) = sum(vol(:))*muPerPix*muPerPix*muPerPix;
ftsBase.sphericity(nEvt) = pi^(1/3)*(6*ftsBase.volume(nEvt))^(2/3)/ftsBase.surface(nEvt);

end









