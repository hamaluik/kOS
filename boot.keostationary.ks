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
Download("hohmann.ks").
Download("keostationary.ks").

run orbit(100, 90, 0).
run circularize("apoapsis").
run maneuver(0).