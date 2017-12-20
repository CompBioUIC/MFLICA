function [ NetDTHSVec ] = NetDVecTHSCal( CorrMat,ths )
%NETDVECTHSCAL Summary of this function goes here
%   Detailed explanation goes here
T=size(CorrMat,3);
NetDTHSVec=zeros(1,T);
for t=1:T
    currMat=CorrMat(:,:,t);
    NetDTHSVec(t)=link_densityTHS( currMat,ths );
end

end

