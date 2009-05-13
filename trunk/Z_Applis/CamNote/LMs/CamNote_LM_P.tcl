#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit CometCamNote_LM_P Logical_presentation

method CometCamNote_LM_P constructor {name descr args} {
 this inherited $name $descr
 
 set this(init_ok) 0
  
# Adding some physical presentations
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
#   set name ${comet_name}_PM_P_standard_[this get_a_unique_id]
#   CometCamNote_PM_U $name "Standard presentation" "CamNote ($objName) standard presentation, only based on nested element presentations of $comet_name"
#   this Add_PM $name
 this Add_PM_factories [Generate_factories_for_PM_type [list {CometCamNote_PM_ALX_TXT Ptf_ALX_TXT} \
                                                             {CometCamNote_PM_U Ptf_ALL}           \
                                                       ] $objName]
# {CometCamNote_PM_P_BIGre_classic Ptf_BIGre} 

# CometInterleaving ${objName}_interleaving_for_LC_nested "||| for LC" {An interleaving to connect LC nested comets}
# this Add_nested_daughters [list ${objName}_interleaving_for_LC_nested] [list ${objName}_interleaving_for_LC_nested] {} _LM_LP
 set this(init_ok) 1

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_LM_P [L_methodes_set_CamNote] {$this(FC)} {$this(L_actives_PM)}
Methodes_get_LC CometCamNote_LM_P [L_methodes_get_CamNote] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_LM_P set_LC {LC} {
 this inherited $LC
# ${objName}_interleaving_for_LC_nested set_daughters_R [list [this get_speaker] ${LC}_cc_mode]
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_LM_P Add_Examinator {n p id} {
# ${objName}_interleaving_for_LC_nested Add_daughter_R [[this get_Common_FC] get_user_comet_from_id $id]
 foreach PM [this get_L_actives_PM] {$PM Add_Examinator $n $p $id}
}
