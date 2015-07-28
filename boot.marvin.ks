// general boot script
// by Kenton Hamaluik
// 2015-07-27
// portions borrowed from https://github.com/gisikw/ksprogramming

// chill out while we look for something to run
set ship:control:pilotmainthrottle to 0.

// two utility functions that we need to load the rest of our utilities
// detect files
function FileExists {
  parameter name.
  parameter vol.

  switch to vol.
  list files in allFiles.
  for file in allFiles {
    if file:name = name {
      switch to 1.
      return true.
    }
  }
  switch to 1.
  return false.
}

// download files from the archive
function Download {
  parameter name.

  // delete any local copies
  if FileExists(name, 1) {
    delete name.
  }

  // download from the archive
  if FileExists(name, 0) {
    copy name from 0.
  }
}

// load our utility functions
Download('utility.ks').
run utility.

// start the boot sequence here
// download the modules in the background
set terminal:width to 50.
set terminal:height to 17.
SplashScreen().
Download("orbit.ks").
Download("ascent.ks").
Download("maneuver.ks").
wait 3.

// tell the user whats going on
ShowHeader().
print "| > Downloaded: 'orbit.ks'                       |".
print "| > Downloaded: 'ascent.ks'                      |".
print "| > Downloaded: 'maneuver.ks'                    |".
print "+------------------------------------------------+".

// depending on the situation, do different things
if(ship:status = "PRELAUNCH" or ship:status = "LANDED") {
  print "| Launch to orbit with:                          |".
  print "|   $ run orbit(altitude, heading, stage limit). |".
}
else if(ship:status = "SPLASHED") {
  print "| Splashed down, nothing to do but recover!      |".
}
else if(ship:status = "FLYING") {
  print "| In flight! Engage manual control.              |".
}
else if(ship:status = "SUB_ORBITAL") {
  print "| Suborbital trajectory. Engage manual control.  |".
}
else if(ship:status = "ORBITING") {
  print "| TODO...                                        |".
}
else if(ship:status = "ESCAPING") {
  print "| TODO...                                        |".
}
else if(ship:status = "DOCKED") {
  print "| TODO...                                        |".
}
print "+------------------------------------------------+".