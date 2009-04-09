
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometCamNote_ExaminatorQuestions_PM_U PM_U_Container

#___________________________________________________________________________________________________________________________________________
method CometCamNote_ExaminatorQuestions_PM_U constructor {name descr args} {
 this inherited $name $descr
   this set_nb_max_mothers 1
   this set_cmd_placement {}
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote_ExaminatorQuestions_PM_U [L_methodes_set_CamNote_ExaminatorQuestions] {$this(FC)} {}
Methodes_get_LC CometCamNote_ExaminatorQuestions_PM_U [L_methodes_set_CamNote_ExaminatorQuestions] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_ExaminatorQuestions_PM_U get_XML_id {} {
 return [CSS++ $objName "#$objName\($this(internal_spec)\)"]
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_ExaminatorQuestions_PM_U set_LM {LM} {
 if {[string equal [this get_LM] {}]} {
   this inherited $LM
   set this(internal_spec) CometCamNote_ExaminatorQuestions_PM_U_${LM}_C_spec
   if {[gmlObject info exists object $this(internal_spec)]} {} else {
     CometSpecifyer $this(internal_spec) "Internal specifyer for HTML represenation of [this get_LC]" {}
    }
   set L $this(internal_spec)_LM_LP
   this set_L_nested_handle_LM    $L
   #this set_L_nested_daughters_LM $L
  } else {this inherited $LM}
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote_ExaminatorQuestions_PM_U set_question {Q num_slide} {
 $this(internal_spec) set_text $Q
}
