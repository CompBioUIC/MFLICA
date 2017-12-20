function [ accAssignment,leaderPrecision,leaderRecall,leaderFscore ] = SimAccCal( predMasterMat,knownMasterMat,ActFilter )
%SIMACCCAL Summary of this function goes here
%   Detailed explanation goes here
knownMasterMat(knownMasterMat==-1)=0; % change post leader inx = -1
leaderInxMat=(knownMasterMat==0);
predLeaderInxMat=(predMasterMat==0);
T=size(predLeaderInxMat,2);
TPvec = zeros(1,T);
FPvec = zeros(1,T);
FNvec = zeros(1,T);
TNvec = zeros(1,T);
for t=1:T
    currKnownLeaders= leaderInxMat(:,t);
    currPredLeaders=predLeaderInxMat(:,t);
    leaderInxFilter = currKnownLeaders | currPredLeaders;
    currKnownLeaders=currKnownLeaders(leaderInxFilter);
    currPredLeaders=currPredLeaders(leaderInxFilter);
    TP=currKnownLeaders & currPredLeaders;
    FP=~currKnownLeaders & currPredLeaders;
    FN=currKnownLeaders & ~ currPredLeaders;
    TN=~currKnownLeaders & ~ currPredLeaders;
    TPvec(t) = sum(TP);
    FPvec(t) = sum(FP);
    FNvec(t) = sum(FN);
    TNvec(t) = sum(TN);
end

precisionVec = TPvec./(TPvec + FPvec);
recallVec = TPvec./(TPvec + FNvec);
FscoreVec = 2*precisionVec.*recallVec./(precisionVec+recallVec);

precisionVec(isnan(precisionVec))=0;
recallVec(isnan(recallVec))=0;
FscoreVec(isnan(FscoreVec))=0;

leaderPrecision = mean(precisionVec(ActFilter));
leaderRecall = mean(recallVec(ActFilter));
leaderFscore = 2*leaderPrecision.*leaderRecall./(leaderPrecision+leaderRecall);

accAssignment=mean(predMasterMat==knownMasterMat,1);
accAssignment=mean(accAssignment(ActFilter));
end

