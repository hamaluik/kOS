// DEV boot script
// by Kenton Hamaluik
// 2015-07-27
// borrowed heavily from https://github.com/gisikw/ksprogramming

// chill out while we look for something to run
set ship:control:pilotmainthrottle to 0.

// detect files
function File_Exists {
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
function download {
  parameter name.

  // delete any local copies
  if File_Exists(name, 1) {
    delete name.
  }

  // download from the archive
  if File_Exists(name, 0) {
    copy name from 0.
  }
}

set updateScript to ship:name + ".update.ks".

// see if we have an update to load
if File_Exists(updateScript, 0) {
  print "Downloading update: '" + updateScript + "'...".
  download(updateScript).
  if File_Exists("update.ks", 1) {
    delete "update.ks".
  }
  rename updateScript to "update.ks".
  print "Complete!".
  print "Launching update...".
  run update.ks.
}

if File_Exists("startup.ks", 1) {
  print "Executing startup script...".
  run startup.ks.
} else {
  wait 10.
  reboot.
}