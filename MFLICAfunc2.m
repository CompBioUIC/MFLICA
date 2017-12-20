function [ DataOut ] = MFLICAfunc2( inputFilename,outputFilename,traWin,timeShiftWin,sigmaTHS )
%MFLICAFUNC2 Summary of this function goes here
% This is the main function of MFLICA for inferring multiple faction
% intervals
% INPUT DATA
% inputFilename is the input file containing 'TrajectoryXY'
% 'TrajectoryXY'a set of two-dimensional Time series 
% TrajectoryXY{1,1} M time series (X axis coordinate) where T is the time-series length
% TrajectoryXY{1,2} M time series (Y axis coordinate) where T is the time-series length
% INPUT PARAMETERS
%  1) traWin is a time window parameter (\omega)
%  2) timeShiftWin is a time shift parameter (\delta)
%  3) sigmaTHS is a similarity threshold (\sigma) 
if (~exist('sigmaTHS','var') || isempty(sigmaTHS)),
    sigmaTHS=0.5;
end
load(inputFilename);
flag=0;
if exist(outputFilename,'file')
    load(outputFilename);
    flag=1;
end
% Check if there there is no change in parameters
if flag==1 && (traWin == DataOut.traWin && DataOut.sigmaTHS == sigmaTHS && DataOut.timeShiftWin==timeShiftWin)
    NetDVec=DataOut.NetDVec;
    CorrMat=DataOut.CorrMat;
    RankMat=DataOut.RankMat;
else % if there is some change in patameters, then we recalculate the dynamic following network
    [CorrMat,NetDVec,RankMat] = CreateMatFromTrajectoryTHS(TrajectoryXY,timeShiftWin,traWin,sigmaTHS);
end
[ dyGroupDensityMat,dyGroupMat,dyLeaderMat,dyRankedIDMat ] = DetectDyFollowingGroups( CorrMat,RankMat );
[ avgPsi,PsiDensity ] = averageCoordinationMeasureFunc( dyGroupMat,CorrMat );
    
N= size(CorrMat,1);
finalLeaders=true(N,1);

[ ~,predMasterMat ] = GetDyFollowingGroupMat( dyGroupMat,dyLeaderMat,finalLeaders);
% Input source
DataOut.inputFilename=inputFilename;
% Parameters
DataOut.traWin=traWin;
DataOut.timeShiftWin=timeShiftWin;
DataOut.sigmaTHS=sigmaTHS;
% Results
DataOut.NetDVec=NetDVec;
DataOut.CorrMat=CorrMat;
DataOut.RankMat=RankMat;

DataOut.dyGroupDensityMat=dyGroupDensityMat;
DataOut.dyRankedIDMat=dyRankedIDMat;
DataOut.avgPsi=avgPsi;
DataOut.PsiDensity=PsiDensity;
DataOut.predMasterMat=predMasterMat;
DataOut.dyGroupMat=dyGroupMat;
DataOut.dyLeaderMat=dyLeaderMat;

save(outputFilename,'DataOut');
end

