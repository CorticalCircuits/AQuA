function datx=imputeMov(datx)

T = size(datx,4);

for tt=2:T
    tmp = datx(:,:,:,tt);
    tmpPre = datx(:,:,:,tt-1);
    idx0 = find(isnan(tmp(:)));
    tmp(idx0) = tmpPre(idx0);
    datx(:,:,:,tt) = tmp;
end
for tt=T-1:-1:1
    tmp = datx(:,:,:,tt);
    tmpNxt = datx(:,:,:,tt+1);
    idx0 = find(isnan(tmp(:)));
    tmp(idx0) = tmpNxt(idx0);
    datx(:,:,:,tt) = tmp;
end

for tt=1:T
    datx(:,:,:,tt) = imgaussfilt3(datx(:,:,:,tt),[1 1 1]);
end
end