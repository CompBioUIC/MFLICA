function [CorrMat,NetDVec,RankMat]= CreateMatFromTrajectoryTHS(TrajectoryXY,timeShiftWin,traWin,sigmaTHS)
%CREATEMATFROMTRAJECTORY Summary of this function goes here
%   Detailed explanation goes here
if (~exist('sigmaTHS','var') || isempty(sigmaTHS)),
    sigmaTHS=0.01;
end
damping=0.9;
TrajectoryX = TrajectoryXY{1,1};
TrajectoryY = TrajectoryXY{1,2};

% TrajectoryX=TrajectoryX(:,1:303); For only testing
% TrajectoryY=TrajectoryY(:,1:303); For only testing

[M,N]=size(TrajectoryX);
CorrMat =zeros (M,M,N);
NetDVec= zeros(1,N);
RankMat=zeros(M,N);
CorrMatcurr=[];
for i=1:timeShiftWin:N
    
    if (i+traWin-1) >= N && i~=1
        CorrMat(:,:,i:N)=repmat(CorrMatcurr,1,1,N-i+1);
        NetDVec(i:N)=repmat(link_density(CorrMatcurr),1,N-i+1);
        RankMat(:,i:N)=repmat(NetRanking(CorrMatcurr,damping),1,N-i+1);
        break;
    else
        TraSegmentX = TrajectoryX(:,i:(i+traWin-1));
        TraSegmentY = TrajectoryY(:,i:(i+traWin-1));
        
        %--- Create corrMat 
        CorrMatcurr= segment2Mat(TraSegmentX,TraSegmentY);
        CorrMatcurr(CorrMatcurr<sigmaTHS)=0;
        %CorrMatcurr(CorrMatcurr>=sigmaTHS)=1;
        %--- Create Link Density
		CorrMat(:,:,i:i+timeShiftWin-1)=repmat(CorrMatcurr,1,1,timeShiftWin);
        NetDVec(i:i+timeShiftWin-1)=repmat(link_density(CorrMatcurr),1,timeShiftWin);
        RankMat(:,(i:i+timeShiftWin-1))=repmat(NetRanking(CorrMatcurr,damping),1,timeShiftWin);
		
		
    end
    i
end

end

function CorrMatcurr= segment2Mat(TraSegmentX,TraSegmentY)
N= size(TraSegmentX,1);
CorrMatcurr=zeros(N,N);
PairSet={};
k=1;
for i=1:N
    tr1=[TraSegmentX(i,:);TraSegmentY(i,:)];
    for j=i+1:N
        tr2=[TraSegmentX(j,:);TraSegmentY(j,:)];
        PairSet{k}={tr1,tr2,i,j};
        k=k+1;
    end
end
ReMat=zeros(size(PairSet,2),1);
parfor k=1:size(PairSet,2)
    tr1=PairSet{k}{1};
    tr2=PairSet{k}{2};
    [~, warp]=DTW2(tr1,tr2);
    warp=warp(~isnan(warp));
    ReMat(k)=mean(sign(warp));
end
for k=1:size(PairSet,2)
    i=PairSet{k}{3};
    j=PairSet{k}{4};
    sg=ReMat(k);
    if sg>0
        CorrMatcurr(j,i)=sg;
    elseif ~isnan(sg)
        CorrMatcurr(i,j)=abs(sg);
    end
end

end

function [RankVec]=NetRanking(currNetMat,damping)
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

