function [ RankT3Acc ] = SimRankAccCal( dyRankedIDMat,knownHircRankMat,knownMasterMat,dyLeaderMat,ActFilter,topR )
%SIMRANKACCCAL Summary of this function goes here
%   Detailed explanation goes here
[M,T]=size(knownMasterMat);
RankT3AccVec=zeros(1,T);
for t=1:T
    RankList=dyRankedIDMat{t};
    currKnownMat=knownMasterMat(:,t);
    leaderIDs=1:M;
    leaderIDs=leaderIDs(currKnownMat==0);
    predLeaderIDs=dyLeaderMat{t};
    acc = 0;
    for i=1:size(predLeaderIDs,2)
        if ismember(predLeaderIDs(i),leaderIDs)
            currRankListIDs=RankList{i};
            if max(size(currRankListIDs)) < topR
                continue;
            end
            currRankListIDs=currRankListIDs(1:topR);
            trueRankOrder=knownHircRankMat(currRankListIDs,t);
            acc=acc+ mean(trueRankOrder<=topR);
        end
    end
    acc=acc/size(leaderIDs,2);
    RankT3AccVec(t)=acc;
end
RankT3AccVec(isnan(RankT3AccVec))=0;
RankT3Acc=mean(RankT3AccVec(ActFilter));
end

