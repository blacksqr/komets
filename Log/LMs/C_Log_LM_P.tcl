#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit CometLog_LM_P Logical_presentation

method CometLog_LM_P constructor {name descr args} {
 this inherited $name $descr
 
 set this(init_ok) 0
# Adding some nested comets
 set this(id_spec)   ${objName}_id_spec
 set this(pass_spec) ${objName}_pass_spec
 set    str "C_OkCa (-set_txt_OK Log -set_txt_CANCEL RESET"
 append str         ", |||(, $this(id_spec)   = C_Spec(set_name login)"
 append str               ", $this(pass_spec) = C_Spec(set_name pass)"
 append str              ")"
 append str        ")"

 set L_nested [interpretor_DSL_comet_interface Interprets $str ${objName}_nested]
 set c_ok_ca [lindex $L_nested 0]
 this Add_nested_daughters [lindex $L_nested 1] [lindex $L_nested 0] [lindex $L_nested 0] _LM_LP

   set i_DSL interpretor_DSL_comet_interface
   set r $this(id_spec)_LM_LP;   Encapsulate $r PM_Universal U_LM_encaps_specifyer_LM_P;
   $r Nested_style $i_DSL "${r}_nested_style_cont = C_Cont(,\"Login : \", [$r get_factice_LC]())" ${r}_nested_style_cont_LM_LP
   set r $this(pass_spec)_LM_LP; Encapsulate $r PM_Universal U_LM_encaps_specifyer_LM_P;
   $r Nested_style $i_DSL "${r}_nested_style_cont = C_Cont(,\"Passw : \", [$r get_factice_LC]())" ${r}_nested_style_cont_LM_LP


# Managing callbacks
 $this(id_spec)   Subscribe_to_set_text        $objName "\[$objName get_LC\] set_id   \[$this(id_spec)   get_text\]"
 $this(pass_spec) Subscribe_to_set_text        $objName "\[$objName get_LC\] set_pass \[$this(pass_spec) get_text\]"
 $c_ok_ca         Subscribe_to_activate_OK     $objName "\[$objName get_LC\] Task_is_completed; $c_ok_ca activate_CANCEL"
 $c_ok_ca         Subscribe_to_activate_CANCEL $objName "$this(id_spec) set_text {}; $this(pass_spec) set_text {};"

# Adding some physical presentations
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
   set name ${comet_name}_PM_P_basic_[this get_a_unique_id]
   CometLog_PM_P_basic_U $name "Computer Log" {A very basic Log}
   this Add_PM $name

 set this(init_ok) 1

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometLog_LM_P [L_methodes_set_Log] {$this(FC)} {$this(L_actives_PM)}
Methodes_get_LC CometLog_LM_P [L_methodes_get_Log] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method LogicalSpecifyer set_PM_active {PM} {
 this inherited $PM
 if {[string equal [this get_LC] {}]} {return}
 $PM set_id   [this get_id]
 $PM set_pass [this get_pass]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method LogicalSpecifyer Reset {} {
 $this(id_spec)   set_text {}
 $this(pass_spec) set_text {}
 foreach PM [this get_L_actives_PM] {$PM Reset}
}

