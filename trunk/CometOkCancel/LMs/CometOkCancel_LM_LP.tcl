#___________________________________________________________________________________________________________________________________________
#___________________________________________ Définition of Logical Model of présentation____________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit LogicalCometOkCancel Logical_presentation
#___________________________________________________________________________________________________________________________________________
method LogicalCometOkCancel constructor {name descr args} {
 set this(init_ok) 0
 this inherited $name $descr
 this set_L_actives_PM {}
 set this(num_sub) 0
 
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
 set this(comet_name) $comet_name

# Nesting parts
 set this(il)         "${objName}_nested_interleaving"
 set this(contents)   "${objName}_contents"
 set this(activators) "${objName}_activators"
 set this(act_OK)     "${objName}_act_OK"
 set this(act_CANCEL) "${objName}_act_CANCEL"

 set    str "$this(il) =   |||(, $this(contents)   = C_Cont()"
 append str                   ", $this(activators) = C_Cont(, $this(act_OK)     = C_Act(-set_name OK -set_text OK)"
 append str                                                ", $this(act_CANCEL) = C_Act(-set_name CANCEL -set_text CANCEL)"
 append str                                               ")"
 append str                  ")"

 interpretor_DSL_comet_interface Interprets $str $objName
   $this(contents)   set_style_class contents
   $this(activators) set_style_class activators

 this Add_nested_daughters [list $this(il) $this(contents) $this(activators) $this(act_OK) $this(act_CANCEL)] \
                           $this(il)                                                                          \
                           $this(contents)                                                                    \
                           _LM_LP

# Bindings
 $this(act_OK)     Subscribe_to_activate $objName "\[$objName get_LC\] activate_OK"
 $this(act_CANCEL) Subscribe_to_activate $objName "\[$objName get_LC\] activate_CANCEL"

# Styling
  foreach PM_i [$this(activators)_LM_LP get_L_compatible_actives_PM_with_ptf Ptf_TK] {
    $PM_i set_cmd_placement {pack $p -side left -expand 1 -fill both}
   }

# Adding some PM of presentations
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
   set PM_U "${comet_name}_PM_U_[this get_a_unique_id]"
   U_PM_for_LM_only $PM_U $PM_U "Nothing"
   this Add_PM $PM_U
   this set_PM_active $PM_U

 set this(init_ok) 1


 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC LogicalCometOkCancel [L_methodes_set_CometOkCancel] {$this(FC)} {$this(L_actives_PM)}
Methodes_get_LC LogicalCometOkCancel [L_methodes_get_CometOkCancel] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method LogicalCometOkCancel set_txt_CANCEL {t} {$this(act_CANCEL) set_text $t}
method LogicalCometOkCancel set_txt_OK     {t} {$this(act_OK)     set_text $t}

#___________________________________________________________________________________________________________________________________________
