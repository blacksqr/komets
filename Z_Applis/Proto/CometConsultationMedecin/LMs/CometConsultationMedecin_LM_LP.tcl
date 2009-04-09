inherit CometConsultationMedecin_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometConsultationMedecin_PM_P_TK_basic Ptf_TK} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometConsultationMedecin_LM_LP [P_L_methodes_set_CometConsultationMedecin] {} {$this(L_actives_PM)}
Methodes_get_LC CometConsultationMedecin_LM_LP [P_L_methodes_get_CometConsultationMedecin] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometConsultationMedecin_COMET_RE {} {return [list {set_choice {v}} {set_question {v}} {validate {}} {cancel {}}]}
Generate_LM_setters CometConsultationMedecin_LM_LP [P_L_methodes_set_CometConsultationMedecin_COMET_RE]

#___________________________________________________________________________________________________________________________________________


