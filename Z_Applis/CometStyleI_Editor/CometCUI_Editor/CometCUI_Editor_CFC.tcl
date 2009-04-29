inherit CometCUI_Editor_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor_CFC constructor {} {
 set this(edited_comet) {}
 set this(style_file)   {}
 set this(gdd_op_file)  [Comet_files_root]Common_GDD_requests.css++
 set this(ptf_of_CUI)   Ptf_TK
 set this(L_mapping)    [list]
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometCUI_Editor_CFC [list gdd_op_file ptf_of_CUI edited_comet style_file]

#___________________________________________________________________________________________________________________________________________
Generate_List_accessor CometCUI_Editor_CFC L_mapping L_mapping

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor_CFC Apply_style {} {}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometCUI_Editor {} {return [list {get_gdd_op_file { }} {get_L_mapping { }} {get_ptf_of_CUI { }} {get_edited_comet { }} {get_style_file { }} ]}
proc P_L_methodes_set_CometCUI_Editor {} {return [list {set_gdd_op_file {v}} {Sub_L_mapping {L}} {Add_L_mapping {L}} {set_L_mapping {L}} {set_ptf_of_CUI {v}} {set_edited_comet {v}} {set_style_file {v}} {Apply_style {}} ]}

