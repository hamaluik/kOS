// Reddit /r/kOS Accurate Orbit Competition
// EASY TIER ENTRY

// Reddit: /u/ScootyPuff-Sr
// KSPForum: Justy
// Written June 27 - July 4, 2015

// Ideas liberally looted from:
//     * The tutorial page.
//     * /u/Ezekiel24r's gravity turn.

// Variables
SET countdown TO 5.
SET aptarget TO 100000.
SET att TO 90.
SET padavoid TO 85.
SET gravityturn TO FALSE.

// Countdown sequence.
PRINT "Counting down.".
UNTIL countdown = 0 {
    IF countdown = 3 {
        LOCK THROTTLE TO 0.1.
        STAGE.
        PRINT "Main engine start.".
    }
    ELSE IF countdown = 2 {
        LOCK THROTTLE TO 1.0.
        SAS ON.
        PRINT "Throttle up. Internal guidance.".
    }
    ELSE {
        PRINT "..." + countdown.
    }
    SET countdown TO countdown - 1.
    WAIT 1.
}

// Launch!
STAGE.
PRINT "Liftoff!".

// Autostaging.
WHEN MAXTHRUST < 0.1 AND STAGE:READY THEN {
    PRINT "Stage separation.".
    STAGE.
    PRESERVE.
}

// Aluminum shower prevention maneuver.
WAIT UNTIL ALT:RADAR > 100.
LOCK STEERING TO HEADING(90,padavoid).
PRINT "Begin pitch program.".
SET gravityturn TO TRUE.

// Fairing jettison trigger.
WHEN SHIP:ALTITUDE >= 45000 THEN {
    FOR fairing IN SHIP:PARTSTAGGED("PayloadFairing") {
        fairing:GETMODULE("ModuleProceduralFairing"):DOACTION("deploy",TRUE).
    }
    PRINT "Altitude " + SHIP:ALTITUDE + ", payload fairing separation.".
}

// Engine cutoff.
WHEN SHIP:APOAPSIS >= (aptarget - 6000) THEN {
    LOCK THROTTLE TO 0.05.
    PRINT "Approaching engine cutoff.".
}
WHEN SHIP:APOAPSIS >= (aptarget - 5000) THEN {
    LOCK THROTTLE TO 0.0.
    SET gravityturn to FALSE.
    PRINT "Engine cutoff. Coast to apokee.".
    IF SHIP:ALTITUDE < 70000 {
        LOCK STEERING TO SRFPROGRADE.
        PRINT "Coast drag reduction maneuver.".
    }
}

// 'Gravity' turn.
UNTIL gravityturn = FALSE {
    SET att TO 90 - (SQRT(0.16*SHIP:ALTITUDE)).
    IF (att < padavoid) AND (att >= 0) {
        LOCK STEERING TO HEADING(90, att).
    }
    WHEN att < 0 THEN {
        LOCK STEERING TO HEADING(90,0).
        SET gravityturn TO FALSE.
    }
    WAIT 0.2.
}

// Atmospheric exit.
WAIT UNTIL SHIP:ALTITUDE >= 70000.
LOCK STEERING TO HEADING(90,0).
PRINT "Aiming horizontal.".

// Establish low orbit.
// Velocity for a 100km circular orbit is 2245.8 m/s.
// 

WAIT 2.
SET WARP TO 2.
WAIT UNTIL ETA:APOAPSIS <= 30.
SET WARP TO 0.

WAIT UNTIL ETA:APOAPSIS <= 10.
LOCK THROTTLE TO 1.0.
PRINT "Beginning circularization burn.".
WAIT UNTIL SHIP:APOAPSIS >= aptarget - 3000.
LOCK THROTTLE TO 0.0.
PRINT "Orbit established.".

// Flatten inclination.
IF SHIP:GEOPOSITION:LAT > 0 {
    PRINT "Ship is over the northern hemisphere.".
    SET incburn TO HEADING(0,0).
} ELSE {
    PRINT "Ship is over the southern hemisphere.".
    SET incburn TO HEADING(180,0).
}
LOCK STEERING TO incburn.
PRINT "Waiting for equatorial crossing.".
SET WARPMODE TO "PHYSICS".
SET WARP TO 3.
WAIT UNTIL ABS(SHIP:GEOPOSITION:LAT) < 0.0005.
SET WARP TO 0.
SET dvtgt TO (2 * (SHIP:SURFACESPEED+202) * SIN(SHIP:OBT:INCLINATION/2)).
SET burnlen TO dvtgt / ((ship:maxthrust/10) / ship:mass).
PRINT "Starting inclination burn, " + burnlen + " seconds.".
LOCK THROTTLE TO 0.1.
WAIT burnlen.
LOCK THROTTLE TO 0.0.
PRINT "Inclination adjustment complete. Rounding orbit.".
WAIT 1.

SET WARPMODE TO "RAILS".
SET WARP TO 3.
WAIT UNTIL ETA:APOAPSIS <= 60.
SET WARP TO 0.
LOCK STEERING TO HEADING(90,0).
WAIT UNTIL ETA:APOAPSIS <= 5.
LOCK THROTTLE TO 0.05.
WAIT UNTIL SHIP:APOAPSIS >= aptarget.
LOCK THROTTLE TO 0.0.
LOCK STEERING TO NORTH.
WAIT 5.

SET WARP TO 3.
WAIT UNTIL ETA:APOAPSIS <= 60.
SET WARP TO 0.
LOCK STEERING TO HEADING(90,0).

WAIT UNTIL ETA:APOAPSIS <= 20.
SET dvtgt TO 2245.8 - (SHIP:SURFACESPEED+202).
SET burnlen TO dvtgt / ((ship:maxthrust/20) / ship:mass).
WAIT UNTIL ETA:APOAPSIS <= burnlen/2.
LOCK THROTTLE TO 0.05.
WAIT UNTIL SHIP:PERIAPSIS >= APTARGET - 30.
LOCK THROTTLE TO 0.0.

PRINT "Orbit circularized!.".
PRINT "Deploying antennae.".
FOR antenna IN SHIP:PARTSDUBBED("longAntenna") {
    antenna:GETMODULE("ModuleAnimateGeneric"):DOACTION("toggle antenna", true).
}

LOCK STEERING TO NORTH.
WAIT 5.
PRINT "Guidance terminated.".
UNLOCK STEERING.
SAS OFF.

SET targetECC TO 0.
SET targetSMA TO 700000.
SET targetInc TO 0.
SET actualECC TO SHIP:OBT:ECCENTRICITY.
SET actualSMA TO SHIP:OBT:SEMIMAJORAXIS.
SET actualINC TO SHIP:OBT:INCLINATION.
SET scoreECC TO ABS( ROUND(actualEcc, 3) - targetEcc) * 100.
SET scoreSMA TO ABS( ROUND(actualSMA) - targetSMA) * 0.1.
SET scoreInc TO ABS( ROUND(actualInc, 3) - targetInc) * 100.
SET totalscore TO (scoreECC + scoreSMA + scoreInc).
PRINT "Scorecard:".
PRINT "Eccentricity " + scoreECC + " points, " + actualECC.
PRINT "SMA          " + scoreSMA + " points, " + actualSMA.
PRINT "Inclination  " + scoreInc + " points, " + actualInc.
PRINT "--------------------------------------------------".
PRINT "TOTAL        " + totalscore.