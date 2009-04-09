#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometQuestion_PM_P_TK_basic PM_TK

#___________________________________________________________________________________________________________________________________________
method CometQuestion_PM_P_TK_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CometQuestion_PM_P_TK_basic
   set this(top_frame) ""
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method CometQuestion_PM_P_TK_basic dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometQuestion_PM_P_TK_basic [P_L_methodes_set_CometQuestion] {} {}
Methodes_get_LC CometQuestion_PM_P_TK_basic [P_L_methodes_get_CometQuestion] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometQuestion_PM_P_TK_basic [P_L_methodes_set_CometQuestion_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometQuestion_PM_P_TK_basic Add_prim_mother {c L_prims {index -1}} {
 pack $this(top_frame).lab_question -side top -expand 1 -fill x
 pack $this(top_frame).txt_sentence -side top -expand 0 -fill both
 pack $this(top_frame).validate     -side top -expand 1 -fill x
 
 return [this inherited $c $L_prims $index]
}

#___________________________________________________________________________________________________________________________________________
method CometQuestion_PM_P_TK_basic get_or_create_prims {root} {
 set this(top_frame) "$root.tk_${objName}_topframe"
 if {![winfo exists $this(top_frame)]} {
   frame $this(top_frame)
     label  $this(top_frame).lab_question -text    [this get_question]
	 text   $this(top_frame).txt_sentence 
	 button $this(top_frame).validate     -text    "Validate" \
	                                      -command "$objName prim_set_sentence \[$this(top_frame).txt_sentence get 0.0 end\]; $objName prim_Ask_sentence"
  }
 
 this Add_MetaData PRIM_STYLE_CLASS [list $this(top_frame)              "RESULT CONTAINER"             \
                                          $this(top_frame).lab_question "DECORATION GUIDANCE question" \
										  $this(top_frame).validate     "PARAM IN CONFIRM VALIDATE"    \
                                    ]
 
 this set_root_for_daughters $this(top_frame)
 
 this set_sentence [this get_sentence]
 
 return [this set_prim_handle $this(top_frame)]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometQuestion_PM_P_TK_basic set_question {l} {
 if {![winfo exists $this(top_frame)]} {return}
   $this(top_frame).lab_question configure -text $l
}

#___________________________________________________________________________________________________________________________________________
method CometQuestion_PM_P_TK_basic set_sentence {v} {
 if {![winfo exists $this(top_frame)]} {return}
   $this(top_frame).txt_sentence delete 0.0 end
   $this(top_frame).txt_sentence insert 0.0 $v
}

#___________________________________________________________________________________________________________________________________________
method CometQuestion_PM_P_TK_basic Ask_sentence {} {}
