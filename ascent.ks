declare parameter desiredAltitude.
declare parameter desiredHeading.
declare parameter stageLimit.

print "Prepare for launch.".

set local targetThrottle to 1.
lock targetThrottle to targetThrottle.
print "Throttle up.". wait 0.1.
lock steering to heading(desiredHeading, 90).
sas on.
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

// wait for confirmed lifoff
until altitude > 500 {
  wait 0.1.
}
print "We have liftoff!".

// wait until pitch over maneuver
until altitude > 1000 {
  wait 0.1.
}
print "Beginning pitch over maneuver".
lock steering to heading(desiredHeading, 80).

// when the pitch-over is complete, lock our steering to prograde
when vang(ship:facing, ship:srfprograde) < 2.5 then {
  lock steering to ship:srfprograde.
  print "Pitch over maneuver complete.".
}

// limit the throttle
print "Ascending to " + round(desiredAltitude / 1000, 1) + " km.".
until ship:apoapsis >= desiredAltitude {
  if (ship:altitude <= 35000) {
    // figure out our liquid and solid fuel thrusts
    set local maxLiquidThrust to 0.
    set local maxSolidThrust to 0.
    list engines in engs.
    until i = engs:length {
      if engs[i]:ignition {
        // figure out what type of engine it is
        if(engs[i]:wetmass <> engs[i]:drymass) {
          // it is a solid rocket
          set maxSolidThrust to maxSolidThrust + engs[i]:maxthrust.
        }
        else {
          // it is a liquid rocket
          set maxLiquidThrust to maxLiquidThrust + engs[i]:maxthrust.
        }
      }.
      set i to i + 1.
    }
    
    // now calculate our throttle to maintain a TWR of 2.0
    if(maxLiquidThrust < 0.1) {
      // if we are't using liquid engines, turn the ignition off.
      // we'll be launching anyway
      set targetThrottle to 0.
    }
    else {
      set targetThrottle to ((2 * ship:mass * LocalG()) - maxSolidThrust) / maxLiquidThrust.
    }
    
    // aim for a TWR of 2.0 in the lower atmosphere
    //set targetThrottle to (2 * LocalG() * ship:mass / ship:maxthrust). 
  }
  else {
    set targetThrottle to 1.
  }
  
  // autostage if necessary
  if(ship:stage > stageLimit) {
    AutoStage(10).
  }
  
  wait 0.001.
}
set targetThrottle to 0.
print "Ascent complete."