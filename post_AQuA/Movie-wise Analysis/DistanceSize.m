function DistanceSize(res)
dist = res.fts.region.landmarkDist.distAvg;
size = res.fts.basic.area;
%Distance from soma at peak
%Function of discrete distance and similarities of time curves
%Time from onset to peak and FWHM with respect to peak
%res.fts.curve
figure
scatter(size , dist);
title('Size vs Distance from Soma');
xlabel('Size ({\mum}^2)'); ylabel('Average Distance to Soma ({\mum}^2)');
% axis([0 10 0 max(dist)]);
end