declare parameter desiredAltitude.
declare parameter desiredHeading.
declare parameter stageLimit.

// make sure we can launch
set terminal:width to 50.
set terminal:height to 30.
ShowHeader().
if(ship:status <> "PRELAUNCH" and ship:status <> "LANDED") {
  print "ERROR: you cannot launch right now!".
  return.
}

// run the ascent program
print "Executing ascent program.".
run ascent(desiredAltitude, desiredHeading, stageLimit).

when altitude > 70000 then {
  print "Deploying solar panels.".
  panels on.
  when altitude < 70000 then {
    print "Retracting solar panels.".
    panels off.
  }
}

// plan for circularization
print "Planning circularization burn."

set r_a to ship:apoapsis + ship:body:radius.
set r_p to ship:periapsis + ship:body:radius.
set circDV to (sqrt(body:mu / r_a) - sqrt((2 * r_p * body:mu) / (r_a * (r_p + r_a)))).
print "Burn will consume " + round(circDV, 1) + " m/s.".
set circAccel to ship:maxthrust / ship:mass.
set circTime to circDV / circAccel.
print "And take " + round(circTime, 1) + " seconds.".

print "Creating circularization maneuver.".
set circNode to node(time:seconds + eta:apoapsis, 0, 0, circDV).
add circNode.

// execute the next maneuver node
print "Executing maneuver node program.".
run maneuver(stageLimit).
unlock steering.
unlock throttle.

print "Circularization complete.".
print "Engaging manual control.".