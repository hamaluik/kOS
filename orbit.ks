declare parameter desiredAltitude.
declare parameter desiredHeading.
declare parameter stageLimit.

print "Downloading libraries.".

run fileutility.
Download("utility.ks").
run utility.
Download("ascent.ks").
Download("circularize.ks").
Download("maneuver.ks").

// make sure we can launch
if(ship:status <> "PRELAUNCH" and ship:status <> "LANDED") {
  print "ERROR: you cannot launch right now!".
  wait until false.
}

// run the ascent program
print "Executing ascent program.".
run ascent(desiredAltitude * 1000, desiredHeading, stageLimit).
lock throttle to 0.

when altitude > 70000 then {
  print "Deploying solar panels.".
  panels on.
  when altitude < 70000 then {
    print "Retracting solar panels.".
    panels off.
  }
}

// plan for circularization
print "Planning circularization burn.".
run circularize("apoapsis").

// execute the next maneuver node
print "Executing maneuver node program.".
run maneuver(stageLimit).
unlock steering.
unlock throttle.

print "Circularization complete.".
print "Engaging manual control.".
set ship:control:pilotmainthrottle to 0.
sas on.