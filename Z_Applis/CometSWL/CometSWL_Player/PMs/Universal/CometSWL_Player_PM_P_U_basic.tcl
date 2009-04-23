#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometSWL_Player_PM_P_U_basic PM_U_Container
#___________________________________________________________________________________________________________________________________________
method CometSWL_Player_PM_P_U_basic constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_mothers   1
   this set_cmd_placement {}
   
   set this(svg_place_visu)  ""

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSWL_Player_PM_P_U_basic [P_L_methodes_set_CometSWL_Player] {} {}
Methodes_get_LC CometSWL_Player_PM_P_U_basic [P_L_methodes_get_CometSWL_Player] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometSWL_Player_PM_P_U_basic [P_L_methodes_set_CometSWL_Player_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometSWL_Player_PM_P_U_basic set_player_name  {v} {$this(txt_name)   set_text $v}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Player_PM_P_U_basic set_player_color {v} {$this(spec_color) set_text $v}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometSWL_Player_PM_P_U_basic [list set_player_name set_player_color] end

#___________________________________________________________________________________________________________________________________________
method CometSWL_Player_PM_P_U_basic set_LM {LM} {
 set rep [this inherited $LM]
 set this(cont)           "${objName}_cont"
 set this(txt_name)       "${objName}_txt_name"
 set this(spec_color)     "${objName}_spec_color"
 set this(cont_daughters) "${objName}_cont_daughters"
 if {![gmlObject info exists object $this(cont)]} {
   this set_L_nested_handle_LM    $this(cont)_LM_LP
   this set_L_nested_daughters_LM $this(cont_daughters)_LM_LP

   CometContainer $this(cont)           "Container"         {} -Add_style_class "CONTAINER INTERNAL_ROOT ROOT root"
   CometContainer $this(cont_daughters) "Container for daughters"         {} -Add_style_class "CONTAINER DAUGHTERS"
   CometSpecifyer $this(txt_name)       "Name  specificator" {} -Add_style_class "PARAM INPUT OUTPUT SPECIFYER NAME"
   CometSpecifyer $this(spec_color)     "Color specificator" {} -Add_style_class "PARAM INPUT OUTPUT SPECIFYER COLOR"
     $this(cont) Add_daughters_R [list $this(txt_name) $this(spec_color) $this(cont_daughters)]
	 $this(spec_color) Subscribe_to_set_text $objName "$objName Update_player_color"
	 $this(txt_name)   Subscribe_to_set_text $objName "$objName Update_player_name"
	 
	 set this(reconnect_LM) 1
  }
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Player_PM_P_U_basic Update_player_color {} {
 if {[$this(spec_color) get_text] != [this get_player_color]} {
   #puts "$objName want player [this get_LC] to get color [$this(spec_color) get_text]"
   this prim_set_player_color [$this(spec_color) get_text]
  }
}

#___________________________________________________________________________________________________________________________________________
method CometSWL_Player_PM_P_U_basic Update_player_name {} {
 if {[$this(txt_name) get_text] != [this get_player_name]} {
   this prim_set_player_name [$this(txt_name) get_text]
  }
}
