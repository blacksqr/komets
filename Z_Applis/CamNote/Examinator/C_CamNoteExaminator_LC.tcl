
inherit CometCamNote_Examinator Logical_consistency

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator constructor {name descr args} {
 this inherited $name $descr

 set CFC "${objName}_CFC"; 
   CommonFC_CamNoteExaminator $CFC
   this set_Common_FC $CFC

# Nested comets
 CometSlideRemoteController       ${objName}_telec "Examinator Remote Controller" "Remote Controller (${objName}_telec) of the Examinator"
 CometContainer                   ${objName}_visu_cont "Viewer" {}
 CometContainer                   ${objName}_telec_cont "Controller" {}
 CometCamNote_ExaminatorQuestions ${objName}_questions "Questions" "Allow to ask/save some questions about the presentation, questions may be related to some slides"
   ${objName}_telec_cont Add_daughter_R ${objName}_telec

 this Add_nested_daughters [list ${objName}_telec_cont ${objName}_questions] [list ${objName}_telec_cont ${objName}_visu_cont ${objName}_questions] {} {}
# this Add_nested_daughters [list ${objName}_img ${objName}_Examinator] [list ${objName}_telec ${objName}_visu_cont] {} {}

# Logical models
 set this(LM_LP) "${objName}_LM_LP";
   CometCamNote_Examinator_LM_P  $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);
 set this(LM_FC) "${objName}_LM_FC";
   CometCamNote_Examinator_LM_FC $this(LM_FC) $this(LM_FC) "This logical part manage different protocoles"
   this Add_LM $this(LM_FC);


# Evaluate arguments and return
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_Examinator [L_methodes_set_CamNote_Examinator] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometCamNote_Examinator [L_methodes_get_CamNote_Examinator] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator get_telec       {} {return ${objName}_telec}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator get_cont_telec  {} {return ${objName}_telec_cont}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator get_C_questions {} {return ${objName}_questions}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_Examinator set_slide_viewer {c} {
 ${objName}_visu_cont set_daughters_R $c
 foreach LM $this(L_LM) {$LM set_slide_viewer $c}
}
