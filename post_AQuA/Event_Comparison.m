% Choose multiple .mat files to compare critical data between them
clear T
addpath(genpath('C:\Users\Tomas Suarez\Documents\GitHub\data\AQuA Data\AQuA Processed'));
                        % Add path to folder with processed AQuA data
file_number = 4;        % CHOOSE THE NUMBER OF FILES TO COMPARE!!!
thresh = 50;            % Score threshold for moving events
fl = cell(1,file_number);

for n = 1:file_number
filename = uigetfile('MultiSelect','on');

T(n) = load(filename);  % Data from all trials is stored here

filename = string(strsplit(filename,'_'));
filename = strsplit(filename(2),'.');
fl(n) = {filename(1)};

invadingEvents(1,n) = numel(find(T(n).res.ftsFilter.region.landmarkDir.chgToward(:,1)>thresh));
evadingEvents(1,n) = numel(find(T(n).res.ftsFilter.region.landmarkDir.chgAway(:,1)>thresh));
movingEvents(1,n) = invadingEvents(n) + evadingEvents(n);
totalEvents(1,n) = numel(T(n).res.ftsFilter.region.landmarkDir.chgAway);

end
X = categorical({'Moving' , 'Invading' , 'Evading' , 'Total'});
Y = [movingEvents; invadingEvents; evadingEvents; totalEvents];
bar(X,Y);
legend(fl); title('Comparison Chart'); xlabel('Event Type');

% Any other parameter relevant to the comparison can be added below the
% "totalEvents(1,n) line. Make sure the path within the res structure
% follows the ones above.