function methodComparePlot3( RankOrderMat,RankPosOutConvexMat,RankVelOutConvexMat,TW, TS)
%METHODCOMPAREPLOT Summary of this function goes here
%   Detailed explanation goes here
DataMat=[RankOrderMat,RankVelOutConvexMat,RankPosOutConvexMat];
M=size(DataMat,1);
XLabels=[{'PageRank'},{'VelCxHull'},{'PosCxHull'}];
YLabels={};
for i=1:M
    str=sprintf('ID:%d',((i)));
    YLabels=[YLabels;{str}];
end
clf
heatmap(DataMat,XLabels,YLabels,'%0.2f','TickAngle', 45,'ColorMap', 'cool','UseFigureColormap',false,'ShowAllTicks', true,'ShowAllTicks',true,'Colorbar', true); 
xlabel('Ranking [1,M]') 
ylabel('Individuals')
title('Ranking of  individuals with different methods');
mkdir('plots');
namePlot=sprintf('plots/ComparedMethodTW%dTS%dPlot.fig',TW, TS);
saveas(gcf,namePlot);
namePlot=sprintf('plots/ComparedMethodTW%dTS%dPlot.png',TW, TS);
saveas(gcf,namePlot);
end

