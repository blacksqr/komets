#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometStyle_editor_PM_P_U_basic PM_U_Container
#___________________________________________________________________________________________________________________________________________
method CometStyle_editor_PM_P_U_basic constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_mothers   1
   this set_GDD_id FUI_CometStyle_editor_PM_P_U_basic
   
   this set_default_op_gdd_file    [Comet_files_root]Comets/CSS_STYLESHEETS/GDD/Common_GDD_requests.css++
   this set_default_css_style_file [Comet_files_root]Comets/CSS_STYLESHEETS/Style_editor/Style_editor_basic.css++

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometStyle_editor_PM_P_U_basic [P_L_methodes_set_CometStyleI_Editor] {}          {}
Methodes_get_LC CometStyle_editor_PM_P_U_basic [P_L_methodes_get_CometStyleI_Editor] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometStyle_editor_PM_P_U_basic [P_L_methodes_set_CometStyleI_Editor_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometStyle_editor_PM_P_U_basic set_LM {LM} {
 set rep [this inherited $LM]
 set this(cont)           "${objName}_cont"
 set this(cont_daughters) "${objName}_cont_daughters"
 if {![gmlObject info exists object $this(cont)]} {
   this set_L_nested_handle_LM    $this(cont)_LM_LP
   this set_L_nested_daughters_LM $this(cont_daughters)_LM_LP

   CometContainer $this(cont)           "Container of player's presentation $objName"         {} -Add_style_class "CONTAINER INTERNAL_ROOT ROOT root"
   CometContainer $this(cont_daughters) "Container of player's presentation $objName"         {} -Add_style_class "CONTAINER DAUGHTERS"
     set LC [this get_LC]
	 $this(cont) Add_daughters_R [list [$LC get_cont_root] $this(cont_daughters)]
	 set this(reconnect_LM) 1
  }
  
 return $rep
}

