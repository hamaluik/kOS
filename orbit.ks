declare parameter desiredAltitude.
declare parameter desiredHeading.
declare parameter stageLimit.
declare parameter targetTWR.

print "Downloading libraries.".

run fileutility.
Download("utility.ks").
run utility.
Download("ascent.ks").
Download("circularize.ks").
Download("maneuver.ks").

// make sure we can launch
if(ship:status = "PRELAUNCH" or ship:status = "LANDED") {
  // run the ascent program
  print "Executing ascent program.".
  run ascent(desiredAltitude * 1000, desiredHeading, stageLimit, targetTWR).
  lock throttle to 0.
}

// plan for circularization
print "Planning circularization burn.".
run circularize("apoapsis").

// execute the next maneuver node
print "Executing maneuver node program.".
run maneuver(stageLimit).

function eccentricity {
  local r_a to ship:apoapsis + ship:body:radius.
  local r_p to ship:periapsis + ship:body:radius.
  return (r_a - r_p) / (r_a + r_p).
}

// make sure we're in a circular orbit
until(eccentricity() < 0.001) {
  print "Eccentricity (" + eccentricity() + ") is not acceptable, adjusting...".
  print "Calculating circularization burn...".
  run circularize("apoapsis").
  print "Complete!".
  print "Executing maneuver...".
  run maneuver(stageLimit).
  print "Complete!".

}
print "Eccentricity (" + eccentricity() + ") is at acceptable levels!".

print "Circularization complete.".
print "Engaging manual control.".
set ship:control:pilotmainthrottle to 0.