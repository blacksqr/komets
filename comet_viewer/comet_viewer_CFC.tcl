#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
#_________________________________________________________________________________________________________
inherit CometViewer_CFC CommonFC
#---------------------------------------------------------------

method CometViewer_CFC constructor { } {
 set this(represented_element) ""
 set this(go_inside_level)     0
 set this(go_out_daughters)    1
 
 set this(dot_description) ""

 return $objName
}

#_________________________________________________________________________________________________________
method CometViewer_CFC Enlight {L_elements} {}

#_________________________________________________________________________________________________________
method CometViewer_CFC set_element_and_level {v} {
 set this(represented_element) [lindex $v 0]
 set this(go_inside_level)     [lindex $v 1]
 puts "$objName set_element_and_level $v\n  - this(represented_element) : $this(represented_element)\n  - this(go_inside_level) : $this(go_inside_level)"
}

#_________________________________________________________________________________________________________
Generate_accessors CometViewer_CFC [list dot_description represented_element go_inside_level go_out_daughters]

#_________________________________________________________________________________________________________
proc L_methodes_set_CometViewer {} {return [list {Enlight {L}} {set_dot_description {v}} {set_element_and_level {v}} {set_represented_element {v}} {set_go_out_daughters {v}} {set_go_inside_level {v}} ]}
proc L_methodes_get_CometViewer {} {return [list {get_dot_description { }} {get_represented_element { }} {get_go_out_daughters { }} {get_go_inside_level { }} ]}
