function [ dyFinalGrMat,predMasterMat ] = GetDyFollowingGroupMat( dyGroupMat,dyLeaderMat,finalLeaders )
%GETDYFOLLOWINGGROUPMAT Summary of this function goes here
%   Detailed explanation goes here

N=size(finalLeaders,1);
T=size(dyGroupMat,2);
dyFinalGrMat=nan(N,T);
leadersList=1:N;
leadersList(~finalLeaders)=[];
numLeaders=size(leadersList,2);
mappingList=1:numLeaders;

predMasterMat=zeros(N,T);
for t=1:T
    currGroupMat=dyGroupMat{t}; % current groups
    currLeaderMat=dyLeaderMat{t}; % current leaders list
    filterList=ismember(currLeaderMat,leadersList); % filter following groups which are not in finalLeaders
    filterList=filterList(:);
    fileterGroupCell=currGroupMat(filterList);
    filterLeaderVec=currLeaderMat(filterList);
    if isempty(filterLeaderVec)
        continue;
    end
    for i=1:numLeaders %===== All final list leaders
        for j=1:size(filterLeaderVec,2) % current leaders at this time t
            if leadersList(i)== filterLeaderVec(j)
                groupMembersList=fileterGroupCell{j}; % extract the group members
                dyFinalGrMat(groupMembersList,t)=mappingList(i); % mapping ID to value for ploting
                predMasterMat(groupMembersList,t)=leadersList(i); % replace the group members with the leader ID
                predMasterMat(leadersList(i),t)=-2; % replace to be 0 later
            end
        end
    end
    [ overlabID ] = FindOverlapMembers( fileterGroupCell );
    if ~isempty(overlabID)
        overlabID=int64(overlabID(:)');
        dyFinalGrMat(overlabID,t)=-1;
    end
end

predMasterMat(predMasterMat==0)=-1;% replace unknown group to be -1
predMasterMat(predMasterMat==-2)=0;
end

