%clear all
%clc

curr_dir = cd;

allSubFolders = genpath(curr_dir);

remain = allSubFolders;
listOfFolderNames = {};
%disp('DONE!!!!');
while true 
    [singleSubFolder, remain] = strtok(remain, ':');
    if isempty(singleSubFolder),
        break;
    end
    %disp(sprintf('%s', singleSubFolder))
    listOfFolderNames = [listOfFolderNames singleSubFolder];
end
length(listOfFolderNames)
%disp('DONE!!!!');
for i=2:1:length(listOfFolderNames)
    addpath( listOfFolderNames{i}); 
    %listOfFolderNames{i}
end
disp('DONE!!!!');
% for i=2:1:length(listOfFolderNames)
%     rmpath( listOfFolderNames{i}) ;
% end

%addpath('C:\Users\VIVA\Documents\DATA')