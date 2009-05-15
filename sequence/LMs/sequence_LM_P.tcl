#___________________________________________________________________________________________________________________________________________
inherit Sequence_LM_LP Logical_presentation
#___________________________________________________________________________________________________________________________________________
method Sequence_LM_LP constructor {name descr args} {
 set this(init_pas_ok) 1
 this inherited $name $descr
 this set_L_actives_PM {}
 set this(num_sub) 0

 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
 set this(comet_name) $comet_name

 #{PM_P_sequence_TK_basic Ptf_TK} 
  this Add_PM_factories [Generate_factories_for_PM_type [list {Sequence_PM_P_U Ptf_ALL} \
                                                        ] $objName]
 set this(init_pas_ok) 0
 eval "$objName configure $args"
 return $objName
}
#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC Sequence_LM_LP [L_methodes_set_sequence] {} {$this(L_actives_PM)}
Methodes_get_LC Sequence_LM_LP [L_methodes_get_sequence] {$this(FC)}

Generate_LM_setters Sequence_LM_LP [L_methodes_set_sequence]
