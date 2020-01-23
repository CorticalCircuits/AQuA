%% setup
% -- preset 1: in vivo. 2: ex vivo. 3: GluSnFR
startup;  % initialize

%% setting
preset = 2;
p0 = 'D:\Aqua_Matlab\evt_3D_25_75\';  % Input folder name
pOut = 'D:\Aqua_Matlab\3DOUTPUT\';  % output folder for synthetic movie
nameOut = 'test_';  % prefix for each TIFF file


[datOrg,opts] = burst.readFolder(p0,preset);
% opts.smoXY = 1;
% opts.thrARScl = 2;
% opts.movAvgWin = 15;
% opts.minSize = 8;
% opts.regMaskGap = 0;
% opts.thrTWScl = 5;
% opts.thrExtZ = 0.5;
% opts.extendSV = 1;
% opts.cRise = 1;
% opts.cDelay = 2;
% opts.zThr = 3;
% opts.getTimeWindowExt = 10000;
% opts.seedNeib = 5;
% opts.seedRemoveNeib = 5;
% opts.thrSvSig = 1;
% opts.extendEvtRe = 0;

%% detection
[dat,dF,arLst,lmLoc,opts] = burst.actTop(datOrg,opts);  % foreground and seed detection

[svLst,~,riseX] = burst.spTop(dat,dF,lmLoc,[],opts);  % super voxel detection
% save('D:\Aqua_Matlab\AQuA-3D\For_Step3.mat','dat','datOrg','dF','svLst','riseX','opts');
% load('For_Step3.mat');
[riseLst,datR,evtLst,seLst] = burst.evtTop(dat,dF,svLst,riseX,opts);  % events
% save('Step3_Results.mat','riseLst','datR','evtLst','seLst');
% load('Step3_Results.mat');
[ftsLst,dffMat] = fea.getFeatureQuick(datOrg,evtLst,opts);

% fitler by significance level
mskx = ftsLst.curve.dffMaxZ>opts.zThr;
dffMatFilterZ = dffMat(mskx,:);
evtLstFilterZ = evtLst(mskx);
tBeginFilterZ = ftsLst.curve.tBegin(mskx);
riseLstFilterZ = riseLst(mskx);

% merging (glutamate)
evtLstMerge = burst.mergeEvt(evtLstFilterZ,dffMatFilterZ,tBeginFilterZ,opts,[]);

% reconstruction (glutamate)
if opts.extendSV==0 || opts.ignoreMerge==0 || opts.extendEvtRe>0
    [riseLstE,datRE,evtLstE] = burst.evtTopEx(dat,dF,evtLstMerge,opts);
else
    riseLstE = riseLstFilterZ; datRE = datR; evtLstE = evtLstFilterZ;
end

% feature extraction
[ftsLstE,dffMatE,dMatE] = fea.getFeaturesTop(datOrg,evtLstE,opts);
ftsLstE = fea.getFeaturesPropTop(dat,datRE,evtLstE,ftsLstE,opts);

%% gather
res = fea.gatherRes(datOrg,opts,evtLstE,ftsLstE,dffMatE,dMatE,riseLstE,datRE);
% aqua_gui(res);

%% export the movie
lblMap = zeros(size(dat));
for i = 1:numel(evtLstE)
   lblMap(evtLstE{i}) = i; 
end
writeTiff5D2(dat,lblMap,pOut,nameOut,0,datRE,[]);

%% export res file
save([pOut,nameOut,'AQuA.mat'], 'res','-v7.3');

%% export table
ftb = [pOut,nameOut,'FeatureTable.xlsx'];       % Movie Path
tb = readtable('userFeatures.csv','Delimiter',',');
if(isempty(ftsLstE.basic))
    nEvt = 0;
else
    nEvt = numel(ftsLstE.basic.area);
end
nFt = numel(tb.Name);
ftsTb = nan(nFt,nEvt);
ftsName = cell(nFt,1);
ftsCnt = 1;
dixx = ftsLstE.notes.propDirectionOrder;
lmkLst = [];

for ii=1:nFt
    cmdSel0 = tb.Script{ii};
    ftsName0 = tb.Name{ii};
    % if find landmark or direction
    if ~isempty(strfind(cmdSel0,'xxLmk')) %#ok<STREMP>
        for xxLmk=1:numel(lmkLst)
            try
                eval([cmdSel0,';']);
            catch
                fprintf('Feature "%s" not used\n',ftsName0)
                x = nan(nEvt,1);
            end
            ftsTb(ftsCnt,:) = reshape(x,1,[]);
            ftsName1 = [ftsName0,' - landmark ',num2str(xxLmk)];
            ftsName{ftsCnt} = ftsName1;
            ftsCnt = ftsCnt + 1;
        end
    elseif ~isempty(strfind(cmdSel0,'xxDi')) %#ok<STREMP>
        for xxDi=1:4
            try
                eval([cmdSel0,';']);
                ftsTb(ftsCnt,:) = reshape(x,1,[]);
            catch
                fprintf('Feature "%s" not used\n',ftsName0)
                ftsTb(ftsCnt,:) = nan;
            end            
            ftsName1 = [ftsName0,' - ',dixx{xxDi}];
            ftsName{ftsCnt} = ftsName1;
            ftsCnt = ftsCnt + 1;
        end
    else
        try
            eval([cmdSel0,';']);
            ftsTb(ftsCnt,:) = reshape(x,1,[]);            
        catch
            fprintf('Feature "%s" not used\n',ftsName0)
            ftsTb(ftsCnt,:) = nan;
        end
        ftsName{ftsCnt} = ftsName0;
        ftsCnt = ftsCnt + 1;
    end
end
featureTable = table(ftsTb,'RowNames',ftsName);
writetable(featureTable,ftb,'WriteVariableNames',0,'WriteRowNames',1);