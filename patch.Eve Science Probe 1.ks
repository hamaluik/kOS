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
  run orbit(250, 90, 4, 1.4).

  hudtext("Eve Science Probe 1 Is 5x5!", 1, 2, 50, green, true).
  hudtext("Ready for transfer burn!", 1, 2, 50, green, true).
}