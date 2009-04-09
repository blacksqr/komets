inherit CometQuestion_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometQuestion_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometQuestion_PM_P_TK_basic Ptf_TK} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometQuestion_LM_LP [P_L_methodes_set_CometQuestion] {} {$this(L_actives_PM)}
Methodes_get_LC CometQuestion_LM_LP [P_L_methodes_get_CometQuestion] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometQuestion_COMET_RE {} {return [list {set_question {v}} {set_sentence {v}} {Ask_sentence {}}]}
Generate_LM_setters CometQuestion_LM_LP [P_L_methodes_set_CometQuestion_COMET_RE]

#___________________________________________________________________________________________________________________________________________


