// general boot script
// by Kenton Hamaluik
// 2015-07-27
// portions borrowed from https://github.com/gisikw/ksprogramming

// chill out while we look for something to run
set ship:control:pilotmainthrottle to 0.

// utilities
copy "fileutility.ks" from 0.
run fileutility.

// download any new patches
set patchScript TO "upload.patch." + ship:name + ".ks".

if FileExists(patchScript, 0) {
  Download(patchScript).
  switch to 0.
  delete patchScript.
  switch to 1.
  if(FileExists("patch.ks", 1)) {
    delete "patch.ks".
  }
  rename patchScript to "patch.ks".
  print "Patch script found! Executing!".
  run patch.
  delete patch.
}