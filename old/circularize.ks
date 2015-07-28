// circularize.ks
// Circularize near apoapsis, attempting to set inclination to
//  parameter `target_inclination`.

parameter target_inclination.

print "Waiting for apoapsis.".
wait 1.
if eta:apoapsis > 600 {
    set warp to 4.
    wait until eta:apoapsis < 600.
}.
if eta:apoapsis > 150 {
    set warp to 3.
    wait until eta:apoapsis < 150.
}.
if eta:apoapsis > 60 {
    set warp to 1.
    wait until eta:apoapsis < 60.
}.
set warp to 0.

lock circ_spd to sqrt( body:mu / ( ship:altitude + body:radius)).
print "Target orbital speed is " + circ_spd.

lock circ_azimuth_north to arcsin(cos(target_inclination)/cos(ship:latitude)).
lock circ_azimuth_south to 180 - circ_azimuth_north.

set circ_azimuth to 0.
if ship:velocity:orbit:y > 0 {
    lock circ_azimuth to circ_azimuth_north.
} else {
    lock circ_azimuth to circ_azimuth_south.
}.

lock circ_obt_vec to
    heading(circ_azimuth,0):forevector * circ_spd.

print "Target azimuth is " + circ_azimuth.

lock burn_vec to circ_obt_vec - ship:velocity:orbit.

print "Attitude control engaged.".
lock steering to burn_vec.
wait until vang(ship:facing:forevector, burn_vec) < 1 and eta:apoapsis < 10.

print "Circularizing.".
lock throttle to min(1, burn_vec:mag / 50).

wait until burn_vec:mag < 0.1.

lock throttle to 0.
