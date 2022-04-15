function [v, t, locations] = recurEvents(velEnd, ct, v, t, locations, sp, cp, ep, optim_number, t_radius, t_length)
% Replace previously calculated velocity and time vectors with recalculated
% vectors in order to meet velocity conditions at all points on the track

sa = rad2deg(sp(2)/t_radius(ct));
velLimit = cornerFunc(cp,t_radius(ct),sa);

saNextCorner = rad2deg(sp(2)/t_radius(ct+1));
velLimitNextCorner = cornerFunc(cp,t_radius(ct+1),saNextCorner);

velReplace = [];
timeReplace = [];
updatedLocations = [];
count = 0;

% end condition
while velEnd > velLimitNextCorner
    count = count + 1;

    for velTest = linspace(v(locations(ct-1)),0,optim_number) %Guess and Check Portion
        if (t_radius(ct) == 0) && (ct < length(t_radius)) %straight
            [time_v, vel_v,~] = speed_transient(sp, t_length(ct-1),optim_number,velTest,velLimitNextCorner);
        else %corner
            [time_v, vel_v] = speed_transient_corner(sp, t_length(ct-1), velLimitNextCorner, velLimit, ep,velTest);
        end
        if (vel_v(end) - velLimitNextCorner) < ep %Check if guessed corrected
            break
        end
    end
    updatedLocations = [length(time_v), updatedLocations];
    velLimitNextCorner = velTest;
    velEnd = v(locations(ct-1));
    ct = ct-1;

    velReplace = [vel_v, velReplace] ;
    timeReplace = [time_v, timeReplace];
end

fprintf("%d track sections replaced\n",count)

% for i = 2:length(updatedLocations)-1
%     timeReplace(updatedLocations(i):updatedLocations(i+1)-1) = timeReplace(updatedLocations(i)-1);
% end
% timeReplace(updatedLocations(end):end) =
if ct ~=1
    carryOverIndices = locations(1:ct-1);
    locations = locations(1:ct-1);
    sum = 0;
    for i = 1:length(updatedLocations)
        sum = sum + updatedLocations(i);
        locations = [locations, carryOverIndices(end) + sum];
    end
    % timeReplaceLocations = locations(ct:end)-locations(ct-1);
    if count ~= 1
        ind = find(diff(timeReplace)<0);
        for i = 1:length(ind)-1
            addTime = timeReplace(ind(i));
            timeReplace(ind(i)+1:ind(i+1)) = timeReplace(ind(i)+1:ind(i+1)) + addTime;
        end
        addTime = timeReplace(ind(end));
        timeReplace(ind(end)+1:end) = timeReplace(ind(end)+1:end) + addTime;
    end
end


startReplaceInd = locations(ct);
% TODO: might be fucked up, Anson special "I hope I'm right"
v = [v(1:startReplaceInd) velReplace'];
timeCarryover = t(1:startReplaceInd);
t = [timeCarryover timeReplace+timeCarryover(end)];
