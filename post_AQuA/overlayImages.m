function overlayImages(under, over, alphaData, varargin)
% function overlayImages(under, over, alphaData, varargin)
% will display one image overlaid on another, with options for the degree
% of transparency and colormap.  Useful for displaying either ROIs over a
% structural image, or functional response maps over a structural image
% jms July 2014
trans = 0.2;
cmap = 'hot';
   
if ~isempty(varargin)
% if length(varargin)>0
%     if varargin{1}
        trans = varargin{1};
%     else
%         trans = .4;
%     end
    if trans > 1
        trans = trans/100;
    end
    if length(varargin) >1
        if varargin{2}
            cmap = varargin{2};
%         else
%             cmap = 'hot';
        end
    end
     if length(varargin) == 3
%         if varargin{3}
            cLims = varargin{3};
%         else
%         end
    end
end    
if ~exist('cmap','var')
    cmap = 'hot';
end
%% check that underlay is RGB, else make gray RGB from index
if ndims(under) == 2
    under = repmat(scale_clip(under),[1 1 3]);
elseif ndims(under) == 3
    if size(under,3) == 3
    else
        error('Indexed CData must be size [MxN], TrueColor CData must be size [MxNx3]')
    end
end

% figure
imagesc(under)
hold on
if exist('cLims','var')
    h = imagesc(over,cLims);
else
    h = imagesc(over);
end
colormap(cmap);
c = colormap;
% c2 = c(randperm(length(c)),:);
% colormap(c2)
axis image
set(h,'AlphaData',alphaData.*trans);
axis off
% trans

        
