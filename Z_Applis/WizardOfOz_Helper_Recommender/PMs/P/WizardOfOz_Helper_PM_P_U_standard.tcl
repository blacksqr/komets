inherit WizardOfOz_Helper_PM_P_U_standard PM_U_Container

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_PM_P_U_standard constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id WizardOfOz_Helper_PM_P_U_standard
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_PM_P_U_standard dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_PM_P_U_standard set_LM {LM} {
 this inherited $LM
 set this(inter)   "${LM}_inter"
   set this(cont_daughters) "${LM}_cont_daughters"
   
 this set_L_nested_handle_LM    $this(inter)_LM_LP
 this set_L_nested_daughters_LM $this(cont_daughters)_LM_LP

 if {[info exists class($LM)]} {} else {
   set LC [this get_LC]
   set class($LM) $LM
   CometInterleaving $this(inter)   "remote controller's toplevel container" {}
   CometContainer    $this(cont_daughters)   "remote controller's container for daughters" {}
   $this(inter) Add_daughters_R [list [$LC get_avatar_helper] [$LC get_C_presentation_type] [$LC get_C_initiative_type] [$LC get_C_current_note] [$LC get_C_L_topics] [$LC get_C_trigger_strategy] [$LC get_C_interupt_strategy] $this(cont_daughters)]
  }
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC WizardOfOz_Helper_PM_P_U_standard [L_methodes_set_WizardOfOz_Helper] {}          {}
Methodes_get_LC WizardOfOz_Helper_PM_P_U_standard [L_methodes_get_WizardOfOz_Helper] {$this(FC)}
