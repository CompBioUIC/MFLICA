function [ markovChainMat,transStates,ActFilter ] = GetMarkovChain(  dyLeaderMat,NetDVec,ths2,finalLeaders,traWin )
%GETMARKOVCHAIN Summary of this function goes here
%   Detailed explanation goes here
%% leaders list
T=size(dyLeaderMat,2);
N=size(finalLeaders,1);
%%
[ ActFilter ] =DetectUncoordinationPeriod( NetDVec,ths2 );
dyLeaderMat2=dyLeaderMat;
%% Filter Non leaders out
dyLeaderMat2(ActFilter == 0) ={-1};

leadersList=1:N;
leadersList(~finalLeaders)=[];
leadersList(end+1)=-1; %==== add -1 to be a part of list
for t=1:T
    currCell=dyLeaderMat2(t);
    currCell=currCell{1};
    [s1,s2]=size(currCell);
    if ~s1 || ~s2 
        dyLeaderMat2(t)={[]};
        continue;
    end
    filter1=ismember(currCell,leadersList);
    currCell=currCell(filter1);
    dyLeaderMat2(t)={currCell};
end
%% Spread stronger previous community to the insignificant comm (stay <TW)
prevComm=dyLeaderMat2(1);
prevStrongComm={[-1]}; % start with the rest;([-1]) is the rest comm
prevPos=1;
count =0;
for t=2:T
    currComm=dyLeaderMat2(t);
    if isequal(currComm,prevComm)
        count=count+1;
    else
        if count>traWin % strong community which stays long enough
            count = 0;
            prevStrongComm=dyLeaderMat2(t-1);
            prevPos=t;
        else
            count = 0;
            dyLeaderMat2(prevPos:t-1)=prevStrongComm;
        end
    end
    prevComm=currComm;
end
%% Calculate the frequency
transStates=uniquecell(dyLeaderMat2);
M1=size(transStates,2);
markovChainMat=zeros(M1,M1);

prevRCell=dyLeaderMat2(1);
[i,j]=findTransPos(prevRCell,prevRCell,transStates);
markovChainMat(i,j)=markovChainMat(i,j)+1;

for t=2:T
    currRCell=dyLeaderMat2(t);
    [i,j]=findTransPos(prevRCell,currRCell,transStates);
    markovChainMat(i,j)=markovChainMat(i,j)+1;
    prevRCell=currRCell;
end

%% Make the sum of column equal to 1
for i=1:M1
    markovChainMat(i,i)=0;
    markovChainMat(i,:)=markovChainMat(i,:)/sum(markovChainMat(i,:));
end

end
function [row,col]=findTransPos(prevRCell,currRCell,Mat)
M=size(Mat,2);
for itr1=1:M
    if isequal(prevRCell,Mat(itr1))
        row=itr1;
        break;
    end
end

for itr2=1:M
    if isequal(currRCell,Mat(itr2))
        col=itr2;
        break;
    end
end
end

