declare parameter stageLimit.

run utility.

lock throttle to 0.
sas off.

// grab our next node
set mNode to nextnode.

// figure out some information about it
set burnDV to mNode:deltav.
set burnDVMag to mNode:deltav:mag.
set burnAcceleration to ship:maxthrust / ship:mass.
set burnTime to burnDVMag / burnAcceleration.

print "Aligning with maneuver prograde.".
//sas on.
lock steering to mNode:deltav.
wait until vang(ship:facing:forevector, mNode:deltav) < 1.
print "Ship aligned.".

// warp to 30s before the burn time
print "Maneuver burn scheduled for " + round(mNode:eta - (burnTime / 2), 1) + " s from now.".
if(mNode:eta > 30) {
  print "Warping to 30s before start of burn.".
  warpto(time:seconds + mNode:eta - (burnTime / 2) - 30). 
  print "Warp complete.".
}

// wait for it...
print "Waiting to begin burn...".
wait until (vang(ship:facing:forevector, mNode:deltav) < 1) or (mNode:eta <= (burnTime / 2)).
warpto(time:seconds + mNode:eta - (burnTime / 2)).
wait until mNode:eta <= (burnTime / 2).

print "Burn is go!".
lock throttle to 1.

// wait until we get to 2s left
until burnTime <= 2 {
  // autostage if necessary
  AutoStage(stageLimit, 10).

  // constantly update the acceleration and time left
  set burnAcceleration to ship:maxthrust / ship:mass.
  if burnAcceleration > 0.001 {
    set burnTime to mNode:deltav:mag / burnAcceleration.
  }
  wait 0.1.
}

print "Burn almost complete, throttling back".
until false {
  // autostage if necessary
  AutoStage(stageLimit, 10).

  // cut the throttle completely if the node prograde flips around and we've somehow passed it!
  if(vdot(burnDV, mNode:deltav) < 0) {
    lock throttle to 0.
    break.
  }
  
  // throttle back linearly
  set burnAcceleration to ship:maxthrust / ship:mass.
  if(burnAcceleration > 0.001) {
    lock throttle to min(mNode:deltav:mag / burnAcceleration, 1).
  }
  else {
    lock throttle to 1.
  }
  
  // if we're close, hold tight
  if(mNode:deltav:mag <= 0.1) {
    print "Finalizing burn.".
    wait until vdot(burnDV, mNode:deltav) < 0.5.
    break.
  }
  wait 0.01.
}
lock throttle to 0.

print "Maneuver burn complete!".
remove mNode.
sas on.