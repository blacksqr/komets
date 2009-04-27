inherit CometStyleI_Editor_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC constructor {} {
 set this(edited_comet) {}
 set this(style_files) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometStyleI_Editor_CFC [list edited_comet style_files]

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC Apply_styles {} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometStyleI_Editor {} {return [list {get_edited_comet { }} {get_style_files { }} {Apply_styles {}} ]}
proc P_L_methodes_set_CometStyleI_Editor {} {return [list {set_edited_comet {v}} {set_style_files {v}} ]}

