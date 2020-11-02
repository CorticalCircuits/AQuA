fn = 'TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrials'
xlFile = [fn,'_interesting_frames.xlsx'];
loadp = whereverYourOriginalTifFilesAreStored;
savep = ['E:\AQuA\Output\',fn,'\'];
[dat] = xlsread([savep,xlFile]);
savep = [savep,'snippets\'];

data = zeros(size(res.datOrg));
% data = padarray(data,[5 5],'both');%% may or may not be necesary
%% Read in the tif file
for i = 1:size(data,3);
    data(:,:,i) = imread([p,fn],i);
end


%% Save the snippets as both mat and tif files
for i = 1:length(dat)
    disp(['Writing snippet #',num2str(i),' of ',num2str(length(dat))])
    dataSnip = data(:,:,dat(i,1):dat(i,2));
    save([savep,'dataSnip',num2str(i),'.mat'],'dataSnip')
    for fr = 1:size(dataSnip,3)
        imwrite(dataSnip(:,:,fr),[savep,'dataSnip',num2str(i),'.tif'],'writemode','append');
    end

end

    



