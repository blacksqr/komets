

#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit CometSlideRemoteController_LM_P ChoiceN_LM_LP

method CometSlideRemoteController_LM_P constructor {name descr args} {
puts "AVANT"
 this inherited $name $descr

 set this(init_ok) 0

# Clean up previous presentations
 set L [this get_L_PM]
 this set_L_PM         {}
 this set_L_actives_PM {}
 foreach PM $L {$PM dispose}
 set L [this get_PM_factories]
 this set_PM_factories {}
 foreach f $L {$f dispose}

# Adding some physical presentations
 this Add_PM_factories [Generate_factories_for_PM_type [list {SlideRemoteController_PM_P_ALX_TXT Ptf_ALX_TXT} \
                                                             {CometSlideRemoteController_PM_P_basic Ptf_ALL}  \
                                                       ] $objName]
 set this(init_ok) 1

 eval "$objName configure $args"
 puts "APRES"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometSlideRemoteController_LM_P [L_methodes_set_SlideRemoteController] {} {$this(L_actives_PM)}
Methodes_get_LC CometSlideRemoteController_LM_P [L_methodes_get_SlideRemoteController] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_LM_setters CometSlideRemoteController_LM_P [L_methodes_set_SlideRemoteController]

#___________________________________________________________________________________________________________________________________________
method CometSlideRemoteController_LM_P set_PM_active {PM} {
 this inherited $PM
 if {[string equal [this get_LC] {}]} {return}
 $PM set_L_slides [this get_L_slides]
}
