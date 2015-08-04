parameter location.

print ("c0.").
set r_a to ship:apoapsis + ship:body:radius.
set r_p to ship:periapsis + ship:body:radius.

set ecc to 1 - (2 / ((r_a / r_p) + 1)).
set sma to (r_p + r_a) / 2.

set v_a to sqrt(((1 - ecc) * body:mu) / ((1 + ecc) * sma)).
set v_p to sqrt(((1 + ecc) * body:mu) / ((1 - ecc) * sma)).

print "c1.".
if(location = "apoapsis") {
  print "c2.".
  set circDV to sqrt(body:mu / r_a) - v_a.
  print "c3.".
  add node(time:seconds + eta:apoapsis, 0, 0, circDV).
  print "c4.".
}
else if(location = "periapsis") {
  print "c5.".
  set circDV to sqrt(body:mu / r_p) - v_p.
  print "c6.".
  add node(time:seconds + eta:periapsis, 0, 0, circDV).
  print "c7.".
}
else {
  print "c8.".
  print "Invalid argument!".
  print "c9.".
  print "Use 'apoapsis' or 'periapsis'!".
  print "c10.".
}
print "c11.".

