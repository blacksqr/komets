#___________________________________________________________________________________________________________________________________________
inherit CSS_Meta_IHM_PM_P_U_1 PM_U_Container
#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_CSS_Meta_IHM_AUI_basic_CUI_Composite_Universal
   set this(reconnect_LM) 0
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
#method CSS_Meta_IHM_PM_P_U_1 CSS_Meta_IHM_PM_P_U_1 {root} {
## Define the handle
# set f $root.tk_${objName}_frame
# if {[winfo exists $f]} {
#  } else {frame $f -bd 0 -relief raised}
# this set_root_for_daughters $f
#
# return [this set_prim_handle $f]
#}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CSS_Meta_IHM_PM_P_U_1 [L_methodes_set_CSS_Meta_IHM_LM_LP] {$this(FC)} {}
Methodes_get_LC CSS_Meta_IHM_PM_P_U_1 [L_methodes_get_CSS_Meta_IHM]       {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CSS_Meta_IHM_PM_P_U_1 [L_methodes_set_CSS_Meta_IHM_LM_LP]

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Select_elements {L} {
 #puts "$objName Select_elements {$L}"
 if {[gmlObject info exists object $this(interleaving)]} {
   if {[$this(txt_sel) get_text] != $L} {
     $this(txt_sel)  set_text $L
	 set txt "#"; append txt [lindex $L 0]; foreach e [lrange $L 1 end] {append $txt ", #" $e}
	 $this(spec_sel) set_text $txt
    }
  }
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 set_LM {LM} {
 this inherited $LM
 set this(interleaving)   "${objName}_CSS_Meta_IHM_PM_P_U_interleaving"
   set this(cont_selector) "${objName}_CSS_Meta_IHM_PM_P_U_selector"
     set this(spec_sel)      "${objName}_CSS_Meta_IHM_PM_P_U_spec_sel"
     set this(act_sel)       "${objName}_CSS_Meta_IHM_PM_P_U_act_sel"
     set this(txt_sel)       "${objName}_CSS_Meta_IHM_PM_P_U_txt_sel"
   set this(cont_rules)    "${objName}_CSS_Meta_IHM_PM_P_U_cont_rules"
     set this(spec_r_name)   "${objName}_CSS_Meta_IHM_PM_P_U_spec_r_name"
     set this(spec_rules)    "${objName}_CSS_Meta_IHM_PM_P_U_spec_rules"
     set this(cont_op_rules) "${objName}_CSS_Meta_IHM_PM_P_U_cont_op_rules"
       set this(act_save)      "${objName}_CSS_Meta_IHM_PM_P_U_act_save"
       set this(act_del)       "${objName}_CSS_Meta_IHM_PM_P_U_act_del"
   set this(cont_set)      "${objName}_CSS_Meta_IHM_PM_P_U_set"
     set this(cc_set)        "${objName}_CSS_Meta_IHM_PM_P_cc_set"
     set this(act_apply)     "${objName}_CSS_Meta_IHM_PM_P_act_apply"
   set this(inter_files)   "${objName}_CSS_Meta_IHM_PM_P_U_inter_files"
     set this(load_rules)    "${objName}_CSS_Meta_IHM_PM_P_U_load_rules"
     set this(save_rules)    "${objName}_CSS_Meta_IHM_PM_P_U_save_rules"

# set L [list $this(bt_bgn) $this(bt_prv) $this(ccn) $this(bt_nxt) $this(bt_end)]
 set L $this(interleaving)_LM_LP
 this set_L_nested_handle_LM    $L
 this set_L_nested_daughters_LM $L
 
 if {![gmlObject info exists object $this(interleaving)]} {
#   set class($LM) $LM
   CometInterleaving $this(interleaving) "Top level interleaving of $objName" {}
     CometContainer $this(cont_selector) "Selector group"     {} -Add_style_class selector_group
       CometSpecifyer $this(spec_sel) "Selector Specifyer" {} -Add_style_class selector_txt
       CometActivator $this(act_sel)  "Selector Activator" "Let's find COMET element specifyed in $this(spec_sel)"   -Add_style_class selector_act
       CometText      $this(txt_sel)  "Selector Results"   "Let's render COMET element specifyed in $this(spec_sel)" -Add_style_class selector_res
     CometContainer $this(cont_rules)    "Rules group"        {}
       CometSpecifyer $this(spec_r_name) "Rules name" {} -Add_style_class rule_name
       CometContainer $this(cont_op_rules) "Container of Operation apllyable on rules set" {} -Add_style_class rules_operations
         CometActivator $this(act_save)    "Save rule" {}              -Add_style_class rule_save
         CometActivator $this(act_del)     "Delete Selected Rules"  {} -Add_style_class rule_delete -set_text "DELETE SELECTED RULES"
       CometSpecifyer $this(spec_rules)  "Rules"      {} -Add_style_class rules_spec
     CometContainer $this(cont_set)      "set of rules group" {}  -Add_style_class rules_set
       CometChoice    $this(cc_set)    "Choice of set of rules" {} -Add_style_class rules_choice
       CometActivator $this(act_apply) "Rules" {}         -Add_style_class apply
     CometInterleaving $this(inter_files) "Files" {} -Add_style_class files_operations
       CometChoice    $this(load_rules) "Load rules" {} -Add_style_class rules_load
       CometSpecifyer $this(save_rules) "Save rules" {} -Add_style_class rules_save

  # Configuration
   $this(load_rules) configure -set_nb_max_choices 9999 -Subscribe_to_set_currents $objName "$objName Load_rules_from_files" 1
   $this(save_rules) configure -Subscribe_to_set_text $objName "$objName Save_rules_to_files" 1
   $this(cc_set)    configure set_nb_max_choices 9999 -Add_style_class set   -Subscribe_to_set_currents $objName "$objName set_current_rule" 1
   $this(act_sel)   configure set_text FIND           -Add_style_class find  -Subscribe_to_activate $objName "$objName Process_selector" 1
   $this(act_save)  configure set_text "SAVE RULE"    -Add_style_class save  -Subscribe_to_activate $objName "$objName Save_rules" 1
   $this(act_del)   configure -Subscribe_to_activate $objName "$objName Delete_rules" 1
   $this(act_apply) configure set_text "APPLY RULES"  -Add_style_class apply -Subscribe_to_activate $objName "$objName Apply_rules" 1
   set this(reconnect_LM) 1
  }

 if {$this(reconnect_LM)} {
   $this(interleaving) Add_daughters_R [list $this(cont_selector) $this(cont_rules) $this(cont_set) $this(inter_files)]
     $this(cont_selector) Add_daughters_R [list $this(spec_sel) $this(act_sel) $this(txt_sel)]
     $this(cont_rules)    Add_daughters_R [list $this(spec_r_name) $this(cont_op_rules) $this(spec_rules)]
       $this(cont_op_rules) Add_daughters_R [list $this(act_del) $this(act_save)]
     $this(cont_set)      Add_daughters_R [list $this(cc_set) $this(act_apply)]
     $this(inter_files)   Add_daughters_R [list $this(load_rules) $this(save_rules)]
   set this(reconnect_LM) 0  
  }
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Process_selector {} {
 set sel [$this(spec_sel) get_text]
   set root [lindex [this get_L_roots] 0]
   set L [CSS++ $root $sel]
   $this(txt_sel) set_text   $L
   this prim_Select_elements $L
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 set_current_rule {} {
 set current      [lindex [$this(cc_set) get_currents] end]
 if {[string equal $current {}]} {
   set r {}
   #puts "$objName : Aucune règle sélectionné"
  } else {set current_name [$current get_name]
          set r [this get_rule_named $current_name]
          #puts "$objName : Règle dans $current ([$current get_name])"
         }
 $this(spec_r_name) set_text [lindex $r 0]
 $this(spec_rules)  set_text [lindex $r 1]
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Delete_rules {} {
 set L {}
 foreach e [$this(cc_set) get_currents] {
   lappend L [$e get_name]
  }
 [this get_LC] Delete_rules_named $L
# this Delete_rules_named $L
 #this Update_rules_presentations
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Load_styles {f_name} {
 #puts "$objName Load_styles $f_name"
 this Update_rules_presentations
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Load_rules_from {f} {[this get_Common_FC] Load_styles $f}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Load_rules_from_files {} {
 set f_name [$this(load_rules) get_currents]
 #puts "$objName Load_rules_from_files\n  - set f_name \[$this(load_rules) get_currents\] == [$this(load_rules) get_currents]"
 if {[string equal $f_name ""]} {puts "Pas bon"; return}
   #[this get_Common_FC] Load_styles $f_name
   [this get_LC] Load_styles $f_name
 $this(load_rules) set_currents ""
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Save_rules_to_files {} {
 set f_name [$this(save_rules) get_text]
 if {[string equal $f_name ""]} {return}
 [this get_Common_FC] Save_styles_to_meta_style_file $f_name
 $this(save_rules) set_text ""
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Select_rules {L_r_names} {
 #puts "$objName Select_rules {$L_r_names}"
 set Lc {}
 foreach r_names $L_r_names {
   foreach c [$this(cc_set) get_out_daughters] {
     if {[string equal $r_names [$c get_name]]} {lappend Lc $c; break;}
    }
  }
 $this(cc_set) set_currents $Lc
 return $Lc
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Update_rules_presentations {} {
 #puts "$objName Update_rules_presentations"
 set pos 0
 set L_comet_daughters [$this(cc_set) get_out_daughters]
 foreach r [this get_L_set_of_rules] {
   set comet_text [lindex $L_comet_daughters $pos]
   if {[string equal $comet_text {}]} {
     set comet_text [CometText ${objName}_cc_set_CG_[$this(cc_set)_LM_LP get_a_unique_id] [lindex $r 0] {}]
     $this(cc_set) Add_daughter_R $comet_text
    }
   $comet_text configure -set_name [lindex $r 0] -set_text [lindex $r 0]
   incr pos
  }
 $this(cc_set) Sub_daughters_R [lrange $L_comet_daughters $pos end]
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Save_rules {} {
 set r_name [$this(spec_r_name) get_text]
 this Maj_set_of_rules $r_name [$this(spec_rules) get_text]
# Vérifier si on a déja cet ensemble dans la liste de règles
 foreach r [$this(cc_set) get_out_daughters] {
   if {[string equal $r_name [$r get_name]]} {return}
  }
# Si on ne l'a pas déja, rajouter la règle dans la liste des choix
 $this(cc_set) Add_daughter_R [CometText ${objName}_cc_set_CG_[$this(cc_set)_LM_LP get_a_unique_id] $r_name {} -set_text $r_name]
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Delete_rules_named {L_names} {
 set L {}
 foreach r [$this(cc_set) get_out_daughters] {
   set name [$r get_name]
   if {[lsearch $L_names $name] != -1} {lappend L $r}
  }
 $this(cc_set) Sub_daughters_R $L
}

#___________________________________________________________________________________________________________________________________________
method CSS_Meta_IHM_PM_P_U_1 Apply_rules {} {
 #puts "$objName Apply_rules"
 set L {}
 foreach r [$this(cc_set) get_currents] {
   lappend L [$r get_name]
  }
 set root [lindex [this get_L_roots] 0]
 this Apply_set_of_rules_to $root $L
}
