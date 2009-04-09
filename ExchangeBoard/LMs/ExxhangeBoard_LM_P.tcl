#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit ExchangeBoard_LM_LP Logical_presentation

method ExchangeBoard_LM_LP constructor {name descr args} {
 this inherited $name $descr

 this Add_PM_factories [Generate_factories_for_PM_type [list {ExchangeBoard_PM_P_U_basic Ptf_ALL}    \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC ExchangeBoard_LM_LP [P_L_methodes_set_ExchangeBoard] {} {$this(L_actives_PM)}
Methodes_get_LC ExchangeBoard_LM_LP [P_L_methodes_get_ExchangeBoard] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method ExchangeBoard_LM_LP set_PM_active {PM} {
 this inherited $PM
 if {[string equal [this get_LC] {}]} {return}
 #$PM set_L_comets [this get_L_comets]
 [this get_LC] Update
}
