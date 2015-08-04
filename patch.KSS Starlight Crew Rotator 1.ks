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

if(ship:status = "PRELAUNCH") {
  print "Prelaunch detected!".

  print "Launcing to orbit!".
  run orbit(80, 90, 1, 1.4).

  hudtext("Vessel Is 5x5!", 1, 2, 50, green, true).
}