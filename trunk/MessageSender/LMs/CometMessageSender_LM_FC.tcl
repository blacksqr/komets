#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit CometMessageSender_LM_FC Logical_model

#___________________________________________________________________________________________________________________________________________
method CometMessageSender_LM_FC constructor {name descr args} {
 this inherited $name $descr
 
# Adding some physical models
 set name ${objName}_PM_FC_pipo_[this get_a_unique_id]
 CometMessageSender_PM_FC_pipo $name "Pipo FC for testing" ""
   this Add_PM        $name
   this set_PM_active $name
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometMessageSender_LM_FC [P_L_methodes_set_CometMessageSender] {} {$this(L_actives_PM)}
Methodes_get_LC CometMessageSender_LM_FC [P_L_methodes_get_CometMessageSender] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
proc P_L_methodes_set_CometMessageSender_FC_COMET_RE {} {return [list {set_travel {t}}]}
  Generate_LM_setters CometMessageSender_LM_FC [P_L_methodes_set_CometMessageSender_FC_COMET_RE]
