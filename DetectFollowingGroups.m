function [ leaders,groups,subNetMats, subNetDens, grSize] = DetectFollowingGroups( adjMat )
%DETECTFOLLOWINGGROUPS Summary of this function goes here
%   Detailed explanation goes here
N=size(adjMat,1); % num of inds
auxVec=1:size(adjMat,1);
leaders=auxVec(sum(adjMat,2) == 0);
if size(leaders,2)==0
    leaders=[];
end

leaders=leaders(:)';
subNetDens=zeros(N,1);
groups={};
subNetMats={};
grSize=[];
for i=1:size(leaders,2)
    group=BFS(adjMat,leaders(i));
    subMat=adjMat(group,group);
    d=sum(sum(subMat))/nchoosek(N,2);
    subNetDens(leaders(i))=d;
    subNetMats{i}=subMat;
    groups{i}=group;
    grSize(i)=size(group,2);
end
subNetDens=subNetDens(:)';

end

