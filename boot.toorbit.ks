// chill out while we look for something to run
set ship:control:pilotmainthrottle to 0.

// utilities
copy "fileutility.ks" from 0.
run fileutility.

Download("utility.ks").
Download("orbit.ks").
Download("ascent.ks").
Download("circularize.ks").
Download("maneuver.ks").

run orbit(100, 90, 0).

set r_a to ship:apoapsis + ship:body:radius.
set r_p to ship:apoapsis + ship:body:radius.
set eccentricity to (r_a - r_p) / (r_a + r_p).
if(eccentricity >= 0.001) {
  run circularize("apoapsis").
  run maneuver(0).
}