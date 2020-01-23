function df0ip = imputeMov(df0)

T0 = size(df0,4);

df0ip = df0;
df0NanMap = sum(isnan(df0),4);
a = find(df0NanMap>0);
[ih,iw,il] = ind2sub(size(df0NanMap),a);
for ii=1:numel(ih)
    %if mod(ii,100000)==0; fprintf('%d\n',ii); end
    ih0 = ih(ii);
    iw0 = iw(ii);
    il0 = il(ii);
    x0 = squeeze(df0(ih0,iw0,il0,:));
    for tt=2:T0
        if isnan(x0(tt))
            x0(tt) = x0(tt-1);
        end
    end
    for tt=T0-1:-1:1
        if isnan(x0(tt))
            x0(tt) = x0(tt+1);
        end
    end
    x0i = x0;
    df0ip(ih0,iw0,il0,:) = x0i;
end
df0ip(isnan(df0ip)) = 0;

end