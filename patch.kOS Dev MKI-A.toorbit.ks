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

  when ship:altitude > 70000 then {
    panels on.
  }

  print "Launching to orbit!".
  run orbit(100, 90, 0, 2).

  hudtext(ship:name + " is 5x5!", 1, 2, 50, green, true).
  hudtext("Ready for transfer burn!", 1, 2, 50, green, true).
}