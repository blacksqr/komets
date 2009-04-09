#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit CometTravel_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometTravel_LM_LP constructor {name descr args} {
 this inherited $name $descr
 
# Adding some physical presentations
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometTravel_PM_P_TK_base Ptf_TK} \
                                                             {CometTravel_PM_P_U Ptf_ALL}      \
                                                       ] $objName]

 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometTravel_LM_LP [P_L_methodes_set_CometTravel] {} {$this(L_actives_PM)}
Methodes_get_LC CometTravel_LM_LP [P_L_methodes_get_CometTravel] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometTravel_COMET_RE {} {return [list {set_loc_src {l}} {set_loc_dst {l}} {Compute_travel {}}]}
  Generate_LM_setters CometTravel_LM_LP [P_L_methodes_set_CometTravel_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometTravel_LM_LP set_PM_active {PM} {
 this inherited $PM
 if {[string equal [this get_LC] {}]} {return}
 $PM set_loc_src [this get_loc_src]
 $PM set_loc_dst [this get_loc_dst]
 $PM set_travel  [this get_travel]
}
