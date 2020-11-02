paths = uipickfiles;
old_num = 0;
counter = 0;
savename = 'dataSnip_Collection.tif';

for n = 1:numel(paths)
    
    [~,name,ext] = fileparts(paths{n});
    filename = strcat(name,ext);
    info = imfinfo(filename);    
    
    for k = 1:length(info) % Read entire snippet
        frames(:,:,k + old_num) = imread(filename,k);
    end
    
    new_num = old_num + length(info) + 12;
    old_num = new_num + 1;
    cookedframes = mat2gray(frames);
    counter = counter + 1;
    
end

%% Save Tiff
for p = 1:size(frames,3)
% t.write(frames(:,:,p));
imwrite(frames(:,:,p),savename,'writemode','append');
end
disp('Tiff file is Saved');