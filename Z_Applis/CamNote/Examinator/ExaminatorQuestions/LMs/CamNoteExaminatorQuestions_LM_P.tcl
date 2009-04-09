

#___________________________________________ Définition of Logical Model of présentation ___________________________________________________
inherit CometCamNote_ExaminatorQuestions_LM_P Logical_presentation

method CometCamNote_ExaminatorQuestions_LM_P constructor {name descr args} {
 this inherited $name $descr
 
 set this(init_ok) 0

# Adding some physical presentations
 if {[regexp "^(.*)_LM_LP" $objName rep comet_name]} {} else {set comet_name $objName}
   set name ${comet_name}_PM_P_standard_[this get_a_unique_id]
   CometCamNote_ExaminatorQuestions_PM_U $name "Standard presentation" "CamNote ($objName) standard presentation, only based on nested element presentations of $comet_name"
   this Add_PM $name

 set this(init_ok) 1

 eval "$objName configure $args"
 return $objName
}


#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_ExaminatorQuestions_LM_P [L_methodes_set_CamNote_ExaminatorQuestions] {$this(FC)} {$this(L_actives_PM)}
Methodes_get_LC CometCamNote_ExaminatorQuestions_LM_P [L_methodes_get_CamNote_ExaminatorQuestions] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#method CometCamNote_ExaminatorQuestions_LM_P set_LC {LC} {
# this inherited $LC
# ${objName}_interleaving_for_LC_nested set_daughters_R [$LC get_handle_composing_comet]
#}
