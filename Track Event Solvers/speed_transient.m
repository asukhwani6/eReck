function [time,  v, Ax, Ay, Fx, Fz, T, elecPower, eff, q] = speed_transient(track_length, track_radius, entry_vel, allowed_v, Ax_in, Parameters)

% define function handle for numerical solver fsolve
fun = @brakeSolve;
% intial braking distance guess
x0 = 0;
% solve for braking distance using numerical solver
braking_distance = fzero(fun,x0,[], entry_vel, allowed_v, track_radius, track_length, Ax_in, Parameters);
if braking_distance < 0
    disp('we are fucked')
elseif braking_distance > track_length
    braking_distance = track_length;
end
dAccel = track_length - braking_distance;

[accel_time, accel_v, accel_Ax, accel_Ay, accel_Fx, accel_Fz] = accel(track_radius, dAccel, entry_vel, Ax_in, Parameters);
if isempty(accel_v)
    brakeEntryV = entry_vel;
    brakeEntryAx = Ax_in;
else
    brakeEntryV = accel_v(end);
    brakeEntryAx = accel_Ax(end);
end
[brake_time, brake_v, brake_Ax, brake_Ay, brake_Fx, brake_Fz] = braking(track_radius, braking_distance, brakeEntryV, brakeEntryAx, Parameters);

% Energy calculation only with acceleration
[T, elecPower, eff, q] = calculateEnergy(accel_Fx, accel_v, accel_time, Parameters);
% Regen energy calculation only with braking
[TRegen, elecPowerRegen, effRegen, qRegen] = calculateEnergyRegen(brake_Fx, brake_v, brake_time, Parameters);

T = [T; TRegen];
elecPower = [elecPower; elecPowerRegen];
eff = [eff; effRegen];
q = [q; qRegen];


v = [accel_v, brake_v];
Ax = [accel_Ax, brake_Ax];
Ay = [accel_Ay, brake_Ay];
Fx = [accel_Fx; brake_Fx];
Fz = [accel_Fz; brake_Fz];

if ~isempty(accel_time)
    brake_time = brake_time + accel_time(end);
end

%fprintf("End Velocity %3f\n",final_v);
time = [accel_time,  brake_time];