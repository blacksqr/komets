#___________________________________________________________________________________________________________________________________________
inherit RepresentationComet_LM_LP Logical_presentation
#___________________________________________________________________________________________________________________________________________
method RepresentationComet_LM_LP constructor {name descr args} {
 this inherited $name $descr
 this set_L_actives_PM {}

 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
 set this(comet_name) $comet_name

  this Add_PM_factories [Generate_factories_for_PM_type [list {PM_P_RepresentationComet_U_txt_img Ptf_ALL} \
                                                        ] $objName]
 eval "$objName configure $args"
 return $objName
}
#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC RepresentationComet_LM_LP [P_L_methodes_set_RepresentationComet] {} {$this(L_actives_PM)}
Methodes_get_LC RepresentationComet_LM_LP [P_L_methodes_get_RepresentationComet] {$this(FC)}

#______________________________________________________ Adding the choices functions _______________________________________________________
method RepresentationComet_LM_LP set_PM_active {PM} {
 this inherited $PM
 $PM set_RepresentedComet [this get_RepresentedComet]
}
