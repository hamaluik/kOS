run utility.

// find our target
set target to vessel("kOS Dev MKI-A 1").

set r1 to ship:body:radius + ship:altitude.
set r2 to target:body:radius + target:altitude.
set dv1 to sqrt(ship:body:mu / r1) * (sqrt((2 * r2) / (r1 + r2)) - 1).
set dv2 to sqrt(ship:body:mu / r2) * (1 - sqrt((2 * r1) / (r1 + r2))).
set transitTime to constant():PI * sqrt((r1 + r2)^3 / (8 * ship:body:mu)).

set shipLong to ship:obt:trueanomaly + ship:obt:argumentOfPeriapsis + ship:obt:lan.
set targetLong to target:obt:trueanomaly + target:obt:argumentOfPeriapsis + target:obt:lan.

set phaseAngle to ClampAngle(targetLong - shipLong, 360).

print "Ship long: " + shipLong.
print "Target long: " + targetLong.
print "Phase angle: " + phaseAngle.

set relInc to RelativeInclination(ship, target).
print "Relative inclination: " + relInc.

set shipAngularVel to 360 / ship:obt:period.
set targetAngularVel to 360 / ship:obt:period.
set relativeAngularVel to abs(targetAngularVel - shipAngularVel).

set desiredPhaseAngle to targetAngularVel * transitTime.

print "Trans-orbital transit time is " + round(transitTime, 1) + " s.".
print "Desired phase angle is therefore: " + desiredPhaseAngle.