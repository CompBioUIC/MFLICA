function [RankVec] = GetPageRank( currNetMat,damping )
%GETPAGERANK Summary of this function goes here
%   Detailed explanation goes here

if (~exist('damping','var') || isempty(damping)),
    damping=0.9;
end
N= size(currNetMat,1);
RankVec=ones(N,1);
delta = 0.0001;
%--- Revised A to be Stochastic matrix
for i=1:N
    tt= sum(currNetMat(i,:));
    if tt == 0
        Ai=ones(1,N)/N;
        currNetMat(i,:)=currNetMat(i,:)+Ai;
    else
        currNetMat(i,:)=currNetMat(i,:)/tt;
    end
end
%--- Power Iteration
MM=1000;
for i=1:MM
    prevV=RankVec;
    RankVec=(1-damping)*ones(N,1)+damping*(currNetMat')*RankVec;
    if norm(RankVec - prevV) <delta
        break;
    end
end
RankVec=RankVec/N;

end