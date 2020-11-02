function cell_Comp(T)
%% Loading and Extraction
% Choose multiple .mat files to compare critical data between them
paths = uipickfiles;
file_number = numel(paths);
thresh = 50;            % Score threshold for moving events
fl = cell(1,file_number);

T(1:file_number) = struct('res',[],'SizeThr',[]);
invadingEvents = zeros(1,file_number);
evadingEvents = zeros(1,file_number);
movingEvents = zeros(1,file_number);
totalEvents = zeros(1,file_number);

for n = 1:file_number
    
[p,name,ext] = fileparts(paths{n});
addpath(p)
filename = strcat(name,ext);

dummy = load(filename);
T(n).res = dummy.res;  % Data from all trials is stored here

filename = string(strsplit(filename,'_'));
filename = strsplit(filename(2),'.');
fl(n) = {filename(1)};

if ~isfield(T(n).res,'fts')
    error('Landmark was not selected during Pre-Processing');
end

invadingEvents(1,n) = numel(find(T(n).res.fts.region.landmarkDir.chgToward(:,1)>thresh));
evadingEvents(1,n) = numel(find(T(n).res.fts.region.landmarkDir.chgAway(:,1)>thresh));
movingEvents(1,n) = invadingEvents(n) + evadingEvents(n);
totalEvents(1,n) = numel(T(n).res.fts.region.landmarkDir.chgAway);

T(n).SizeThr = SizeThr(T(n).res,0);
% Add here any other category

rmpath(p)

fprintf('File %i out of %i Loaded\n' , n , file_number);
end
clear dummy
%% More Plots?
figure %Plot for distribution of moving events (dir towards or away)
for k=1:file_number; [H , edges] = histcounts(T(k).res.fts.region.landmarkDir.chgToward(find(T(k).res.fts.basic.area>50)),100);...
        hold on; plot(edges(2:end-1) , H(2:end)); end; hold off; title('Towards');
figure %Plot for distribution of moving events (dir towards or away)
for k=1:file_number; [H , edges] = histcounts(T(k).res.fts.region.landmarkDir.chgAway(find(T(k).res.fts.basic.area>50)),100);...
        hold on; plot(edges(2:end-1) , H(2:end)); end; hold off; title('Away');

%% Plotting
X = categorical({ 'Total' , 'Moving' , 'Invading' , 'Evading'});
Y = [totalEvents; movingEvents; invadingEvents; evadingEvents];
figure;
bar(X,Y);
legend(fl,'Location','northwest'); title(T(1).res.opts.fileName);
xlabel('Event Type'); ylabel('Number of Events');
%title('Cell 3 - AQuA Post-Processing');

% Any other parameter relevant to the comparison can be added below the
%       "totalEvents(1,n) line. Make sure the path within the res structure
%       follows the ones above. Also add the title of the category in the X
%       array and the name of the variable in the Y array.

%% Table of Non-equal Parameters

fields = fieldnames(T(1).res.opts);
field_num = numel(fields);
var = zeros(1,file_number);
counter = 0;

for j = 1:42
    for k = 1:file_number
        var(1,k) = getfield(T(k).res.opts,fields{j});
        if j == 37
            var = round(var,2,'significant');
        end
    end
    if numel(unique(var)) > 1
        counter = counter + 1;
        index(counter) = j;
        show(1:file_number , counter) = var;
    end
end

if exist('index','var')
    diff = fields(index);
    Table = table(string(fl'),show,'Variablenames',{'Trial','show'});
    Table = splitvars(Table,'show','NewVariableNames',diff);
    disp(Table);
else
    disp('No difference in Parameters was Found');
end

end