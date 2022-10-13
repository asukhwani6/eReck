function [timeSeriesData] = uniqueData(timeSeriesData)

[lines, ~, subs] = unique(timeSeriesData(:,1));
ymeanperline = accumarray(subs, timeSeriesData(:,2), [], @mean);

timeSeriesData = [lines,ymeanperline];

end