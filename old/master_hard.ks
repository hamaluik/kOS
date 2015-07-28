// Master executable: Hard tier

@lazyglobal off.

local target_ecc to 0.51.
local target_sma to 6540000.
local target_inc to 124.
local target_lan to 87.
local target_agp to 14.

print "Orbital navigation parameters:".
print "SMA: " + target_sma.
print "Ecc: " + target_ecc.
print "Inc: " + target_inc.
print "LAN: " + target_lan.
print "AgP: " + target_agp.

print "Loading libraries.".
copy lib_lazcalc from 0.
run lib_lazcalc.
copy utilities from 0.
run utilities.
copy plane_tools from 0.
run plane_tools.

print "Loading sequences.".
copy ascent from 0.
copy circularize from 0.
copy spiral_out from 0.

local target_pe_alt to (1 - target_ecc) * target_sma
    - ship:body:radius.
local target_ap_alt to (1 + target_ecc) * target_sma
    - ship:body:radius.

local parking_alt to max(target_pe_alt * 0.75, 100000).

print "Target orbit is " + (target_ap_alt / 1000) + " x "
    + (target_pe_alt / 1000) + ".".
print "Parking orbit at " + (parking_alt / 1000).

print "Ascent sequence.".
run ascent(target_inc, target_lan, parking_alt, 30, 2, 0.35).

print "Circularizing at apoapsis".
run circularize(target_inc).

stage.

print "Raising orbit.".
run spiral_out(target_ap_alt, target_pe_alt, target_agp).

set warp to 1.

print "Estimated score:".

local est_score_ecc to abs(round(ship:obt:eccentricity, 3) - target_ecc) * 100.
print "Ecc " + ship:obt:eccentricity + "/" + target_ecc
    + " : " + est_score_ecc.

local est_score_sma to abs(round(ship:obt:semimajoraxis) - target_sma) * 0.1.
print "SMA " + ship:obt:semimajoraxis + "/" + target_sma
    + " : " + est_score_sma.

local est_score_inc to abs(round(ship:obt:inclination, 3) - target_inc) * 100.
print "Inc " + ship:obt:inclination + "/" + target_inc
    + " : " + est_score_inc.

local est_score_lan to abs(round(ship:obt:lan, 2) - target_lan) * 10.
print "LAN " + ship:obt:lan + "/" + target_lan
    + " : " + est_score_lan.

local est_score_agp to abs(round(ship:obt:argumentofperiapsis, 2)
                                    - target_agp) * 10.
print "AgP " + ship:obt:argumentofperiapsis + "/" + target_agp
    + " : " + est_score_agp.

print "Total score: " + (est_score_ecc + est_score_sma + est_score_inc +
                         est_score_lan + est_score_agp).
