function [ group ] = BFS( adjMat,rootInx )
%BFS Summary of this function goes here
%   adjMat is a following adj matrix
group=[];
currMembers=rootInx;
auxList=1:size(adjMat,2);
while (size(currMembers,2)~=0)
    currNode=currMembers(1);
    currMembers(1)=[];
    group=[group,currNode];
    childsNodes=auxList(adjMat(:,currNode)>0);
    for i=1:size(childsNodes,2)
        currMembers(end+1)=childsNodes(i);
    end
   currMembers(ismember(currMembers,group))=[]; % delete all visited nodes
   currMembers=unique(currMembers);
end
group=int64(unique(group));
end

