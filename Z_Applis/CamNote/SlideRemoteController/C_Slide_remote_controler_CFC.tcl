#__________________________________________________
inherit CommonFC_CometSlideRemoteController ChoiceN_CFC

method CommonFC_CometSlideRemoteController constructor {} {
 this inherited
 this set_step  1
 this set_b_inf 1
 
 set this(L_slides) ""
}

#______________________________________________________
method CommonFC_CometSlideRemoteController get_current { } {return [this get_val]}
method CommonFC_CometSlideRemoteController set_current {v} {puts "__$objName set_current $v"; return [this set_val $v]}
method CommonFC_CometSlideRemoteController go_to_nxt {} {puts "__$objName go_to_nxt"; set v [expr [this get_val]+[this get_step]]; if {$v <= [this get_b_sup]} {return [this set_val $v]} else {return [this get_val]}}
method CommonFC_CometSlideRemoteController go_to_prv {} {set v [expr [this get_val]-[this get_step]]; if {$v >= [this get_b_inf]} {return [this set_val $v]} else {return [this get_val]}}
method CommonFC_CometSlideRemoteController go_to_bgn {} {set v [this get_b_inf]; return [this set_val $v]}
method CommonFC_CometSlideRemoteController go_to_end {} {set v [this get_b_sup]; return [this set_val $v]}

Generate_accessors CommonFC_CometSlideRemoteController [list L_slides]

#__________________________________________________
#__________________________ Adding the activator functions 
proc L_methodes_get_SlideRemoteController {} {return [list {get_L_slides { }} {get_current { }} ]}
proc L_methodes_set_SlideRemoteController {} {return [list {set_L_slides {L}} {go_to_bgn {}} {go_to_end {}} {go_to_prv {}} {go_to_nxt {}} {set_current {n}}]}
