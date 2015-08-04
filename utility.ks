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

function GetOrbitNormal {
  parameter orbitable.
  return vcrs(orbitable:up:forevector, orbitable:prograde:forevector):normalized.
}

function SwapYZ {
  parameter vec.
  return v(vec:x, vec:z, vec:y).
}

function SwappedOrbitNormal {
  parameter orbitable.
  return -1 * SwapYZ(GetOrbitNormal(orbitable)):normalized.
}

function RelativeInclination {
  parameter orbitableA.
  parameter orbitableB.
  return abs(vang(SwappedOrbitNormal(orbitableA), SwappedOrbitNormal(orbitableB))).
}

function ClampAngle {
  parameter angle.
  parameter metric.
  until angle > 0 {
    set angle to angle + metric.
  }
  return mod(angle, metric).
}

function GetEccentricAnomalyAtTrueAnomaly {
  parameter orbitable.
  parameter trueAnomaly.
  
  set ecc to orbitable:obt:eccentricity.
  set trueAnomaly to ClampAngle(trueAnomaly, 360) * constant():PI / 180.
  
  if(ecc < 1) {
    // elliptic
    set cosE to (ecc + cos(trueAnomaly)) / (1 + ecc * cos(trueAnomaly)).
    set sinE to sqrt(1 - (cosE * cosE)).
    if(trueAnomaly > constant():PI) {
      set sinE to sinE * -1.
    }
    return ClampAngle(arctan2(sinE, cosE), 2 * constant():PI).
  }
  else {
    // hyperbolic
    print "Orbit is hyperbolic, can't deal with that for now!".
    return -1.
  }
}

function GetMeanAnomalyAtEccentricAnomaly {
  parameter orbitable.
  parameter eccAnomaly.
  set ecc to orbitable:obt:eccentricity.
  if(ecc < 1) {
    return ClampAngle(eccAnomaly - (ecc * sin(eccAnomaly)), 2 * constant():PI).
  }
  else {
    // hyperbolic
    print "Orbit is hyperbolic, can't deal with that for now!".
    return -1.
  }
}

function MeanMotion {
  parameter orbitable.
  if(orbitable:obt:eccentricity > 1) {
    set sma to orbitable:obt:semimajoraxis.
    return sqrt(orbitable:body:mu / abs(sma * sma * sma)).
  }
  else {
    return 2 * constant():PI / orbitable:obt:period.
  }
}

function MeanAnomalyAtUT {
  parameter orbitable.
  parameter UT.
  set ret to ((UT - time:seconds) * MeanMotion(orbitable)) + orbitable:obt:meananomalyatepoch.
  if(orbitable:obt:eccentricity < 1) {
    set ret to ClampAngle(ret, 2 * constant():PI).
  }
  return ret.
}

function UTAtMeanAnomaly {
  parameter orbitable.
  parameter meanAnomaly.
  
  set currentMeanAnomaly to orbitable:obt:meananomalyatepoch.
  set meanDifference to meanAnomaly - currentMeanAnomaly.
  if(orbitable:obt:eccentricity < 1) {
    meanDifference = ClampAngle(meanDifference, constant():PI * 2).
  }
  return UT + meanDifference / MeanMotion().
}

function TimeOfTrueAnomaly {
  parameter orbitable.
  parameter trueAnomaly.
  return UTAtMeanAnomaly(orbitable, GetMeanAnomalyAtEccentricAnomaly(orbitable, GetEccentricAnomalyAtTrueAnomaly(orbitable, trueAnomaly))).
}

function TimeToAscendingNode {
  parameter orbitable.
  set ttan to TimeOfTrueAnomaly(orbitable, 360 - orbitable:obt:argumentofperiapsis) - time:seconds.
  if ttan < 0 {
    set ttan to ttan + orbitable:obt:period.
  }
  return ttan.
}

function TimeToDescendingNode {
  parameter orbitable.
  set ttdn to TimeOfTrueAnomaly(orbitable, 180 - orbitable:obt:argumentofperiapsis) - time:seconds.
  if ttdn < 0 {
    set ttdn to ttdn + orbitable:obt:period.
  }
  return ttdn.
}