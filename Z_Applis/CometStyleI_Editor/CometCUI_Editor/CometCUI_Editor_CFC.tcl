inherit CometCUI_Editor_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor_CFC constructor {} {
 set this(edited_comet) {}
 set this(style_file) {}
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometCUI_Editor_CFC [list edited_comet style_file]

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor_CFC Apply_style {} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometCUI_Editor {} {return [list {get_edited_comet { }} {get_style_file { }} {Apply_style {}} ]}
proc P_L_methodes_set_CometCUI_Editor {} {return [list {set_edited_comet {v}} {set_style_file {v}} ]}

