set lastThrust to -1.
function AutoStage {
  parameter minStage.
  parameter delta.

  if(stage:number <= minStage) {
    set lastThrust to ship:maxthrust.
    return.
  }

  if(lastThrust < 0) {
    set lastThrust to ship:maxthrust.
  }

  if(ship:maxthrust < lastThrust - delta) {
    print "Thrust profile changed, staging!".
    set preThrottle to throttle.
    lock throttle to 0.
    wait 0.5.
    stage.
    wait 0.5.
    lock throttle to preThrottle.
  }
  set lastThrust to ship:maxthrust.
}

function EllipticalPitch {
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
  set r to ship:altitude + ship:body:radius.
  return ship:body:mu / r / r.
}