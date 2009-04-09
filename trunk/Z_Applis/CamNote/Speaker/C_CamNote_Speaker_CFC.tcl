#__________________________________________________
inherit CommonFC_CometCamNote_Speaker CommonFC

method CommonFC_CometCamNote_Speaker constructor {} {
 this inherited
 set this(slide_viewer) {}
 set this(mode)         {}
 
 set this(preso_mode) 0
}

#______________________________________________________
#______________________________________________________
Generate_accessors CommonFC_CometCamNote_Speaker [list slide_viewer mode preso_mode]

#__________________________________________________
#__________________________ Adding the activator functions 
proc L_methodes_get_CamNote_Speaker {} {return [list {get_slide_viewer { }} {get_preso_mode { }} {get_mode { }} ]}
proc L_methodes_set_CamNote_Speaker {} {return [list {set_slide_viewer {n}} {set_preso_mode {m}} {set_mode {m}} ]}
