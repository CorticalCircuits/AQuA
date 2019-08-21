%% Loading and Extraction
% Choose multiple .mat files to compare critical data between them
clear T

paths = uipickfiles;
file_number = numel(paths);
thresh = 50;            % Score threshold for moving events
fl = cell(1,file_number);

for n = 1:file_number
    
[p,name,ext] = fileparts(paths{n});
addpath(p);
filename = strcat(name,ext);

T(n) = load(filename);  % Data from all trials is stored here

filename = string(strsplit(filename,'_'));
filename = strsplit(filename(2),'.');
fl(n) = {filename(1)};

if isempty(T(n).res.ftsFilter.region)
    error('Landmark was not selected during PreProcessing');
end

invadingEvents(1,n) = numel(find(T(n).res.ftsFilter.region.landmarkDir.chgToward(:,1)>thresh));
evadingEvents(1,n) = numel(find(T(n).res.ftsFilter.region.landmarkDir.chgAway(:,1)>thresh));
movingEvents(1,n) = invadingEvents(n) + evadingEvents(n);
totalEvents(1,n) = numel(T(n).res.ftsFilter.region.landmarkDir.chgAway);
% Add here any other category

end
X = categorical({ 'Total' , 'Moving' , 'Invading' , 'Evading'});
Y = [totalEvents; movingEvents; invadingEvents; evadingEvents];
figure;
bar(X,Y);
legend(fl); title(T(1).res.opts.fileName); xlabel('Event Type');

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
    end
    if numel(unique(var)) > 1
        counter = counter + 1;
        index(counter) = j;
        show(1:file_number , counter) = var;
    end
end

diff = fields(index);
Table = table(string(fl'),show,'Variablenames',{'Trial','show'});
Table = splitvars(Table,'show','NewVariableNames',diff);
disp(Table);