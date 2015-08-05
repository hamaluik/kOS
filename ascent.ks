declare parameter desiredAltitude.
declare parameter desiredHeading.
declare parameter stageLimit.
declare parameter targetTWR.

run utility.

print "Prepare for launch.".

lock throttle to 1.
print "Throttle up.". wait 0.1.
set startRoll to ship:facing:roll.
lock steering to up + r(0, 0, startRoll).
print "Controls locked skyward.".

// countdown
print "Launch preparations complete.".
//print "Launching in:".
set countdown to 5.
until countdown < 1 {
  //print "  " + countdown.
  hudtext("Launching in " + countdown + "...", 1, 2, 50, white, true).
  set countdown to countdown - 1.
  wait 1.
}

print "Firing main engines!".
stage.

// wait for confirmed lifoff
wait until altitude > 100.
print "We have liftoff!".

lock pitch to -5 * (ship:verticalspeed / 100).
lock steering to up + r(0, pitch, 180).

// don't do anything until we get high enough
wait until ship:verticalspeed > 100.
print "Pitchover maneuver complete!".

//// wait until pitch over maneuver
//wait until altitude > 500.
//print "Beginning pitch over maneuver".
//set pitchOverPitch to 85.
//lock steering to heading(desiredHeading, pitchOverPitch).
//
//// when the pitch-over is complete, lock our steering to prograde
//when ship:facing:pitch <= (pitchOverPitch + 0.1) then {
//  when vang(ship:facing:forevector, ship:srfprograde:forevector) < 0.5 then {
//    //lock steering to heading(desiredHeading, ship:srfprograde:pitch).
//    lock steering to prograde.
//    print "Pitch over maneuver complete.".
//  }
//}

//set targetSpeed to sqrt(ship:body:mu / (desiredAltitude + ship:body:radius)).

// limit the throttle
print "Ascending to " + round(desiredAltitude / 1000, 1) + " km.".
until ship:apoapsis >= desiredAltitude {
  clearscreen.

  // autostage if necessary
  AutoStage(stageLimit, 10).

  // control the steering
  //set p to EllipticalPitch(ship:apoapsis, desiredAltitude).
  //set p to EllipticalPitch(ship:velocity:orbit:mag, targetSpeed).
  //lock steering to heading(desiredHeading, p).
  if(ship:altitude < 35000) {
    //lock steering to ship:srfprograde.
    lock pitch to -1 * (vang(ship:up:vector, ship:srfprograde:forevector)).
    if(pitch < -45) {
      lock pitch to -45.
    }
  }
  else {
    //lock steering to ship:prograde.
    lock pitch to -1 * (vang(ship:up:vector, ship:prograde:forevector)).
    if(pitch < -80) {
      lock pitch to -80.
    }
  }
  print "Pitch: " + pitch.
  print "AoA: " + vang(ship:srfprograde:forevector, ship:facing:forevector).
  //lock steering to up + r(0, 90 - EllipticalPitch(ship:apoapsis, desiredAltitude), startRoll).

  // control the throttle
  print "Max thrust: " + ship:maxthrust.
  if(ship:maxthrust > 0.1 and ship:altitude <= 35000) {
    set rAlt to ship:altitude + ship:body:radius.
    print "Orbital radius: " + rAlt.
    set gAlt to ship:body:mu / rAlt / rAlt.
    print "Local gravity: " + gAlt.
    if(ship:maxthrust < 0.1) {
      set t to 1.
    }
    else {
      set t to (targetTWR * gAlt * ship:mass / ship:maxthrust).
    }
    print "Throttle: " + t.
    lock throttle to min(max(t, 0), 1). 
  }
  else {
    lock throttle to 1.
  }
  
  wait 0.1.
}
unlock throttle.
lock throttle to 0.
set ship:control:pilotmainthrottle to 0.
print "Ascent complete.".