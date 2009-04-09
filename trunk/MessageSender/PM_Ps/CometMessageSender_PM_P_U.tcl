inherit CometMessageSender_PM_P_U PM_U_Container

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometMessageSender_PM_P_U constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_CometMessageSender_PM_P_U
   # Nested COMET graph
   set this(cont_root) [CPool get_a_comet CometContainer -Add_style_class "root"]
	 set this(spec_destination) [CPool get_a_comet CometSpecifyer -Add_style_class "PARAM IN DESTINATION TO CORE"]
	 set this(txt_destination)  [CPool get_a_comet CometText      -Add_style_class "PARAM IN DESTINATION TO DECORATION GUIDANCE" -set_text "Send to : "]
	 set this(spec_subject)     [CPool get_a_comet CometSpecifyer -Add_style_class "PARAM IN SUBJECT CORE"]
	 set this(txt_subject)      [CPool get_a_comet CometText      -Add_style_class "PARAM IN SUBJECT DECORATION GUIDANCE" -set_text "Subject : "]
	 set this(spec_message)     [CPool get_a_comet CometSpecifyer -Add_style_class "PARAM IN MESSAGE CORE"]
	 set this(txt_message)      [CPool get_a_comet CometText      -Add_style_class "PARAM IN MESSAGE DECORATION GUIDANCE" -set_text "Message : "]
	 set this(act_send)         [CPool get_a_comet CometActivator -Add_style_class "PARAM CONFIRM CONFIRMATION COMPUTE COMPUTE_TRAVEL" -set_text "SEND"]
	 set this(cont_dght)        [CPool get_a_comet CometContainer -Add_style_class "HANDLE_DAUGHTERS"]
	 $this(cont_root) Add_daughters_R [list $this(txt_destination) $this(spec_destination) $this(txt_subject) $this(spec_subject) $this(txt_message) $this(spec_message) $this(act_send) $this(cont_dght)]
   
   # Specify where are the handles 
   this set_L_nested_handle_LM    $this(cont_root)_LM_LP
   this set_L_nested_daughters_LM $this(cont_dght)_LM_LP

   # Subscribe to events...
   $this(act_send) Subscribe_to_activate $objName "$objName Do_send_message" UNIQUE
   
   $this(spec_destination) Subscribe_to_set_text $objName "$objName prim_set_destination \$t"
   $this(spec_subject)     Subscribe_to_set_text $objName "$objName prim_set_subject     \$t"
   $this(spec_message)     Subscribe_to_set_text $objName "$objName prim_set_message     \$t"
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometMessageSender_PM_P_U dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometMessageSender_PM_P_U [P_L_methodes_set_CometMessageSender] {} {}
Methodes_get_LC CometMessageSender_PM_P_U [P_L_methodes_get_CometMessageSender] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometMessageSender_PM_P_U [P_L_methodes_set_CometMessageSender_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometMessageSender_PM_P_U Do_send_message {} {
 #this prim_set_destination [$this(spec_destination) get_text]
 #this prim_set_subject     [$this(spec_subject)     get_text]
 #this prim_set_message     [$this(spec_message)     get_text]
 this prim_send_message
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometMessageSender_PM_P_U set_destination {v} {
 if {[$this(spec_destination) get_text] != $v} {$this(spec_destination) set_text $v}
}

#___________________________________________________________________________________________________________________________________________
method CometMessageSender_PM_P_U set_subject {v} {
 if {[$this(spec_subject) get_text] != $v} {$this(spec_subject) set_text $v}
}

#___________________________________________________________________________________________________________________________________________
method CometMessageSender_PM_P_U set_message {v} {
 if {[$this(spec_message) get_text] != $v} {$this(spec_message) set_text $v}
}
