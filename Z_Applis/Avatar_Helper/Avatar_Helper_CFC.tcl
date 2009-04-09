#__________________________________________________
inherit Avatar_Helper_CFC CommonFC

#______________________________________________________
method Avatar_Helper_CFC constructor {} {
 this inherited
 set this(L_traces)       [list ]
 set this(Display_Avatar) 1

   this Subscribe_to_set_Display_Avatar $objName "$objName Add_trace_for Display_Avatar \$v" UNIQUE
}

#______________________________________________________
method Avatar_Helper_CFC Fade_avatar {t V} {}

#______________________________________________________
method Avatar_Helper_CFC Add_trace_for {args} {
 lappend this(L_traces) [clock clicks -milliseconds] $args
}

#______________________________________________________
Generate_accessors     Avatar_Helper_CFC [list Display_Avatar L_traces]
Generate_List_accessor Avatar_Helper_CFC L_topics L_topics
Generate_List_accessor Avatar_Helper_CFC L_notes  L_notes

set L_mtd_to_subscribe [list set_Display_Avatar]
Manage_CallbackList Avatar_Helper_CFC $L_mtd_to_subscribe end

#____________________________________________________________________________________
#__________________________ Adding the activator functions __________________________
#____________________________________________________________________________________
proc L_methodes_get_Avatar_Helper {} {return [list {get_L_traces { }} {get_Display_Avatar { }}  ]}
proc L_methodes_set_Avatar_Helper {} {return [list {Fade_avatar {t V}} {set_Display_Avatar {v}} ]}


