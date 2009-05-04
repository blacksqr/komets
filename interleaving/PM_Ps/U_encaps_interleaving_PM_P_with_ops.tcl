inherit U_encaps_interleaving_PM_P_with_op PM_Universal_encapsulator

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method U_encaps_interleaving_PM_P_with_op constructor {name descr core_tmp args} {
# set core_tmp [Interleaving_PM_P_TK_frame "${objName}_core_tmp" "core of $objName" "The core model of $objName"]
 this inherited $name $descr $core_tmp
 set this(core_tmp) $core_tmp

# setting up the operations comets
 set this(LC_Spec_add) [CometSpecifyer "${objName}_nested_spec_add" "${objName}_nested_spec_add" {Nested specifyer for adding new daughters}]
 set this(LC_Act_add)  [CometActivator "${objName}_nested_act_add"  "${objName}_nested_act_add"  {Nested activator for adding new daughters}]
 set str {}
 append str "C_Cont(, [this get_factice_LC](), C_Cont(, $this(LC_Spec_add)(), $this(LC_Act_add)()) )"
 this Nested_style interpretor_DSL_comet_interface $str $this(core_tmp)

# Bindings of operations comets to this one
 $this(LC_Act_add)  Subscribe_to_activate $objName "\[$objName get_LC\] Add_daughters_R \[list \[$this(LC_Spec_add) get_text\]\]"

# The return
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method U_encaps_interleaving_PM_P_with_op get_LC_Act_add  {} {return $this(LC_Act_add)}
method U_encaps_interleaving_PM_P_with_op get_LC_Spec_add {} {return $this(LC_Spec_add)}

#__________________________________________________
Methodes_set_LC U_encaps_interleaving_PM_P_with_op [P_L_methodes_set_CometInterleaving] {}  {}
Methodes_get_LC U_encaps_interleaving_PM_P_with_op [P_L_methodes_get_CometInterleaving] {}

