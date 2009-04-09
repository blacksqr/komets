
inherit CometCamNote_ExaminatorQuestions Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometCamNote_ExaminatorQuestions constructor {name descr args} {
 this inherited $name $descr

 set CFC "${objName}_CFC"; 
   CommonFC_CamNoteExaminatorQuestions $CFC
   this set_Common_FC $CFC

# Logical models
 set this(LM_LP) "${objName}_LM_LP";
   CometCamNote_ExaminatorQuestions_LM_P  $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);
 set this(LM_FC) "${objName}_LM_FC";
   CometCamNote_ExaminatorQuestions_LM_FC $this(LM_FC) $this(LM_FC) "This logical part manage different protocoles"
   this Add_LM $this(LM_FC);


# Evaluate arguments and return
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_ExaminatorQuestions dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_ExaminatorQuestions [L_methodes_set_CamNote_ExaminatorQuestions] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometCamNote_ExaminatorQuestions [L_methodes_get_CamNote_ExaminatorQuestions] {$this(FC)}

