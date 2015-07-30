parameter desiredLongitudeOffset.

set targetAltitude to 2868741.33.
set KSCLaunchPad to latlng(-0.0972092543643722, -74.557706433623).
set desiredLongitude to KSCLaunchPad:lng + desiredLongitudeOffset.

print "Executing Hohmann transfer...".
run hohmann(desiredLongitude, targetAltitude).
run maneuver(100).