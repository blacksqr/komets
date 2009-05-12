inherit CometStyleI_Editor_CFC CommonFC

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC constructor {} {
 set this(edited_comet) {}
 set this(L_versions)   {}
 
 set this(num_version)  0
}
#___________________________________________________________________________________________________________________________________________
Generate_accessors CometStyleI_Editor_CFC [list edited_comet]
Generate_List_accessor CometStyleI_Editor_CFC L_versions L_versions

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC get_a_unique_version_id {} {
 incr this(num_version)
 return $this(num_version)
}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC Exists_style_file_for_id {id} {
 return [info exists this(style_file_of,$id)]
}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC get_style_file_for_id {id} {
 if {[this Exists_style_file_for_id $id]} {set rep $this(style_file_of,$id)} else {set rep ""}
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC set_style_file_for_id {id file_name} {
 set this(style_file_of,$id) $file_name
}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC Release_unique_id_for_style_file {id} {
 if {[this Exists_style_file_for_id $id]} {unset this(style_file_of,$id)}
}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC Apply_styles {} {}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC get_ptf_for_id {id} {
 if {[info exists this(ptf,$id)]} {return $this(ptf,$id)} else {return ""}
}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC set_ptf_for_id {id ptf} {
 set this(ptf,$id) $ptf
}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC Add_a_new_version {id} {}

#___________________________________________________________________________________________________________________________________________
method CometStyleI_Editor_CFC Sub_version_id {id} {
 this Release_unique_id_for_style_file $id
}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_get_CometStyleI_Editor {} {return [list {get_edited_comet {}} {get_L_versions {}} {get_a_unique_version_id {}} {Release_unique_id_for_style_file {}} \
                                                          {get_ptf_for_id {id}} \
														  {get_style_file_for_id {id}} {Exists_style_file_for_id {id}} \
													]}
proc P_L_methodes_set_CometStyleI_Editor {} {return [list {set_edited_comet {v}} \
                                                          {set_ptf_for_id {id ptf}} \
														  {set_style_file_for_id {id file_name}} \
                                                          {set_L_versions {L}} {Add_L_versions {L}} {Sub_L_versions {L}} \
														  {Apply_styles { }} \
														  {Add_a_new_version {id}} {Sub_version_id {id}} \
                                                    ]}

