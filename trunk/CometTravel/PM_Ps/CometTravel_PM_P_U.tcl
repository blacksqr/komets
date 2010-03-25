inherit CometTravel_PM_P_U PM_U_Container

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_U constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id N_CometTravel_PM_P_U
   # Nested COMET graph
   set this(cont_root)   [CPool get_a_comet CometContainer -Add_style_class root]
     set this(spec_from) [CPool get_a_comet CometSpecifyer -Add_style_class "PARAM IN from"]
	 set this(spec_to)   [CPool get_a_comet CometSpecifyer -Add_style_class "PARAM IN to"]
	 set this(act_go)    [CPool get_a_comet CometActivator -Add_style_class "PARAM CONFIRM COMPUTE compute_travel"]
     set this(img_trav)  [CPool get_a_comet CometImage     -Add_style_class "RESULT travel IMAGE"]
	 set this(txt_trav)  [CPool get_a_comet CometText      -Add_style_class "RESULT travel TEXT"]
	 set this(cont_dght) [CPool get_a_comet CometContainer -Add_style_class root]
	 $this(cont_root) Add_daughters_R [list $this(spec_from) $this(spec_to) $this(act_go) $this(img_trav) $this(txt_trav) $this(cont_dght)]
   
   # Specify where are the handles 
   this set_L_nested_handle_LM    $this(cont_root)_LM_LP
   this set_L_nested_daughters_LM $this(cont_dght)_LM_LP

   # Subscribe to events...
   $this(act_go) Subscribe_to_activate $objName "$objName Do_Compute" UNIQUE
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_U dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometTravel_PM_P_U [P_L_methodes_set_CometTravel] {} {}
Methodes_get_LC CometTravel_PM_P_U [P_L_methodes_get_CometTravel] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometTravel_PM_P_U [P_L_methodes_set_CometTravel_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_U Do_Compute {} {
 this prim_set_loc_src [$this(spec_from) get_text]
 this prim_set_loc_dst [$this(spec_to)   get_text]
 this prim_Compute_travel
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_U set_loc_src {l} {
 $this(spec_from) set_text $l
}

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_U set_loc_dst {l} {
 $this(spec_to) set_text $l
}

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_U set_travel {t} {
 $this(img_trav) load_img [lindex $t 0]
 $this(txt_trav) set_text [lindex $t 1]
}

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_U Compute_travel {} {}
