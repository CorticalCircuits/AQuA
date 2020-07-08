function trialComp(T , fl)
%% Loading and Extraction

thresh = 50; % Score threshold for moving events

invadingEvents = zeros(1,numel(T));
evadingEvents = zeros(1,numel(T));
movingEvents = zeros(1,numel(T));
totalEvents = zeros(1,numel(T));

for n = 1:numel(T)

    if ~isfield(T(n).res,'fts')
        fprintf('Landmark was not selected during Pre-Processing');
        return
    end
    invadingEvents(1,n) = numel(find(T(n).res.fts.region.landmarkDir.chgToward(:,1)>thresh));
    evadingEvents(1,n) = numel(find(T(n).res.fts.region.landmarkDir.chgAway(:,1)>thresh));
    movingEvents(1,n) = invadingEvents(n) + evadingEvents(n);
    totalEvents(1,n) = numel(T(n).res.fts.region.landmarkDir.chgAway);
end

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
var = zeros(1,numel(T));
counter = 0;

for j = 1:42
    for k = 1:numel(T)
        var(1,k) = getfield(T(k).res.opts,fields{j});
        if j == 37
            var = round(var,2,'significant');
        end
    end
    if numel(unique(var)) > 1
        counter = counter + 1;
        index(counter) = j;
        show(1:numel(T) , counter) = var;
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