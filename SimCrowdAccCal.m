function [ accAssignment,leaderPrecision,leaderRecall,leaderFscore ] = SimCrowdAccCal( predMasterMat,dyLeaderMat,knownMasterMat,knownknownMat,ActFilter )
%SIMACCCAL Summary of this function goes here
%   Detailed explanation goes here
[~,T]=size(knownMasterMat);
TPvec=zeros(1,T);
FPvec=zeros(1,T);
FNvec=zeros(1,T);
accVec=zeros(1,T);
for itr=1:T
    currMasterVec=knownMasterMat(:,itr);
    currKnownVec=knownknownMat(:,itr);
    predMasterVec=predMasterMat(:,itr);
    [currTrainedMembersGr,factionIDs]=FindTrainMembersGroupFromCrowdKnownVecs(currMasterVec,currKnownVec);
    if ~isempty(dyLeaderMat{itr})
        [TPvec(itr),FPvec(itr),FNvec(itr)]=GetCofMatFactors(predMasterVec,currTrainedMembersGr); % leader
        accVec(itr)= GetAssignAcc(predMasterVec,currMasterVec,currTrainedMembersGr,factionIDs) ;% assignment
    end
end
precisionVec = TPvec./(TPvec + FPvec);
recallVec = TPvec./(TPvec + FNvec);

precisionVec(isnan(precisionVec))=0;
recallVec(isnan(recallVec))=0;

leaderPrecision = mean(precisionVec(ActFilter));
leaderRecall = mean(recallVec(ActFilter));
leaderFscore = 2*leaderPrecision.*leaderRecall./(leaderPrecision+leaderRecall);

accAssignment=mean(accVec(ActFilter));
end
function [currTrainedMembersGr,factionIDs]=FindTrainMembersGroupFromCrowdKnownVecs(currMasterVec,currKnownVec)
N=max(size(currMasterVec));
LeaderFilters=currMasterVec == 0 | currMasterVec == -1 ;
factionIDs=1:N;
factionIDs=factionIDs(LeaderFilters);
currTrainedMembersGr={};
for i=1:max(size(factionIDs))
    currID=factionIDs(i);
    members=1:N;
    filter=currMasterVec == currID & currKnownVec == 1;
    filter(currID)=1;
    members=members(filter);
    currTrainedMembersGr{i}=members;
end
end
function [TP,FP,FN]=GetCofMatFactors(predMasterVec,currTrainedMembersGr)
GN=max(size(currTrainedMembersGr)); % num group
M=max(size(predMasterVec)); % num indv
markVec=ones(1,GN);
predLeadersFilter=predMasterVec == 0;
predLeaderIDs=1:M;
predLeaderIDs=predLeaderIDs(predLeadersFilter);
LN=max(size(predLeaderIDs));
TP=0;
FP=0;
for i=1:LN
    flag=1;
    for j=1:GN
        if ismember(predLeaderIDs(i),currTrainedMembersGr{j}) && markVec(j) == 1
            TP=TP+1;
            markVec(j) = 0;
            flag=0;
            break;
        end
    end
    if flag ==1
        FP=FP+1;
    end
end
FN=sum(markVec);
end
function  accVal = GetAssignAcc(predMasterVec,currMasterVec,currTrainedMembersGr,factionIDs)
M=max(size(predMasterVec)); % num indv
GN=max(size(currTrainedMembersGr)); % num group
accVal =0;
for itr=1:M
    predID = predMasterVec(itr);
    if predID == 0
        predID=itr;
    end
    masterID=currMasterVec(itr);
    if masterID ==0 || masterID == -1
        masterID=itr;
    end
    rightID=1:GN;
    rightID=rightID(factionIDs==masterID);
    rightGr=currTrainedMembersGr{rightID}; 
    if ismember(predID,rightGr)
        accVal=accVal+1;
    end
end
accVal=accVal/M;
end
