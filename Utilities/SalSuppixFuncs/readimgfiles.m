function [trainFnamebycls, trainFnames,trainFilesgray,trainfilecolor] = ...
    readimgfiles(numimg,subfolders,fileNames)

k=1;
for i=1:1:length(fileNames)
    numimg = length(fileNames{i});
    %im_g = rand
    for j=1:1:numimg
        subvar = fileNames{i};
        %subfolders{i};
        subfileNames{k} = strcat(subfolders{i},'/',subvar(j).name);
        trainFnamebycls{i}{j} = strcat(subfolders{i},'/',subvar(j).name);
        k=k+1;
    end
end
trainFnames = subfileNames;

for i=1:1:length(trainFnames)
    I0 = (imread(subfileNames{i}));
    [r c h] = size(I0);
    if h==3
        I1 =rgb2gray(I0);
    else
        I1 = I0;
    end
    trainFilesgray{i} = I1;
    trainfilecolor{i} = I0;
end
