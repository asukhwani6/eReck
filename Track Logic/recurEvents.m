function [v, t, eventIndices, Ax, Ay, Fx, Fz, energy] = recurEvents(velEnd, ct, v, t, eventIndices, optim_number, t_radius, t_length, Ax, Ay, Fx, Fz, energy, Parameters)
%disp('Entered recurEvents')
% Replace previously calculated velocity and time vectors with recalculated
% vectors in order to meet velocity conditions at all points on the track

% determine maximum entrance velocity of next element
velLimitNextCorner = velLimit(t_radius(ct+1),Parameters);

velReplace = [];
timeReplace = [];
AxReplace = [];
AyReplace = [];
FxReplace = [];
FzReplace = [];
eReplace = [];
updatedLocations = [];
count = 0;

% while loop decrements ct (track element) and optimizes exit velocity to
% satisfy entry velocity requirements of subsequent corners
while velEnd > velLimitNextCorner
    % fprintf('Original end velocity of element %d: %.3f\n',ct-1,velEnd) 
    count = count + 1;
    % for loop tests all velocities between previous element exit velocity
    % and 0 to determine highest velocity which satisfies braking
    % requirements
    for velTest = linspace(v(eventIndices(ct-1)),0,optim_number) %Guess and Check Portion
        
            [time_v, vel_v, Ax_v, Ay_v, Fx_v, Fz_v, e_v] = speed_transient(t_length(ct),t_radius(ct),velTest,velLimitNextCorner, Ax(ct), Parameters);
            vel = vel_v(end);
        if (vel - velLimitNextCorner) < 0 %Check if guess satisfies the braking requirement
            break
        end
        
    end
    updatedLocations = [length(time_v), updatedLocations];
    velLimitNextCorner = velTest; %Set limit of the next loop's corner to be the newly determined entrance velocity
    velEnd = v(eventIndices(ct-1));
    % fprintf('Recalculated end velocity of element %d: %.3f\n',ct-1,vel_v(end))
    ct = ct-1;

    velReplace = [vel_v, velReplace] ;
    timeReplace = [time_v, timeReplace];
    AxReplace = [Ax_v, AxReplace];
    AyReplace = [Ay_v, AyReplace];
    FxReplace = [Fx_v; FxReplace];
    FzReplace = [Fz_v; FzReplace];
    eReplace = [e_v; eReplace];
    % while loop breaks if new end velocity is lower than next corner
    % velocity requirement
end

%fprintf("%d track sections replaced\n",count)

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
v = [v(1:startReplaceInd) velReplace];
Ax = [Ax(1:startReplaceInd) AxReplace];
Ay = [Ay(1:startReplaceInd) AyReplace];
Fx = [Fx(1:startReplaceInd,:); FxReplace];
Fz = [Fz(1:startReplaceInd,:); FzReplace];
energy = [energy(1:ct) eReplace'];
timeCarryover = t(1:startReplaceInd);
t = [timeCarryover timeReplace+timeCarryover(end)];
end
