#_______________________________________________________________________________
inherit CometViewer_LM_FC Logical_model

#___________________________________________________________________________________________________________________________________________
method CometViewer_LM_FC constructor {name descr args} {
 this inherited $name $descr
 
 set PM [CPool get_a_comet CometViewer_PM_FC_basic]
 this Add_PM $PM; this set_PM_active $PM
 
 eval "$objName configure $args"
 return $objName
}

#______________________________________________________ Adding the viewer functions _______________________________________________________
Methodes_set_LC CometViewer_LM_FC [L_methodes_set_CometViewer] {}          {$this(L_actives_PM)}
Methodes_get_LC CometViewer_LM_FC [L_methodes_get_CometViewer] {$this(FC)}

#______________________________________________________ Adding the viewer functions _______________________________________________________
proc P_L_methodes_FC_set_CometViewer_COMET_RE {} {return [list {set_dot_description {v}} ]}
  Generate_LM_setters CometViewer_LM_FC [P_L_methodes_FC_set_CometViewer_COMET_RE]
