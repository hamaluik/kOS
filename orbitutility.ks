set DegToRad to constant():PI / 180.
set RadToDeg to 180 / constant():PI.

function cosr {
  parameter x.
  return cos(RadToDeg * x).
}

function sinr {
  parameter x.
  return sin(RadToDeg * x).
}

function acosr {
  parameter x.
  return DegToRad * arccos(x).
}

function GetOrbitNormal {
  parameter orbitable.
  return vcrs(orbitable:up:forevector, orbitable:prograde:forevector):normalized.
}

function EccAnomR {
  parameter ecc, trueAnom.
  return acosr((ecc + cosr(trueAnom)) / (1 + ecc * cosr(trueAnom))).
}

function MeanAnomR {
  parameter ecc, eccAnom.
  return eccAnom - ecc * sinr(eccAnom).
}

function MeanMotionR {
  parameter orbit.
  return sqrt(orbit:body:mu / (orbit:semimajoraxis * orbit:semimajoraxis * orbit:semimajoraxis))
}

function TimeOfTrueAnomaly {
  parameter orbit.
  parameter trueAnomaly.
  return (MeanAnomR(orbit:eccentricity, EccAnomR(orbit:eccentricity, DegToRad * trueAnomaly)) - (DegToRad * orbit:meananomalyatepoch)) / MeanMotionR(orbit).
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