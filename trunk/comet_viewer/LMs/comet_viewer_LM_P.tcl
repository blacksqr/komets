
#_______________________________________________________________________________
inherit CometViewer_LM_P Logical_model

#___________________________________________________________________________________________________________________________________________
method CometViewer_LM_P constructor {name descr args} {
 this inherited $name $descr
 
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometViewer_PM_P_B207_basic Ptf_BIGre} \
                                                       ] $objName]

 eval "$objName configure $args"
 return $objName
}

#______________________________________________________ Adding the viewer functions _______________________________________________________
Methodes_set_LC CometViewer_LM_P [L_methodes_set_CometViewer] {}          {$this(L_actives_PM)}
Methodes_get_LC CometViewer_LM_P [L_methodes_get_CometViewer] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_PM_set_CometViewer_COMET_RE {} {return [list {set_represented_element {v}} {set_go_out_daughters {v}} {set_go_inside_level {v}} ]}
  Generate_LM_setters CometViewer_LM_P [P_L_methodes_PM_set_CometViewer_COMET_RE]
