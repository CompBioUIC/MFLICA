function [ dyGroupDensityMat,dyGroupMat,dyLeaderMat,dyRankedIDMat ] = DetectDyFollowingGroups( CorrMat,RankMat )
%DETECTDYFOLLOWINGGROUPS Summary of this function goes here
%   Detailed explanation goes here

T=size(CorrMat,3);
N=size(CorrMat,1);
dyReachSizeNet=zeros(N,T);
dyGroupDensityMat=zeros(N,T);
dyGroupMat={};
dyLeaderMat={};
dyRankedIDMat={};
for t=1:T
    currMat=CorrMat(:,:,t);
    currRank =RankMat(:,t);
   % [ ~,~, reachNetSizes ] = DetectReachableGroups( currMat );
    [ leaders,groups,subNetMats, subNetDens,grSize] = DetectFollowingGroups( currMat );
   % dyReachSizeNet(:,t)=reachNetSizes;
    rankedIDsList={};
    for itr=1:size(groups,2)
        currGroup=groups{itr};
        grMat=subNetMats{itr};
        [groupRankVal] = GetPageRank( grMat );
        %groupRankVal=currRank(currGroup);
        %[~,RankOrder]=sort(groupRankVal,'descend');
        %rankedIDs=currGroup(RankOrder); % rankedIDList(1) is teh ID of the first rank
        rankedIDs=ConvertPageRankMat2RankOrderMat(groupRankVal);
        rankedIDsList{itr}=currGroup(rankedIDs);
    end
    dyGroupDensityMat(:,t)=subNetDens;  
    dyGroupMat{t}=groups(grSize>1);
    dyLeaderMat{t}=leaders(grSize>1);
    dyRankedIDMat{t}=rankedIDsList(grSize>1);
    t
end
end

