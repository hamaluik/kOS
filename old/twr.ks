clearscreen.
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

until ship:altitude > 30000 {
  calculateTWR().
  print "TWR: " + round(twr, 2) + "    " at (0, 0).
  wait 0.001.
}