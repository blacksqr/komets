inherit CometInstantMessenger_PM_P_U_basic PM_U_Container

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometInstantMessenger_PM_P_U_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_CometTravel_PM_P_U
   
   set this(is_updating_num_frame) 0
   
   # Nested COMET graph
   set this(cont_root)    [CPool get_a_comet CometContainer -Add_style_class [list CONTAINER ROOT]]
     set this(inter_file) [CPool get_a_comet CometInterleaving -set_name "File" -Add_style_class [list INTERLEAVING COMMANDS FILE]]
		set this(cont_for_add_contact) [CPool get_a_comet CometContainer -set_name "Add contact"  -Add_style_class [list CONTAINER OPERATION ADD CONTACT]]
		$this(inter_file) set_daughters_R [list $this(cont_for_add_contact)]
     set this(inter_infos) [CPool get_a_comet CometInterleaving -set_name "Conversations" -Add_style_class [list INTERLEAVING CONVERSATIONS]]
		set this(cont_contacts) [CPool get_a_comet CometContainer -set_name "Contacts" -Add_style_class [list CONTAINER CONTACTS]]
		set this(inter_conversations) [CPool get_a_comet CometInterleaving -set_name "Conversations" -Add_style_class [list INTERLEAVING CONVERSATIONS]]
		$this(inter_infos) set_daughters_R [list $this(cont_contacts) $this(inter_conversations)]
	 set this(cont_dght) [CPool get_a_comet CometContainer]
	 $this(cont_root) Add_daughters_R [list $this(inter_file) $this(inter_infos) $this(cont_dght)]
	 
   # Specify where are the handles 
   this set_L_nested_handle_LM    $this(cont_root)_LM_LP
   this set_L_nested_daughters_LM $this(cont_dght)_LM_LP

   # Subscribe to events...
   
   # Default style
   this set_default_css_style_file $::env(ROOT_COMETS)/Comets/CometInstantMessenger/PMs/CSSpp/basic_U_style.css++
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometInstantMessenger_PM_P_U_basic dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometInstantMessenger_PM_P_U_basic [P_L_methodes_set_CometInstantMessenger] {} {}
Methodes_get_LC CometInstantMessenger_PM_P_U_basic [P_L_methodes_get_CometInstantMessenger] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometInstantMessenger_PM_P_U_basic [P_L_methodes_set_CometInstantMessenger_COMET_RE_LP]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometInstantMessenger_PM_P_U_basic set_LM {LM} {
	# if {[this get_LM] != $LM && $LM != ""} {
		 # set C_Video [[$LM get_LC] attribute C_Video]
		 # $this(cont_video)    set_daughters_R $C_Video
		 # $this(cont_playlist) set_daughters_R [[$LM get_LC] attribute C_list_medias]
		 # set C [[$LM get_LC] attribute C_choice_media]
		 # $this(cont_for_file) set_daughters_R $C; $this(cont_for_file) Add_MetaData TRIGGERABLE_ITEM "> $C"
		 # $this(cont_for_upnp) set_daughters_R $C; $this(cont_for_upnp) Add_MetaData TRIGGERABLE_ITEM "> $C"
		# }
	return [this inherited $LM]
}


