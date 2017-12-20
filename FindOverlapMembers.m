function [ overlabID ] = FindOverlapMembers( fileterGroupCell )
%FINDOVERLAPMEMBERS Summary of this function goes here
%   Detailed explanation goes here
M=size(fileterGroupCell,2);
overlabID={};
for i=1:M
    currGr1=fileterGroupCell{i};
    currGr1=currGr1(:);
    for j=i+1:M
        currGr2=fileterGroupCell{j};
        currGr2=currGr2(:);
        if size(currGr1,1) > size(currGr2,1)
            overlapList=ismember(currGr1,currGr2);
            if sum(overlapList) > 0
                overlabID{end+1}=currGr1(overlapList);
            end
        else
            overlapList=ismember(currGr2,currGr1);
            if sum(overlapList) > 0
                overlabID{end+1}=currGr2(overlapList);
            end
        end
    end
end
overlabID=overlabID(:);
newOverlabID=[];
for i=1:size(overlabID,1)
    currCell=overlabID{i};
    newOverlabID=[newOverlabID;currCell];
end
overlabID=newOverlabID;
end

