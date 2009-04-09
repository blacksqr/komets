inherit WizardOfOz_Helper_LC Logical_consistency


#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_LC constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id WizardOfOz_Helper_LC
 set CFC "${objName}_CFC"; WizardOfOz_Helper_CFC $CFC
   this set_Common_FC $CFC

 set this(LM_LP) "${objName}_LM_LP";
   WizardOfOz_Helper_LM_P  $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);

# Some COMETs to be based on
 set this(C_presentation_type) [CPool get_a_comet CometChoice set_style_class presentation_type]; $this(C_presentation_type) set_nb_min_choices 1  ; $this(C_presentation_type) Subscribe_to_set_currents $objName "set C \[$this(C_presentation_type) get_currents\]; if {\$C != \"\"} {$objName set_presentation_type \[\$C get_name\]} else {$objName set_presentation_type {}}"
 set this(C_initiative_type)   [CPool get_a_comet CometChoice set_style_class initiative_type  ]; $this(C_initiative_type)   set_nb_min_choices 1  ; $this(C_initiative_type)   Subscribe_to_set_currents $objName "set C \[$this(C_initiative_type)   get_currents\]; if {\$C != \"\"} {$objName set_initiative_type   \[\$C get_name\]} else {$objName set_initiative_type   {}}"
# set this(C_L_notes)           ""
 set this(C_current_note)      [CPool get_a_comet CometSpecifyer set_style_class current_note  ]; $this(C_current_note)      Subscribe_to_set_text     $objName "$objName set_current_note \[$this(C_current_note) get_text\]"
 set this(C_L_topics)          [CPool get_a_comet CometChoice set_style_class L_topics         ]; $this(C_L_topics)          set_nb_min_choices 1  ; $this(C_L_topics)          Subscribe_to_set_currents $objName "set C \[$this(C_L_topics)          get_currents\]; if {\$C != \"\"} {$objName set_L_topics          \[\$C get_name\]} else {$objName set_L_topics          {}}"
 set this(C_trigger_strategy)  [CPool get_a_comet CometChoice set_style_class trigger_strategy ]; $this(C_trigger_strategy)  set_nb_max_choices 999; $this(C_trigger_strategy)  Subscribe_to_set_currents $objName "set C \[$this(C_trigger_strategy)  get_currents\]; if {\$C != \"\"} {$objName set_trigger_strategy  \[\$C get_name\]} else {$objName set_trigger_strategy  {}}"
 set this(C_interupt_strategy) [CPool get_a_comet CometChoice set_style_class interupt_strategy]; $this(C_interupt_strategy) set_nb_min_choices 999; $this(C_interupt_strategy) Subscribe_to_set_currents $objName "set C \[$this(C_interupt_strategy) get_currents\]; if {\$C != \"\"} {$objName set_interupt_strategy \[\$C get_name\]} else {$objName set_interupt_strategy {}}"
 
 set this(avatar_helper)       [CPool get_a_comet Avatar_Helper_LC set_style_class Avatar      ]; 
 
# Finish construction process
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_LC dispose {} {
 $this(C_presentation_type) dispose
 $this(C_initiative_type)   dispose
 $this(C_current_note)      dispose
 $this(C_L_topics)          dispose
 $this(C_trigger_strategy)  dispose
 $this(C_interupt_strategy) dispose
 
 this inherited
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors WizardOfOz_Helper_LC [list avatar_helper C_interupt_strategy C_trigger_strategy C_L_topics C_current_note C_initiative_type C_presentation_type]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC WizardOfOz_Helper_LC [L_methodes_set_WizardOfOz_Helper] {$this(FC)} {$this(L_LM)}
Methodes_get_LC WizardOfOz_Helper_LC [L_methodes_get_WizardOfOz_Helper] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_LC Update_daughers_of_with_Ltxt {C L_txt} {
 CPool Release_comets [$C get_out_daughters]
 foreach txt $L_txt {
   set c_txt [CPool get_a_comet CometText]
   $c_txt set_name $txt
   $C Add_daughter_R $c_txt
  }
}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_LC set_L_presentation_type {L_t} {this Update_daughers_of_with_Ltxt $this(C_presentation_type) $L_t}
method WizardOfOz_Helper_LC set_L_trigger_strategy  {L_t} {this Update_daughers_of_with_Ltxt $this(C_trigger_strategy)  $L_t}
method WizardOfOz_Helper_LC set_L_interupt_strategy {L_t} {this Update_daughers_of_with_Ltxt $this(C_interupt_strategy) $L_t}
method WizardOfOz_Helper_LC set_L_initiative_type   {L_t} {this Update_daughers_of_with_Ltxt $this(C_initiative_type)   $L_t}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_LC set_presentation_type {t} {
 set go 0; if {[$this(C_presentation_type) get_currents] == ""} {if {$t != ""} {set go 1}} else {if {[[$this(C_presentation_type) get_currents] get_name] != $t} {set go 1}}
 if {$go} {$this(C_presentation_type) set_currents_by_name $t}
 [this get_Common_FC] set_presentation_type $t
 foreach LM $this(L_LM) {$LM set_presentation_type $t}
}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_LC set_initiative_type {t} {
 set go 0; if {[$this(C_initiative_type) get_currents] == ""} {if {$t != ""} {set go 1}} else {if {[[$this(C_initiative_type) get_currents] get_name] != $t} {set go 1}}
 if {$go} {$this(C_initiative_type) set_currents_by_name $t}
 [this get_Common_FC] set_initiative_type $t
 foreach LM $this(L_LM) {$LM set_initiative_type $t}
}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_LC set_trigger_strategy {t} {
 set go 0; if {[$this(C_trigger_strategy) get_currents] == ""} {if {$t != ""} {set go 1}} else {if {[[$this(C_trigger_strategy) get_currents] get_name] != $t} {set go 1}}
 if {$go} {$this(C_trigger_strategy) set_currents_by_name $t}
 [this get_Common_FC] set_trigger_strategy $t
 foreach LM $this(L_LM) {$LM set_trigger_strategy $t}
}

#___________________________________________________________________________________________________________________________________________
method WizardOfOz_Helper_LC set_interupt_strategy {t} {
 set go 0; if {[$this(C_interupt_strategy) get_currents] == ""} {if {$t != ""} {set go 1}} else {if {[[$this(C_interupt_strategy) get_currents] get_name] != $t} {set go 1}}
 if {$go} {$this(C_interupt_strategy) set_currents_by_name $t}
 [this get_Common_FC] set_interupt_strategy $t
 foreach LM $this(L_LM) {$LM set_interupt_strategy $t}
}

