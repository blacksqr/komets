inherit CometEdition_comet_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_CFC constructor {} {
 set this(edited_root) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometEdition_comet_CFC [list edited_root]

#___________________________________________________________________________________________________________________________________________

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometEdition_comet {} {return [list {get_edited_root { }} ]}
proc P_L_methodes_set_CometEdition_comet {} {return [list {set_edited_root {v}} ]}

