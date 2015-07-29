parameter location.

function circularize {
  parameter location.

  set r_a to ship:apoapsis + ship:body:radius.
  set r_p to ship:periapsis + ship:body:radius.

  set ecc to 1 - (2 / ((r_a / r_p) + 1)).
  set sma to (r_p + r_a) / 2.

  set v_a to sqrt(((1 - ecc) * body:mu) / ((1 + ecc) * sma)).
  set v_p to sqrt(((1 + ecc) * body:mu) / ((1 - ecc) * sma)).

  if(location = "apoapsis") {
    set circDV to sqrt(body:mu / r_a) - v_a.
    set circNode to node(time:seconds + eta:apoapsis, 0, 0, circDV).
    add circNode.
  }
  else if(location = "periapsis") {
    set circDV to sqrt(body:mu / r_p) - v_p.
    set circNode to node(time:seconds + eta:periapsis, 0, 0, circDV).
    add circNode.
  }
  else {
    print "Invalid argument!".
    print "Use 'apoapsis' or 'periapsis'!".
    return.
  }


}

circularize(location).