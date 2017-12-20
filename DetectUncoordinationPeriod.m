function [ ActFilter ] = DetectUncoordinationPeriod( dyLeaderMat,NetDTHSVec,ths )
%DETECTNONACTIVEPERIOD Summary of this function goes here
%   Detailed explanation goes here
% ths is the thresold of the cutting point; below this is a non-activity
% period of non-activity
T=max(size(dyLeaderMat));
nonActFilter=false(1,T);
nonActFilter=NetDTHSVec<=ths;
% for i=1:T
%     if min(size(dyLeaderMat{i})) == 0 
%         nonActFilter(i)=true;
%     end
% end
ActFilter=~nonActFilter;
end

