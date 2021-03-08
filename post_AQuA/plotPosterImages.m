%% AQuA Plots for Paper
close all;
%Load AQuA results file
resFile = 'cell3_3_AQuA.mat';
if ~exist('res','var')
    load(resFile);
end
evnt = 2; %Choose event to get data
lim = [res.fts.loc.t0(evnt) , res.fts.loc.t1(evnt)];
addFrames = 80; %Extra frames on plot (before and after)
frameVector = lim(1)-addFrames:1:lim(2)+addFrames;
dffCurve = res.dffMat(evnt , lim(1)-addFrames:lim(2)+addFrames , 2);
dffCurve(dffCurve<0) = 0;
dCurve = res.dffMat(evnt , lim(1)-addFrames:lim(2)+addFrames , 1);
dCurve(dCurve<0) = 0;

%% Plotting
hold on
plot(frameVector , dffCurve,'g');
plot(frameVector , dCurve,'r');
hold off