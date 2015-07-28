@lazyglobal off.

function mix {
    declare parameter left.
    declare parameter right.
    declare parameter weight.

    return left + (right - left) * weight.
}

function east_for {
  parameter ves.

  return vcrs(ves:up:vector, ves:north:vector).
}

function compass_for {
  parameter ves.

  local pointing is ves:facing:forevector.
  local east is east_for(ves).

  local trig_x is vdot(ves:north:vector, pointing).
  local trig_y is vdot(east, pointing).

  local result is arctan2(trig_y, trig_x).

  if result < 0 { 
    return 360 + result.
  } else {
    return result.
  }
}

function flight_path_azimuth_for {
  parameter ves.

  local pointing is ves:velocity:orbit.
  local east is east_for(ves).

  local trig_x is vdot(ves:north:vector, pointing).
  local trig_y is vdot(east, pointing).

  local result is arctan2(trig_y, trig_x).

  if result < 0 { 
    return 360 + result.
  } else {
    return result.
  }
}

function clamp_abs {
    parameter x.
    parameter limit.
    return min(max(x, -limit), limit).
}.
