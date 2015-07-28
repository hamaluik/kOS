declare parameter stageLimit.

// grab our next node
set local mNode to :global:`nextnode`.

// figure out some information about it
set local targetThrottle to 0.
lock throttle to targetThrottle.
set local burnDV to mNode:deltav.
set local burnDVMag to mNode:deltav:mag.
set local burnAcceleration to ship:maxthrust / ship:mass.
set local burnTime to burnDVMag / burnAcceleration.

print "Aligning with maneuver prograde.".
rcs on.
sas on.
lock steering to mNode:deltav.
until vang(ship:facing, mNode:deltav) < 2.5 {
  wait 0.1.
}
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
wait until mNode:eta <= (burnTime / 2).

print "Burn is go!".
set targetThrottle to 1.

// wait until we get to 2s left
until burnTime <= 1 {
  // constantly update the acceleration and time left
  set burnAcceleration to ship:maxthrust / ship:mass.
  set burnTime to mNode:deltav:mag / burnAcceleration.
  
  // autostage if necessary
  if(ship:stage > stageLimit) {
    AutoStage(10).
  }
  //wait 0.1.
}

print "Burn almost complete, throttling back".
until false {
  // cut the throttle completely if the node prograde flips around and we've somehow passed it!
  if(vdot(burnDV, mNode:deltav) < 0) {
    set targetThrottle to 0.
    break.
  }
  
  // throttle back linearly
  set burnAcceleration to ship:maxthrust / ship:mass.
  set targetThrottle to min(mNode:deltav:mag / burnAcceleration, 1).
  
  // if we're close, hold tight
  if(mNode:deltav:mag <= 0.1) {
    print "Finalizing burn."
    wait until vdot(burnDV, mNode:deltav) < 0.5.
    break.
  }
  
  // autostage if necessary
  if(ship:stage > stageLimit) {
    AutoStage(10).
  }
}
lock throttle to 0.

print "Maneuver burn complete!".
remove mNode.