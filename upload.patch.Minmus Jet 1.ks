// transfer DVs
// courtesy of https://en.wikipedia.org/wiki/Hohmann_transfer_orbit
set r1 to ship:body:radius + ship:altitude.
set r2 to minmus:apoapsis.
set dv1 to sqrt(ship:body:mu / r1) * (sqrt((2 * r2) / (r1 + r2)) - 1).
set dv2 to sqrt(ship:body:mu / r2) * (1 - sqrt((2 * r1) / (r1 + r2))).

print "DV1 = " + dv1.
print "DV2 = " + dv2.
print "Total = " + (dv1 + dv2).

set transitTime to constant():PI * sqrt((r1 + r2)^3 / (8 * ship:body:mu)).

print "minmus transit time = " + round(transitTime, 1) + "s!".

set minmusPeriod to minmus:obt:period.
set minmusAngleSpeed to 360 / minmusPeriod.
set degChangeDuringTransit to minmusAngleSpeed * transitTime.
print "Will go " + round(degChangeDuringTransit, 1) + " deg around Kerbin during the transfer.".

set departurePhaseAngle to (minmus:obt:trueanomaly - ship:obt:trueanomaly) - degChangeDuringTransit.
print "Transit phase angle = " + round(departurePhaseAngle, 1).
set currentPhaseAngle to (360 - minmus:obt:trueanomaly) - ship:obt:trueanomaly.
print "Current phase angle = " + round(currentPhaseAngle, 1).

set shipAngleSpeed to 360 / ship:obt:period.
set transferRelativeAngleSpeed to shipAngleSpeed - minmusAngleSpeed.
print "Speed of phase angle = " + round(transferRelativeAngleSpeed, 1).

set deltaPhaseAngle to departurePhaseAngle - currentPhaseAngle.
set timeTillPhaseAngle to abs(deltaPhaseAngle / transferRelativeAngleSpeed).
print round(timeTillPhaseAngle, 1) + " s until phase angle is aligned!".

//set targetNode to node(time:seconds + timeTillPhaseAngle, 0, 0, dv1).
//add targetNode.