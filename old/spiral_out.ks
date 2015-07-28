// In-plane raise from parking orbit to final orbit.

@lazyglobal off.

parameter target_ap_alt.
parameter target_pe_alt.
parameter target_agp.

lock my_normal_vector to vcrs(
    ship:position - kerbin:position,
    ship:velocity:orbit).

lock periapsis_dir to angleaxis(target_agp, my_normal_vector) * 
    relative_ascending_node(v(0,-1,0),my_normal_vector).

lock apoapsis_dir to periapsis_dir * -1.

lock angle_to_periapsis to vang(
    ship:position - kerbin:position, periapsis_dir).

lock angle_to_apoapsis to vang(
    ship:position - kerbin:position, apoapsis_dir).


print "Waiting for target argument of periapsis.".

lock steering to prograde.

set warp to 4.
wait until angle_to_periapsis < 5 and vdot(ship:velocity:orbit, periapsis_dir) > 0.
set warp to 1.
wait until angle_to_periapsis < 2.
set warp to 0.
wait until angle_to_periapsis < 1.

print "Initial burn to establish periapsis.".

lock throttle to 1.

wait until ship:obt:apoapsis > target_ap_alt or 
    (ship:obt:argumentofperiapsis > target_agp + 0.004 and
        ship:obt:argumentofperiapsis < target_agp + 0.005).

lock throttle to 0.

lock pe_alt_limit to min(target_pe_alt - 50, ship:obt:apoapsis * 0.95).

print "Spiral out.".

until ship:obt:apoapsis > target_ap_alt - 50 and
        ship:obt:periapsis > target_pe_alt - 50 {

    if ship:obt:periapsis < pe_alt_limit {
        set warp to 5.
        wait until eta:apoapsis < 300.
        set warp to 4.
        wait until eta:apoapsis < 90.
        set warp to 1.
        wait until eta:apoapsis < 40.
        set warp to 0.

        wait until eta:apoapsis < 20.
        lock throttle to min(1, (target_pe_alt - ship:obt:periapsis)/2000).

        wait until ship:obt:periapsis > pe_alt_limit or (
            eta:apoapsis > 20 and abs(ship:obt:argumentofperiapsis
                - target_agp) < 0.005).
        lock throttle to 0.
    }.

    if ship:obt:apoapsis < target_ap_alt - 50 {
        set warp to 5.
        wait until eta:periapsis < 300.
        set warp to 4.
        wait until eta:periapsis < 90.
        set warp to 1.
        wait until eta:periapsis < 40.
        set warp to 0.

        wait until eta:periapsis < 20.
        lock throttle to min(1, (target_ap_alt - ship:obt:periapsis) / 2000).

        wait until ship:obt:apoapsis > target_ap_alt - 50 or (
            eta:periapsis > 20 and
            ship:obt:argumentofperiapsis > target_agp + 0.004 and
            ship:obt:argumentofperiapsis < target_agp + 0.005).
        lock throttle to 0.
    }.
}.
