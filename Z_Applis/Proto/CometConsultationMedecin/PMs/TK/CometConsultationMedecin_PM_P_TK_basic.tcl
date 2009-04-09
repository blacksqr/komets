#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometConsultationMedecin_PM_P_TK_basic PM_TK

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_PM_P_TK_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CometConsultationMedecin_PM_P_TK_basic
   set this(top_frame)       ""
   set this(L_frame_radios)  ""
   set this(var_choice_name) "${objName}_var_rb"
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_PM_P_TK_basic dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometConsultationMedecin_PM_P_TK_basic [P_L_methodes_set_CometConsultationMedecin] {} {}
Methodes_get_LC CometConsultationMedecin_PM_P_TK_basic [P_L_methodes_get_CometConsultationMedecin] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometConsultationMedecin_PM_P_TK_basic [P_L_methodes_set_CometConsultationMedecin_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_PM_P_TK_basic Add_prim_mother {c L_prims {index -1}} {
 pack $this(top_frame).lab_state    -side top -expand 1 -fill x
 pack $this(top_frame).lab_question -side top -expand 1 -fill x
 pack $this(top_frame)._Q_frame     -side top -expand 0 -fill none
 pack $this(top_frame).validate     -side top -expand 1 -fill x
 
 return [this inherited $c $L_prims $index]
}

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_PM_P_TK_basic get_or_create_prims {root} {
 set this(top_frame) "$root.tk_${objName}_topframe"
 if {![winfo exists $this(top_frame)]} {
   frame $this(top_frame)
     label  $this(top_frame).lab_state    -text    [this get_textual_state]
     label  $this(top_frame).lab_question -text    [this get_question]
	 frame  $this(top_frame)._Q_frame
	 button $this(top_frame).validate     -text    "Validate"\
	                                      -command "$objName prim_set_choice \$$this(var_choice_name)"
  }
 
 this Add_MetaData PRIM_STYLE_CLASS [list $this(top_frame)              "RESULT CONTAINER"             \
                                          $this(top_frame).lab_state    "DECORATION GUIDANCE state"    \
										  $this(top_frame).lab_question "DECORATION GUIDANCE question" \
										  $this(top_frame)._Q_frame     "PARAM IN choices"             \
										  $this(top_frame).validate     "PARAM IN CONFIRM VALIDATE"    \
                                    ]
 
 this set_root_for_daughters $this(top_frame)
 
 this set_L_choices [this get_L_choices]
 
 return [this set_prim_handle $this(top_frame)]
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_PM_P_TK_basic set_textual_state {v} {
 if {![winfo exists $this(top_frame)]} {return}
   $this(top_frame).lab_state configure -text $v
}

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_PM_P_TK_basic set_question {l} {
 if {![winfo exists $this(top_frame)]} {return}
   $this(top_frame).lab_question configure -text $l
}

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_PM_P_TK_basic set_L_choices {L} {
 if {![winfo exists $this(top_frame)]} {return}
   foreach f $this(L_frame_radios) {destroy $f}
   set this(L_frame_radios) ""
   set i 0
   foreach c $L {
     frame $this(top_frame)._Q_frame.choice_$i                                             
	 radiobutton $this(top_frame)._Q_frame.choice_${i}.radio -variable $this(var_choice_name) -value $i -text $c
	 pack $this(top_frame)._Q_frame.choice_$i         -side top  -expand 1 -fill x
	 pack $this(top_frame)._Q_frame.choice_${i}.radio -side left -expand 0 -fill none
	 lappend this(L_frame_radios) $this(top_frame)._Q_frame.choice_${i}.radio
	 set $this(var_choice_name) $i
	 incr i
    }
}

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_PM_P_TK_basic validate {} {}

#___________________________________________________________________________________________________________________________________________
method CometConsultationMedecin_PM_P_TK_basic cancel   {} {}
