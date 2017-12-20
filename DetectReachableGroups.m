function [ groups,subReachNetMats, reachNetSizes ] = DetectReachableGroups( adjMat )
%DETECTREACHABLEGROUPS Summary of this function goes here
%   Detailed explanation goes here
auxVec=1:size(adjMat,1);
auxVec=auxVec(:)';
reachNetSizes=[];
for i=1:size(auxVec,2)
    group=BFS(adjMat,auxVec(i));
    subMat=adjMat(group,group);
    d=link_density(subMat);
    reachNetSizes(i)=size(group,2);
    subReachNetMats{i}=subMat;
    groups{i}=group;
end
reachNetSizes=reachNetSizes(:);

end

