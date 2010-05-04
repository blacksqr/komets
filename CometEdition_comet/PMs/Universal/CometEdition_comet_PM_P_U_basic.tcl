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
   set this(C_hier_PMs)                 [CPool get_a_comet CometHierarchy    -Add_style_class "TREE ACTUAL PMs"                -set_name "Canvas for WYSIWYG builder"]
   set this(C_inter_PM_views)           [CPool get_a_comet CometInterleaving -Add_style_class "INTERLEAVING EDITION COMETS PM" -set_name "Editions"]
   
   set this(C_daughter_handle) [CPool get_a_comet CometContainer -set_name "Handle for out daughters"]
   set this(C_act_add_WS)      [CPool get_a_comet CometActivator -set_text "Add a workspace" -set_name "Add a workspace" \
                                                                 -Subscribe_to_activate $objName "$objName Add_a_new_workspace" \
																 -Add_style_class [list ACT ADD WS] ]
   set this(C_act_validate)    [CPool get_a_comet CometActivator -set_text "Validate scores and continue" -set_name "Validate score and continue" \
                                                                 -Subscribe_to_activate $objName "$objName Validate_scores" \
															     -Add_style_class [list ACT VALIDATE] ]
   

   $this(C_inter_PM_views) Add_daughters_R [list $this(C_container_canvas) $this(C_hier_PMs)]
   set this(C_inter)     [CPool get_a_comet CometInterleaving -Add_style_class "INTERLEAVING GLOBAL"]
     $this(C_inter) set_daughters_R [list $this(C_act_add_WS) $this(C_hier_edited_comets) $this(C_hier_existing_comets) $this(C_inter_PM_views)]

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
 if {$LM != ""} {this set_edited_root [this get_edited_root]
				}
 return $rep
}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic set_mothers {v} {
 this inherited $v
 this init_gdd_hierarchy
}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic Add_mother {m {index -1}} {
 this inherited $m $index
 this init_gdd_hierarchy
}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic init_gdd_hierarchy {} {
 set L_interactors [list]

 set dsl [this get_DSL_GDD_QUERY]
 $dsl QUERY "?t : IS_root : NODE()<-REL()*<-\$t(type == GDD_C&T)"
 foreach T [lindex [lindex [$dsl get_Result] 0] 1] {
   set root_GDD_node [[this get_L_roots] get_GDD_id]
   if {[gmlObject info exists object $root_GDD_node]} {set this(techno_ptf)    [$root_GDD_node get_ptf]
                                                      } else {set this(techno_ptf) Ptf_HTML}
   $dsl QUERY "?n : $T : NODE()<-REL()*<-\$n(type == GDD_FUI && ptf ~= $this(techno_ptf))"
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

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic Add_new_Comet {parent comet} {
 if {[regexp {^.*_item_(.*)$} $comet reco GDD_node]} {
   puts "  let's examine $GDD_node"
   if {[lsearch [gmlObject info classes $GDD_node] GDD_Node] >= 0} {
     set comet [lindex [interpretor_DSL_comet_interface Interprets  "${GDD_node}()" [CPool get_a_unique_name]] 0]
	 $comet Add_MetaData Generated_by_$objName 1
	} else {set comet $GDD_node}
  }
  
 $parent Add_daughters_R $comet
}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic Reset_PM_views {} {
 foreach LC [CSS++ $objName "#$this(C_container_canvas) *"] {
   if {[$LC Has_MetaData Generated_by_$objName]} {puts "  Disposing $LC"; $LC dispose}
  }
}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic get_L_h_edited_comet {root} {
 set L [list]
 foreach d [$root get_out_daughters] {
   lappend L [this get_L_h_edited_comet $d]
  }
  
 return [list $root [list name [$root get_name]] $L]
}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic Add_a_new_workspace {} {
 set new_WS [lindex [interpretor_DSL_comet_interface Interprets  "Container_CUI_window()" [CPool get_a_unique_name]] 0]
 $new_WS configure -Add_style_class "CONTAINER WORKSPACE" -Add_MetaData Generated_by_$objName 1 -set_name "WS"
 $this(C_container_canvas) Add_daughters_R $new_WS
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic get_possible_FUI {PM} {
 set L_GDD_FUI [Retrieve_equivalents_implem_of [this get_DSL_GDD_QUERY] [$PM get_GDD_id] "" "ptf ~= $this(techno_ptf)" 1]
 puts "L_GDD_FUI = $L_GDD_FUI"
}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic Exec_a_substitution {PM_FUI} {
 lassign $PM_FUI PM FUI
 set class [lindex [$FUI get_L_factories] 0]
 if {$class != ""} {
   if {[catch {set new_PM [$PM Substitute_by_PM_type $class]} err]} {set new_PM ""; puts stderr "  ERROR in \"$objName Exec_a_substitution {$PM_FUI}\":\n  $err"}
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic get_L_edited_PM {root} {
 set L [list]
 foreach d [$root get_out_daughters] {
   lappend L [this get_L_edited_PM $d]
  }
  

 set LC [$root get_LC]
 set L_att_val [list name [$LC get_name] class]
 if {[$LC Has_MetaData Generated_by_$objName]} {
   lappend L_att_val "Generated_by_CometEdition_comet_PM_P_U_basic Generated_by_$objName"
  } else {lappend L_att_val ""}
  
 return [list $root $L_att_val $L]
}

#___________________________________________________________________________________________________________________________________________
method CometEdition_comet_PM_P_U_basic Update_PMs_tree {} {
 $this(C_hier_PMs) set_L_h [this get_L_edited_PM [CSS++ $objName "#${objName}(CONTAINER.CANVAS.EDITION)"]]
}

#___________________________________________________________________________________________________________________________________________
Manage_CallbackList CometEdition_comet_PM_P_U_basic [list Add_a_new_workspace get_possible_FUI Exec_a_substitution Update_PMs_tree Add_new_Comet] end
