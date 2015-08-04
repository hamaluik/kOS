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

  set longRangeComms to ship:partsdubbed("LongRangeComms")[0].
  set shortRangeComms to ship:partsdubbed("ShortRangeComms").

  when altitude > 70000 then {
    print "Deploying sails.".
    ag1.

    print "Deploying comms".
    for antenna in shortRangeComms {
      set m to antenna:getmodule("ModuleRTAntenna").
      m:doevent("activate").
    }
    set m to longRangeComms:("ModuleRTAntenna").
    m:doevent("activate").
    m:setfield("target", "mission-control").

    when altitude < 70000 then {
      print "Retracting sails.".
      ag2.
    }
  }

  print "Launcing to orbit!".
  run orbit(250, 90, 2).

  hudtext("Eve Base 1 Is 5x5!", 1, 2, 50, green, true).
  hudtext("Ready for transfer burn!", 1, 2, 50, green, true).
}