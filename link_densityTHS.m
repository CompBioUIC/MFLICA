function [ d ] = link_densityTHS( adj,ths )
%LINK_DENSITYTHS Summary of this function goes here
%   Detailed explanation goes here
n = numnodes(adj);
d = 2*numedgesTHS(adj,ths)/(n*(n-1));

end

function m = numedgesTHS(adj,ths)
adj=double(adj>ths);
sl=selfloops(adj); % counting the number of self-loops

if issymmetric(adj) & sl==0    % undirected simple graph
    m=sum(sum(adj))/2; 
    return
elseif issymmetric(adj) & sl>0
    sl=selfloops(adj);
    m=(sum(sum(adj))-sl)/2+sl; % counting the self-loops only once
    return
elseif not(issymmetric(adj))   % directed graph (not necessarily simple)
    m=sum(sum(sign(adj)));
    return
end
end