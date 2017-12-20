function [ avgPsi,PsiDensity ] = averageCoordinationMeasureFunc( dyGroupMat,CorrMat )
%AVERAGECOORDINATIONMEASUREFUNC Summary of this function goes here
%   Detailed explanation goes here
% For each time step, Psi is the sum of sim of pairs of following relation from
% the same faction divided by the possible number of pairs from the same faction.
T=size(CorrMat,3);
N=size(CorrMat,1);
PsiDensity=zeros(1,T);
for t=1:T
    currGroups=dyGroupMat{t}; % cell type
    deltaMat=zeros(N,N);
    nogroupInxList=true(1,N);
    if ~isempty(currGroups)
        for i=1:max(size(currGroups))
            group=currGroups{i};
            nogroupInxList(group)=false;
            if max(size(group))>1
                deltaMat(group,group)=1;
            end
        end
    end
    deltaMat(nogroupInxList,nogroupInxList)=1;
    for i=1:N
      deltaMat(i,i)=0; % filter out A->A 
    end
    currMat=CorrMat(:,:,t);
    Psi=sum(sum(currMat.*deltaMat));
    PsiDensity(t)=Psi/(0.5*sum(sum(deltaMat)) );
end
avgPsi=median(PsiDensity);
end

