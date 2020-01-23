function [dat,opts] = readFolder(path,preset)
    opts = util.parseParam(preset,0);
    opts.folderPath = path;

    
    fprintf('Reading data\n');
    list = dir(path);
    T = size(list,1) - 2;
    dat = [];
    for i = 1:T
       f0 = list(i+2).name; 
       [datOrg,opts] = burst.prep1(path,f0,[],opts);  % read data
       if isempty(dat)
           dat = zeros(opts.sz(1),opts.sz(2),opts.sz(3),T);
       end
       dat(:,:,:,i) = datOrg;
    end
    
    maxDat = max(dat(:));
    dat = dat/maxDat;
    opts.maxValueDat = maxDat;
    opts.sz = [opts.sz,T];
    
end