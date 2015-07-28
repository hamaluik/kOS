declare parameter Kp.

log "# Throttle PID Tuning" to throttle_log.
log "# Kp: " + Kp to throttle_log.
log "# t acc throt" to throttle_log.

// load the PID library
run lib_PID.

// prepare for lift-off
clearscreen.
lock steering to up.

// auto-stage
when stage:liquidfuel < 0.1 then {
  //print "Staging!".
  stage.
  preserve.
}

// turn SAS on
SAS on.

// control the throttle
set myThrottle to 1.0.
lock throttle to myThrottle.

// initialize the throttle PID
set throttlePID to PID_init(Kp, 0, 0, 0, 1).

set twr to 0.
lock logline to (time:seconds - start_time) + " " + twr + " " + myThrottle.

// calculate the TWR of the vehicle in its current state
function calculateTWR {
  set i to 0.
  set totalThrust to v(0,0,0).

  list engines in engs.
  until i = engs:length {
    if engs[i]:ignition {
      set thrust to engs[i]:facing:vector:normalized * engs[i]:thrust.
      set totalThrust to totalThrust + thrust.
    }.
    set i to i + 1.
  }

  set gravity to -up:vector:normalized * (body:mu / body:position:mag^2).
  //set v_acc to vdot(up:vector, totalThrust)/mass - gravity:mag.
  set twr to (totalThrust:mag / mass) / gravity:mag.
}

// keep going until we hit the gear key to disable things
gear on. gear off.
// wait till we've got off the ground to start controlling the throttle
until ship:altitude > 100 { wait 0.001. }
print "Tempering throttle, gear to release.".
clearscreen.
set start_time to time:seconds.
until gear {
  calculateTWR().
  set myThrottle to PID_seek(throttlePID, 2, twr).

  print "T: " + (time:seconds - start_time) at (0, 0).
  print "TWR: " + (twr) + "    " at (0, 1).
  print "Target TWR: " + 2 at (0, 2).
  print "Error: " + (abs(twr - 2) / 2) at (0, 3).

  log logline to throttle_log.
  wait 0.001.
}
//copy throttle_log to 0.