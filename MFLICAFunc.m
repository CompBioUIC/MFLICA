function MFLICAFunc( traWin,inputFilename,outputFilename,crowdFlag,sigmaTHS,ActFilter )
%FLICAMULTIPLELEADERFUNC Summary of this function goes here
%   Detailed explanation goes here
% default band values
load(inputFilename); % ===== trajectories input file
T=max(size(TrajectoryXY{1}));
if (~exist('knownHircRankMat','var') || isempty(knownHircRankMat)),
    knownHircRankMat=[];
end
if (~exist('sigmaTHS','var') || isempty(sigmaTHS)),
    sigmaTHS=0.5;
end
if (~exist('ActFilter','var') || isempty(ActFilter)),
    ActFilter=true(1,T);
end

%============== input
timeShiftWin=floor(0.1*traWin);

%outputFilename = 'out.mat';
%============== process parts
if exist(outputFilename,'file')
    %load(outputFilename, 'CorrMat','NetDVec','RankMat');
    load(outputFilename);
else
    [CorrMat,NetDVec,RankMat] = CreateMatFromTrajectoryTHS(TrajectoryXY,timeShiftWin,traWin,sigmaTHS);
	
    [ dyGroupDensityMat,dyGroupMat,dyLeaderMat,dyRankedIDMat ] = DetectDyFollowingGroups( CorrMat,RankMat );
    [ avgPsi,PsiDensity ] = averageCoordinationMeasureFunc( dyGroupMat,CorrMat );
end


N= size(CorrMat,1);
% == dyGroupDensityMat is a matrix of group's following relations number vs. (N choose 2) 
% == dyGroupMat at time t, dyGroupMat{t}{k} is an ID list of members in the
% faction k which has an initiator ID dyLeaderMat{t}(k)

% this three outputs are the main output of this framework


GrDenMeanVec=mean(dyGroupDensityMat);
Psi=mean(GrDenMeanVec);
%ths1= mean(GrDenMeanVec);  % <-- Threshold#1 filter groups appear only short time with few followers 
%
ths1 = 0; % < -- set itto zero for the default; no filtering
finalLeaders=zeros(N,1);
finalLeaders(mean(dyGroupDensityMat,2)>ths1)=1;

ths2 = min(unique(NetDVec(NetDVec>0))); % <-- set to filter area that has no following relations
% Skip uncoordinate periods to evaluate the acc, pre, rec, and fscore
% [ ActFilter ] = DetectUncoordinationPeriod( dyLeaderMat );

%ActFilter=true(1,T);

% Just reform the structure of matrices and create ready-to-go output for
% evaluation
[ dyFinalGrMat,predMasterMat ] = GetDyFollowingGroupMat( dyGroupMat,dyLeaderMat,finalLeaders);

if crowdFlag ==0
[ AaccAssignment,AleaderPrecision,AleaderRecall,AleaderFscore ] = SimAccCal( predMasterMat,knownMasterMat,ActFilter );
else
[ AaccAssignment,AleaderPrecision,AleaderRecall,AleaderFscore ] = SimCrowdAccCal( predMasterMat,dyLeaderMat,knownMasterMat,knownknownMat,ActFilter );

end

if ~isempty(knownHircRankMat)
topR=3;
[ ARankT3Acc ] = SimRankAccCal( dyRankedIDMat,knownHircRankMat,knownMasterMat,dyLeaderMat,ActFilter,topR );
[ ARankT2Acc ] = SimRankAccCal( dyRankedIDMat,knownHircRankMat,knownMasterMat,dyLeaderMat,ActFilter,2 );
[ ARankT1Acc ] = SimRankAccCal( dyRankedIDMat,knownHircRankMat,knownMasterMat,dyLeaderMat,ActFilter,1 );
else
    ARankT3Acc=0;
    ARankT2Acc=0;
    ARankT1Acc=0;
end

%===== output 
VarList={'NetDVec','CorrMat','RankMat','dyGroupDensityMat','dyGroupMat','dyLeaderMat','predMasterMat'};
VarList={VarList{:}, 'ActFilter','finalLeaders','traWin','ths1','ths2','dyRankedIDMat','dyFinalGrMat'};
VarList={VarList{:},'AaccAssignment','AleaderPrecision','AleaderRecall','AleaderFscore' };
VarList={VarList{:},'ARankT3Acc','ARankT2Acc','ARankT1Acc','avgPsi','PsiDensity'};
save(outputFilename,VarList{:});

end

