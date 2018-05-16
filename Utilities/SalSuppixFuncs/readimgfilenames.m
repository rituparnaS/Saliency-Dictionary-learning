function [fileNames, folderNames, total_files] = readimgfilenames(datapath,datafolder,imtype)

pathOfdata        = strcat(datapath,datafolder);
allSubFolders     = genpath(pathOfdata);
remain            = allSubFolders;
listOfFolderNames = {};
while true
    [singleSubFolder, remain] = strtok(remain, ':')
    if isempty(singleSubFolder),
        break;
    end
    %disp(sprintf('%s', singleSubFolder))
    listOfFolderNames         = [listOfFolderNames singleSubFolder];
end

k=0;
for i=1:1:length(listOfFolderNames)
    %listOfFolderNames{i}
    file_type           = strcat('*.',imtype);
    filenames           = dir(fullfile(listOfFolderNames{i}, file_type));  % read all images with specified filetype
    
    if ~isempty(filenames)
        k=k+1;
        total_files(k)  = length(filenames);
        folderNames{k}  = listOfFolderNames{i};
        fileNames{k}    = dir(fullfile(folderNames{k}, file_type));
    end
    
end



