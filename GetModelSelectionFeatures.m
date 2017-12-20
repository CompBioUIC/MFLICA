function [A] = GetModelSelectionFeatures( OrderMat,outVelConvexMat,outPosConvexMat,RankOrderMat,RankVelOutConvexMat,RankPosOutConvexMat,DuringPeriod )
%GETMODELSELECTIONFEATURES Summary of this function goes here
%   Detailed explanation goes here
% Alpha is Cx vs. Cx, Delta is PR vs. Cx.
[~,AlphaVelCxCorr,AlphaPosCxCorr]=GetAlphaCorr( OrderMat,outVelConvexMat,outPosConvexMat,RankOrderMat,RankVelOutConvexMat,RankPosOutConvexMat,DuringPeriod );
[DeltaVelCxCorr,DeltaPosCxCorr]=GetDeltaCorr( OrderMat,outVelConvexMat,outPosConvexMat,DuringPeriod );
[LeaderSup]=GetLeaderSup( OrderMat,RankOrderMat,DuringPeriod );
A=[LeaderSup, AlphaVelCxCorr,AlphaPosCxCorr,DeltaVelCxCorr,DeltaPosCxCorr];
end

