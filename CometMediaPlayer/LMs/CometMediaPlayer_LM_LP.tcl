inherit CometMediaPlayer_LM_LP Logical_presentation

#___________________________________________________________________________________________________________________________________________
method CometMediaPlayer_LM_LP constructor {name descr args} {
 this inherited $name $descr
# Adding some physical presentations 
 this Add_PM_factories [Generate_factories_for_PM_type [list \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometMediaPlayer_LM_LP [P_L_methodes_set_CometMediaPlayer] {} {$this(L_actives_PM)}
Methodes_get_LC CometMediaPlayer_LM_LP [P_L_methodes_get_CometMediaPlayer] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometMediaPlayer_COMET_RE {} {return [list]}
Generate_LM_setters CometMediaPlayer_LM_LP [P_L_methodes_set_CometMediaPlayer_COMET_RE]

#___________________________________________________________________________________________________________________________________________


