function [v, t, eventIndices] = recurEvents(velEnd, ct, v, t, eventIndices, sp, cp, ep, optim_number, t_radius, t_length)
% Replace previously calculated velocity and time vectors with recalculated
% vectors in order to meet velocity conditions at all points on the track

% determine maximum entrance velocity of previously analyzed corner
sa = rad2deg(sp(2)/t_radius(ct));
velLimit = cornerFunc(cp,t_radius(ct),sa);

% determine maximum entrance velocity of next element
saNextCorner = rad2deg(sp(2)/t_radius(ct+1));
velLimitNextCorner = cornerFunc(cp,t_radius(ct+1),saNextCorner);

velReplace = [];
timeReplace = [];
updatedLocations = [];
count = 0;

% while loop decrements ct (track element) and optimizes exit velocity to
% satisfy entry velocity requirements of subsequent corners
while velEnd > velLimitNextCorner
    fprintf('Original end velocity of element %d: %.3f\n',ct-1,velEnd) 
    count = count + 1;
    % for loop tests all velocities between previous element exit velocity
    % and 0 to determine highest velocity which satisfies braking
    % requirements
    for velTest = linspace(v(eventIndices(ct-1)),0,optim_number) %Guess and Check Portion
        if (t_radius(ct) == 0) && (ct < length(t_radius)) %straight
            [time_v, vel_v,~] = speed_transient(sp, t_length(ct),optim_number,velTest,velLimitNextCorner);
        else %corner
            [time_v, vel_v] = speed_transient_corner(sp, t_length(ct), velLimitNextCorner, velLimit, ep,velTest);
        end
        if (vel_v(end) - velLimitNextCorner) < 0 %Check if guess satisfies the braking requirement
            break
        end
    end
    updatedLocations = [length(time_v), updatedLocations];
    velLimitNextCorner = velTest; %Set limit of the next loop's corner to be the newly determined entrance velocity
    velEnd = v(eventIndices(ct-1));
    fprintf('Recalculated end velocity of element %d: %.3f\n',ct-1,vel_v(end))
    ct = ct-1;

    velReplace = [vel_v', velReplace] ;
    timeReplace = [time_v, timeReplace];
    % while loop breaks if new end velocity is lower than next corner
    % velocity requirement
end

fprintf("%d track sections replaced\n",count)

if ct ~=1
    eventIndices = eventIndices(1:ct);
    for i = 1:length(updatedLocations)
        eventIndices = [eventIndices, eventIndices(end) + updatedLocations(i)];
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


startReplaceInd = eventIndices(ct);
% TODO: might be fucked up, Anson special "I hope I'm right"
v = [v(1:startReplaceInd) velReplace];
timeCarryover = t(1:startReplaceInd);
t = [timeCarryover timeReplace+timeCarryover(end)];
