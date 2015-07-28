declare parameter desiredApo.

// prepare for lift-off
clearscreen.
print "Throttling up...".
lock throttle to 1.0.
lock steering to up.
wait 1.

print "Launching in:".
print "  5".
wait 1.
print "  4".
wait 1.
print "  3".
wait 1.
print "  2".
wait 1.
print "  1".
wait 1.
print "Fire main engines!".

when ship:altitude > 100 then {
  print "We have lift-off!".
}

// auto-stage
when stage:liquidfuel < 0.1 then {
  //print "Staging!".
  stage.
  preserve.
}

// auto-solar panel
when ship:altitude > 71000 then {
  AG1.
  when ship:altitude < 71000 then {
    AG2.
  }
}

// turn SAS on
SAS on.
// deal with the gears
gear on. gear off.

// wait till we've got off the ground to start controlling the throttle
until ship:altitude > 1000 { wait 0.001. }

print "Tempering throttle...".
// aim for a TWR of about 2
lock throttle to max(min((2 * (body:mu / body:position:mag^2) * mass / maxthrust), 0), 1).

// wait until we hit our apoapsis
until ship:apoapsis > desiredApo {
  wait 0.1.
}
lock throttle to 0.
print "Drifting to apoapsis...".
until ship:altitude > 70000 { wait 0.1. }

// turn towards the horizon
lock steering to heading(90, 0).

// calculate some variables
set Gk to 3.5316000*10^12.
set Radius to 600000 + apoapsis.
set sma to 600000 + ((periapsis+apoapsis)/2).
set V1 to (Gk/Radius)^.5.
set V2 to (Gk*((2/Radius)-(1/sma)))^.5.
set dV to abs(V1-V2).
set acceleration to (maxthrust/mass).
set burnTime to (dV/acceleration).

print "Burn time: " + burnTime.