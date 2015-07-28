// begin with an ascent
if(File_Exists("startup.ks", 1)) {
  delete startup.ks.
}
if(ship:status = "PRELAUNCH") {
  download("dev.ascent.ks").
  run dev.ascent.ks.
}
if(File_Exists("update.ks", 1)) {
  delete update.ks.
}