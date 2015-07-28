clearscreen.
set exit to 0.
set index to 0.
set selection to 0.
set printflag to 1.
if ag9 = "True" { toggle ag9. }.
if ag8 = "True" { toggle ag8. }.
if ag7 = "True" { toggle ag7. }.
 
set splash to 1.
if splash = 1 { run SC1. }.
 
until exit = 1
 {
 if ag9 = "True" { set index to index - 1. set printflag to 1. toggle ag9. }.
 if ag8 = "True" { set index to index + 1. set printflag to 1. toggle ag8. }.
 if index < 0 { set index to 4. }.
 if index > 4 { set index to 0. }.
 if ag7 = "True"
  {
  toggle ag7.
  if index = 0 { if status = "PRELAUNCH" { run a1. }. set printflag to 1. }.
  if index = 1 { if status = "ORBITING" { run Transfer. }. set printflag to 1. }.
  if index = 2 { set printflag to 1. }.
  if index = 3 { if status = "ORBITING" OR status = "FLYING" { run lp. }. set printflag to 1. }.
  if index = 4 { set exit to 1. }.
  }.
 if printflag = 1
  {
  clearscreen.
  print "Welcome to Space Computer v1.0" at (10,0).
  print "--------------------------------------------------" at (0,1).
  print "Select a program from the list." at (10,2).
  print "Use action group 9 to select up." at (9,4).
  print "Use action group 8 to select down." at (8,6).
  print "Use action group 7 to confirm your selection." at (3,8).
  print "--------------------------------------------------" at (0,9).
  print "Launch to Orbit" at (18,12).
  print "Alter Orbit" at (20,14).
  print "Execute  Node" at (19,16).
  print "Land From Orbit" at (18,18).
  print "EXIT" at (23,20).
  if index = 0 { print "======>" at (7,12). print "<======" at (36,12). }.
  if index = 1 { print "======>" at (7,14). print "<======" at (36,14). }.
  if index = 2 { print "======>" at (7,16). print "<======" at (36,16). }.
  if index = 3 { print "======>" at (7,18). print "<======" at (36,18). }.
  if index = 4 { print "======>" at (7,20). print "<======" at (36,20). }.
  set printflag to 0.
  }.
 }.
 clearscreen.
 print "Have A Nice Day!".