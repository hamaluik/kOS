// general boot script
// by Kenton Hamaluik
// 2015-07-27
// portions borrowed from https://github.com/gisikw/ksprogramming

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

print "Utilities downloaded!".
copy patch.ks to 0.
switch to 0.
rename "patch.ks" to "upload.patch.Eve Science Probe 1.ks".
switch to 1.

sas off.
lock steering to sun:position.
print "Awaiting EVE SOI!".
wait until ship:body = eve.
print "Arrived in EVE SOI!".
