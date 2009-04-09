#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit CometTravel_LM_FC Logical_model

#___________________________________________________________________________________________________________________________________________
method CometTravel_LM_FC constructor {name descr args} {
 this inherited $name $descr
 
# Adding some physical models
 set name ${objName}_PM_FC_pipo_[this get_a_unique_id]
 CometTravel_PM_FC_pipo $name "Pipo FC for testing" ""
   this Add_PM        $name
   this set_PM_active $name
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometTravel_LM_FC [P_L_methodes_set_CometTravel] {} {$this(L_actives_PM)}
Methodes_get_LC CometTravel_LM_FC [P_L_methodes_get_CometTravel] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometTravel_FC_COMET_RE {} {return [list {set_travel {t}}]}
  Generate_LM_setters CometTravel_LM_FC [P_L_methodes_set_CometTravel_FC_COMET_RE]
