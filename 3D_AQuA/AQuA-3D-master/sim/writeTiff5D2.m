function writeTiff5D2(datOut,labelMovie,pOut,nameOut,sigmaIn,datR,dF)
    % writeTiff5D export 3D+channel+time data
    %
    % datOut: the 4D data with HxWxDxT, where D is the number of z-stack
    % labelMovie: same size as datOut. Voxels with positive values will be shown in red. 
    %             Set to [] to ignore it.
    % pOut: output folder
    % nameOut: name for each output TIFF file
    % sigmaIn: added noise standard deviation
    %
    % each 3D+channel is save in one TIFF file, stacking along Z direction
    %
    % TODO: use differnt colors for differnt events according to labelMovie
    % TODO: replace labelMovie with evtLst
    
    % color
    if ~isempty(labelMovie)
        evtLst = label2idx(labelMovie);
        nEvt = numel(evtLst);
        col0 = zeros(nEvt,3);
        for nn=1:nEvt
            x = rand(1,3);
            while (x(1)>0.8 && x(2)>0.8 && x(3)>0.8) || sum(x)<1
                x = rand(1,3);
            end
            x = x/max(x);
            col0(nn,:) = x;
        end

        scl = 0.7;
        sclc = 1-scl;
    end
    for ii=1:size(datOut,4)
        if mod(ii,10)==0
            fprintf('Frame %d\n',ii)
        end
        x = datOut(:,:,:,ii);
        
        if isa(x,'uint8')
            x = double(x)/255;
        end
        if sigmaIn>0
            x = x+randn(size(x))*sigmaIn;
        end
        if ~isempty(labelMovie)
            dR = double(datR(:,:,:,ii))/255;
            label = labelMovie(:,:,:,ii);
            lbl = label>0;
            y = zeros(size(x,1),size(x,2),3,size(x,3));
            xr = x;
            xg = x;
            xb = x;
            xr(lbl) = col0(label(lbl),1);
            xg(lbl) = col0(label(lbl),2);
            xb(lbl) = col0(label(lbl),3);
            xr(lbl) = xr(lbl).*dR(lbl);
            xg(lbl) = xg(lbl).*dR(lbl);
            xb(lbl) = xb(lbl).*dR(lbl);
            for tt=1:size(x,3)
                y(:,:,1,tt) = x(:,:,tt)*scl + xr(:,:,tt)*sclc;
                y(:,:,2,tt) = x(:,:,tt)*scl + xg(:,:,tt)*sclc;
                y(:,:,3,tt) = x(:,:,tt)*scl + xb(:,:,tt)*sclc;
            end
            
            if(~isempty(dF))
                y2 = y;
                y1 = zeros(size(x,1),size(x,2),3,size(x,3));
                y = zeros(2*size(x,1),size(x,2),3,size(x,3));
                
                for tt=1:size(x,3)
                    y1(:,:,1,tt) = dF(:,:,tt,ii);
                    y1(:,:,2,tt) = dF(:,:,tt,ii);
                    y1(:,:,3,tt) = dF(:,:,tt,ii);
                end
                
                
                y(1:size(x,1),:,:,:) = y1;
                y(size(x,1)+1:end,:,:,:) = y2;
            end
            
        else
            y = x;
        end
        writeTiffSeq([pOut,nameOut,sprintf('%04d',ii),'.tif'],y,8);
    end
    
end