// display the splash screen
function SplashScreen {
  clearscreen.
  print "+------------------------------------------------+".
  print "|                                       ___      |".
  print "|                                 |     | |      |".
  print "|                                /_\    | |      |".
  print "|                               |   |===|-|      |".
  print "|   Marvin Flight Computer      |  o|   | |      |".
  print "|           v1.0.0              |___|   |K|      |".
  print "|                              /_____\  |S|      |".
  print "|         Written by:         | M     | |P|      |".
  print "|       Kenton Hamaluik       | A     | | |      |".
  print "|         2015-07-28          | R     |=| |      |".
  print "|                             | V     | | |      |".
  print "|                             |_______| |_|      |".
  print "|                               (---)   | |      |".
  print "|                               /---\   | |      |".
  print "|                            ___________|_|_     |".
  print "+------------------------------------------------+".
}

function ShowHeader {
  clearscreen.
  print "+------------------------------------------------+".
  print "| Marvin Flight Computer                  v1.0.0 |".
  print "+------------------------------------------------+".
}

set lastThrust to -1.
function AutoStage {
  parameter delta.

  if(lastThrust < 0) {
    set lastThrust to ship:maxthrust.
  }

  if(ship:maxthrust < lastThrust - delta) {
    print "Thrust profile changed, staging!".
    lock throttle to 0.
    wait 0.5.
    stage.
    wait 0.5.
    lock throttle to 1.
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
  set mth to ship:maxthrust.
  set r to ship:altitude + ship:body:radius.
  return ship:body:mu / r / r.
}