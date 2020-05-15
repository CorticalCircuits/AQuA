function out = scale_clip(in,per)
%function out = scale_clip(in,per);
%will scale an image to values between [0 1]
%will clip the image, such that "per" percent of pixels are saturated
%inputs: -in is image to be scaled
%        -per is the % pixels to be saturated

if nargin==1
    per = 0;
end


in = in-min(in(:));
% in = in-prctile(in(:),per);
in = max(in-prctile(in(:),per),0);
out = min(in./prctile(in(:),(100-per)),1);


