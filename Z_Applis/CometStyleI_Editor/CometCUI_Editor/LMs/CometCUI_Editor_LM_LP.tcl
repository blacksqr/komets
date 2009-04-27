inherit CometCUI_Editor_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometCUI_Editor_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCUI_Editor_LM_LP [P_L_methodes_set_CometCUI_Editor] {} {$this(L_actives_PM)}
Methodes_get_LC CometCUI_Editor_LM_LP [P_L_methodes_get_CometCUI_Editor] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometCUI_Editor_COMET_RE {} {return [list]}
Generate_LM_setters CometCUI_Editor_LM_LP [P_L_methodes_set_CometCUI_Editor_COMET_RE]

#___________________________________________________________________________________________________________________________________________


