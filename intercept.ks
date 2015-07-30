// transfer DVs
// courtesy of https://en.wikipedia.org/wiki/Hohmann_transfer_orbit
set r1 to ship:body:radius + ship:altitude.
set r2 to target:body:radius + targetAltitude.
set dv1 to sqrt(ship:body:mu / r1) * (sqrt((2 * r2) / (r1 + r2)) - 1).
set dv2 to sqrt(ship:body:mu / r2) * (1 - sqrt((2 * r1) / (r1 + r2))).
set transitTime to constant():PI * sqrt((r1 + r2)^3 / (8 * ship:body:mu)).