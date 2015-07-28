print "Prepare for launch.".

lock throttle to 1.
print "Throttle up.". wait 0.1.

lock steering to heading(90, 90).
print "Controls locked skyward.".

// countdown
print "Launch preparations complete.".
print "Launching in:".
set countdown to 5.
until countdown < 1 {
  print "  " + countdown.
  set countdown to countdown - 1.
  wait 1.
}

print "Firing main engines!".
stage.

until altitude > 500 {
  wait 0.1.
}
print "We have liftoff!".

print "Ascending to gravity tipover point".
until altitude > 1000 {
  wait 0.1.
}

print "Beginning gravity turn.".

function CalculatePitch {
  parameter alt.
  parameter flatAlt.

  if(alt < flatAlt) {
    set p to sqrt((90^2)*(1 - ((alt^2) / (flatAlt^2)))).
  }
  else {
    set p to 0.
  }

  return p.
}

function ShipTWR {
  set mth to ship:maxthrust.
  set r to ship:altitude + ship:body:radius.
  set w to ship:mass * ship:body:mu / r / r.
  return mth/w.
}

function LocalG {
  set mth to ship:maxthrust.
  set r to ship:altitude + ship:body:radius.
  return ship:body:mu / r / r.
}

function HoldTWR {
  parameter twr.
}

set lastThrust to -1.
function AutoStage {
  parameter minStage.
  parameter delta.

  if(lastThrust < 0) {
    set lastThrust to ship:maxthrust.
  }

  if(ship:maxthrust < lastThrust - delta) {
    print "Thrust profile changed, staging!".
    lock throttle to 0.
    wait 0.5.
    stage.
    wait 0.5.
    lock throttle to 1.
  }
  set lastThrust to ship:maxthrust.
}

set lastThrust to ship:maxthrust.
until apoapsis > 80000 {
  // pitch!
  set pitch to CalculatePitch(ship:altitude, 40000).
  lock steering to heading(90, pitch).

  // aim for a TWR of 2.0 for the entire ascention
  lock throttle to (2 * LocalG() * ship:mass / ship:maxthrust).

  // check to see if we need to stage
  AutoStage(0, 10).

  // don't update too frequently
  wait 0.1.
}

lock throttle to 0.
print "Apoapsis reached!".

WHEN altitude > 70000 THEN {
  PRINT "Activating power and communications".
  AG1 ON.
}

print "Calculating circularization burn....".
set r_a to ship:apoapsis + ship:body:radius.
set r_p to ship:periapsis + ship:body:radius.
set circDV to (sqrt(body:mu / r_a) - sqrt((2 * r_p * body:mu) / (r_a * (r_p + r_a)))).
print "Burn will consume " + circDV + " m/s!".
set circAccel to ship:maxthrust / ship:mass.
set circTime to circDV / circAccel.
print "And take " + round(circTime) + " seconds!".

print "Creating maneuver node...".
set circNode to node(time:seconds + eta:apoapsis, 0, 0, circDV).
add circNode.

print "Preparing for circularization burn...".
lock steering to heading(90, 0).

print "Waiting until circularization burn start in " + round(eta:apoapsis - (circTime / 2)) + " s...".

//wait until eta:apoapsis < ((circTime / 2) + 10).
//print "Circularization burn in T-10s".

wait until eta:apoapsis < (circTime / 2).

print "Begin circularization burn!".
lock throttle to 1.
set startDV to circDV.
set lastThrust to ship:maxthrust.
until ship:periapsis > 70000 {
  lock steering to circNode.

  AutoStage(0, 10).
  wait 0.1.
}
print "Circularization complete!".

set ship:control:pilotmainthrottle to 0.
print "<TERMINATED>".