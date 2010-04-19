#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometEdition_comet_PM_P_U_basic PM_U_Container

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id FUI_CometCompo_evolution_PM_P_U_basic_user_eval

   this set_default_op_gdd_file    [Comet_files_root]Comets/CSS_STYLESHEETS/GDD/Common_GDD_requests.css++
   this set_default_css_style_file [Comet_files_root]Comets/CometEdition_comet/PMs/CSSpp/CometEdition_comet_PM_P_U_basic.csspp

   # COMET hierarchy to provide ways for user to evaluate individual candidates
   set this(C_root)                     [CPool get_a_comet CometContainer    -Add_style_class "ROOT" -set_name "Root of nested comets"]
   set this(C_hier_edited_comets)       [CPool get_a_comet CometHierarchy    -Add_style_class "TREE EDITED EDITION COMETS"     -set_name "Tree of edited comets"]
   set this(C_hier_existing_comets)     [CPool get_a_comet CometHierarchy    -Add_style_class "TREE TOOLKIT COMETS GDD"        -set_name "Toolkit of existing comets"]
   set this(C_container_canvas)         [CPool get_a_comet CometContainer    -Add_style_class "CONTAINER CANVAS EDITION"       -set_name "Canvas for WYSIWYG builder"]
   set this(C_inter_PM_views)           [CPool get_a_comet CometInterleaving -Add_style_class "INTERLEAVING EDITION COMETS PM" -set_name "Editions"]
   
   set this(C_daughter_handle) [CPool get_a_comet CometContainer -set_name "Handle for out daughters"]
   set this(C_act_validate)    [CPool get_a_comet CometActivator -set_text "Validate scores and continue" -set_name "Validate score and continue" \
                                                                 -Subscribe_to_activate $objName "$objName Validate_scores" \
															     -Add_style_class [list ACT VALIDATE] ]
   

   $this(C_inter_PM_views) Add_daughters_R $this(C_container_canvas)
   set this(C_inter)     [CPool get_a_comet CometInterleaving]
     $this(C_inter) set_daughters_R [list $this(C_hier_edited_comets) $this(C_inter_PM_views) $this(C_hier_existing_comets)]

   $this(C_root) set_daughters_R [list $this(C_inter) $this(C_daughter_handle)]
   
   this set_L_nested_handle_LM    $this(C_root)_LM_LP
   this set_L_nested_daughters_LM $this(C_daughter_handle)_LM_LP
   
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometEdition_comet_PM_P_U_basic [P_L_methodes_set_CometEdition_comet] {} {}
Methodes_get_LC CometEdition_comet_PM_P_U_basic [P_L_methodes_get_CometEdition_comet] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometEdition_comet_PM_P_U_basic [P_L_methodes_set_CometEdition_comet_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic set_LM {LM} {
 set rep [this inherited $LM]
 if {$LM != ""} {this init_gdd_hierarchy}
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic init_gdd_hierarchy {} {
 set L_interactors [list]

 set dsl [this get_DSL_GDD_QUERY]
 $dsl QUERY "?t : IS_root : NODE()<-REL()*<-\$t(type == GDD_C&T)"
 foreach T [lindex [lindex [$dsl get_Result] 0] 1] {
   $dsl QUERY "?n : $T : NODE()<-REL()*<-\$n(type == GDD_FUI && ptf ~= Ptf_HTML)"
   set L_FUI [lindex [lindex [$dsl get_Result] 0] 1]
   if {[llength $L_FUI]} {lappend L_interactors [list $T {} $L_FUI]}
  }
 
 $this(C_hier_existing_comets) set_L_h [list Toolkit "" $L_interactors]
 
 return $L_interactors
}

#___________________________________________________________________________________________________________________________________________
Inject_code CometEdition_comet_PM_P_U_basic set_edited_root {} {
 # Update the inner comet this(C_hier_edited_comets)
 $this(C_hier_edited_comets) set_L_h [this get_L_h_edited_comet $v]
 
 # Reset this(C_inter_PM_views)
 this Reset_PM_views
}

Trace CometEdition_comet_PM_P_U_basic set_edited_root

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic Reset_PM_views {} {

}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic get_L_h_edited_comet {root} {
 set L [list]
 foreach d [$root get_out_daughters] {
   lappend L [this get_L_h_edited_comet $d]
  }
  
 return [list $root [list name [$root get_name]] $L]
}
