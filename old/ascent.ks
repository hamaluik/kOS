// ascent.ks: launch to designated orbital plane

@lazyglobal off.

declare parameter target_inc.
declare parameter target_lan.
declare parameter target_alt.

declare parameter turn_start_speed.
declare parameter turn_angle.

declare parameter initial_throttle.

local pitch_ramp_begin_alt to 20000.
local pitch_ramp_end_alt to 40000.

// Sometimes I forget whether I'm passing a throttle as a float or a percent.
if initial_throttle > 1 {
    set initial_throttle to initial_throttle / 100.
}.


print "Waiting for launch window.".
local next_node_is to warp_to_window_for_lan(target_lan).

local launch_azimuth to 0.
if next_node_is = "ascending" {
    set launch_azimuth to lazcalc(target_alt/1000, target_inc).
} else {
    set launch_azimuth to lazcalc(target_alt/1000, -target_inc).
}

print "Launch azimuth: " + launch_azimuth.

if launch_azimuth < 180 {
    lock great_circle_heading to arccos(cos(launch_azimuth)
        * cos(ship:latitude)).
} else {
    lock great_circle_heading to 360 - arccos(cos(launch_azimuth)
        * cos(ship:latitude)).
}.

lock flight_path_angle_sfc to 90 - vang(ship:obt:velocity:surface, up:vector).
lock flight_path_angle_obt to 90 - vang(ship:obt:velocity:orbit, up:vector).
lock flight_path_azimuth to flight_path_azimuth_for(ship).

lock target_orbit_normal to get_normal_vector(target_inc, target_lan).
lock my_orbit_normal to vcrs(
    ship:position - kerbin:position, ship:velocity:orbit).
lock rel_an to relative_ascending_node(target_orbit_normal, my_orbit_normal).
lock rel_dn to relative_ascending_node(my_orbit_normal, target_orbit_normal).

local srb to ship:partstagged("srb")[0].
local core_engine to ship:partstagged("core_engine")[0].

when srb:flameout then {
    // Jettison solids
    set srb to 0.
    lock throttle to 1.
    stage.

    when ship:altitude > 24000 then {
        // Jettison fairings
        stage.

        when core_engine:flameout then {
            // Stage core.
            set core_engine to 0.
            stage.
        }.
    }.
}.

lock throttle to initial_throttle.
stage.
print "Ignition.".
wait 1.
stage.
print "Liftoff.".

lock target_heading to great_circle_heading.
lock target_pitch to 90.
lock steering to heading(target_heading, target_pitch).

wait until ship:airspeed > turn_start_speed.
print "Initiating pitch maneuver.".
lock target_pitch to 90 - turn_angle.

wait until flight_path_angle_sfc < 90 - turn_angle.
lock target_pitch to flight_path_angle_sfc.
print "Pitch maneuver complete.".

when ship:altitude > pitch_ramp_begin_alt then {
    lock pitch_ramp_mult to (ship:altitude - pitch_ramp_begin_alt)
        / (pitch_ramp_end_alt - pitch_ramp_begin_alt).
    lock target_pitch to mix(flight_path_angle_sfc, flight_path_angle_obt,
        pitch_ramp_mult).

    when ship:altitude > pitch_ramp_end_alt then {
        lock target_pitch to flight_path_angle_obt.
    }.
}.  

wait until ship:altitude > 27000.
print "Yaw uncage.".

lock my_position to ship:position - kerbin:position.

local target_node_is to 0.
local target_node_loc to v(0,0,0).

if vdot(my_position, target_orbit_normal) > 0 {
    set target_node_is to "ascending".
    lock target_node_loc to rel_an.
} else {
    set target_node_is to "descending".
    lock target_node_loc to rel_dn.
}.

lock angle_to_target_node to vang(my_position, target_node_loc).

lock pos_at_apoapsis to positionat(
    ship, time + eta:apoapsis) - kerbin:position.

lock angle_to_apoapsis to vang(my_position, pos_at_apoapsis).

lock angle_error to angle_to_target_node - angle_to_apoapsis.

if target_node_is = "ascending" {
    lock yaw_offset to clamp_abs(-angle_error, 5).
} else {
    lock yaw_offset to clamp_abs(angle_error, 5).
}.

lock target_heading to flight_path_azimuth + yaw_offset.

wait until ship:apoapsis > target_alt.

lock throttle to 0.
set ship:control:pilotmainthrottle to 0.
unlock throttle.

lock steering to ship:srfprograde.
wait until ship:altitude > 70000.

toggle ag1.
