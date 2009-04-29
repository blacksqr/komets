inherit CometCUI_Editor_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometCUI_Editor_PM_P_U_basic Ptf_ALL}\
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCUI_Editor_LM_LP [P_L_methodes_set_CometCUI_Editor] {} {$this(L_actives_PM)}
Methodes_get_LC CometCUI_Editor_LM_LP [P_L_methodes_get_CometCUI_Editor] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometCUI_Editor_COMET_RE {} {return [list {set_gdd_op_file {v}} {Sub_L_mapping {L}} {Add_L_mapping {L}} {set_L_mapping {L}} {set_ptf_of_CUI {v}} {set_edited_comet {v}} {set_style_file {v}} {Apply_style {}} ]}
Generate_LM_setters CometCUI_Editor_LM_LP [P_L_methodes_set_CometCUI_Editor_COMET_RE]

#___________________________________________________________________________________________________________________________________________


