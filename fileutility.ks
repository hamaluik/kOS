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

  set downloadTime to addons:rt:delay(ship) * 3.
  set timer to 0.

  print "Downloading '" + name + "', will take " + round(downloadTime, 1) + "s.".

  until timer >= downloadTime {
    set start to time:seconds.
    // if we lose connection, the download will be paused
    wait until (time:seconds - start) > (downloadTime - timer) or not addons:rt:hasconnection(ship).
    set timer to timer + time:seconds - start.
  }

  // delete any local copies
  if FileExists(name, 1) {
    delete name.
  }

  // download from the archive
  if FileExists(name, 0) {
    copy name from 0.
  }
}