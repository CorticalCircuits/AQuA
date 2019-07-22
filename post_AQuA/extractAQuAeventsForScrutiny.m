fp = 'E:\data\_paperCells\complete\tif\paper\GoodTrials\';
fn = 'TSeries-07062015-1048_EpOri(12sec)_site1_9X_4Hz_Astro1_0.8ISO_v3-000_ALGoodTrials.tif';

frames2read = 198:217;
I = imfinfo([fp,fn]);
data = zeros(I(1).Height,I(1).Width,length(frames2read));
for i = 1:length(frames2read)
    data(:,:,i) = imread([fp,fn],frames2read(i));
end
savefn = [fn(1:end-4),'_Frames',num2str(frames2read(1)),'-',num2str(frames2read(end)),'.mat']
save('savefn','data')
