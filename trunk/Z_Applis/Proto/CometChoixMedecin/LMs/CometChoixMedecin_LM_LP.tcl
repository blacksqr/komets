inherit CometChoixMedecin_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometChoixMedecin_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometChoixMedecin_PM_P_TK_basic Ptf_TK} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometChoixMedecin_LM_LP [P_L_methodes_set_CometChoixMedecin] {} {$this(L_actives_PM)}
Methodes_get_LC CometChoixMedecin_LM_LP [P_L_methodes_get_CometChoixMedecin] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometChoixMedecin_COMET_RE {} {return [list {set_question {v}} {set_choice {v}} {validate {}} {cancel {}}]}
Generate_LM_setters CometChoixMedecin_LM_LP [P_L_methodes_set_CometChoixMedecin_COMET_RE]

#___________________________________________________________________________________________________________________________________________


