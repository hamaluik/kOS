@lazyglobal off.

function get_normal_vector {
    declare parameter inc.
    declare parameter lan.

    local minmus_r to minmus:position - kerbin:position.
    local minmus_v to minmus:velocity:orbit.

    local minmus_normal to vcrs(minmus_r, minmus_v).

    local delta_lan to lan - minmus:obt:lan.

    local target_normal to angleaxis(delta_lan, v(0,-1,0)) * minmus_normal.
    local target_dn to vcrs(target_normal,v(0,1,0)).

    local delta_inc to inc - minmus:obt:inclination.

    set target_normal to angleaxis(delta_inc,target_dn) * target_normal.

    return target_normal.
}.

function vector_at_longitude {
    declare parameter lan.

    local minmus_r to minmus:position - kerbin:position.
    local minmus_v to minmus:velocity:orbit.

    local minmus_normal to vcrs(minmus_r, minmus_v).

    local delta_lan to lan - minmus:obt:lan.

    local target_normal to angleaxis(delta_lan, v(0,-1,0)) * minmus_normal.

    return vcrs(v(0,1,0),target_normal).
}.

function relative_ascending_node {
    declare parameter reference_normal.
    declare parameter my_normal.

    return vcrs(my_normal, reference_normal).
}.

function warp_to_window_for_lan {
    declare parameter target_lan.

    local ascending_node to v(0,0,0).
    lock ascending_node to vector_at_longitude(target_lan).
    local descending_node to v(0,0,0).
    lock descending_node to vector_at_longitude(target_lan + 180).

    local target_node to v(0,0,0).
    local next_node_is to "".

    if vdot(ascending_node, ship:velocity:orbit) > 0 {
        lock target_node to ascending_node.
        set next_node_is to "ascending".
    } else {
        lock target_node to descending_node.
        set next_node_is to "descending".
    }.
    
    lock angle_to_node to vang(ship:position-kerbin:position,target_node).

    print "Launch window in " + angle_to_node + " minutes.".

    if angle_to_node > 10 {
        set warp to 4.
        wait until angle_to_node < 10.
    }.
    if angle_to_node > 2.5 {
        set warp to 3.
        wait until angle_to_node < 2.5.
    }.
    if angle_to_node > 1 {
        set warp to 1.
        wait until angle_to_node < 1.
    }.
    set warp to 0.
    return next_node_is.
}
