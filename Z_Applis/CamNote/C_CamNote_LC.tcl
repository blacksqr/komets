inherit CometCamNote Logical_consistency


#___________________________________________________________________________________________________________________________________________
method CometCamNote constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_CamNote
   set this(L_files)    {}

 set CFC "${objName}_CFC"; CommonFC_CometCamNote $CFC
   this set_Common_FC $CFC

 set this(L_files) {}
 set this(is_setting) 0

# Nested comets
 CometImage           ${objName}_img     "Current Slide"     "Current slide of the presentation" -Add_style_class SlideViewer
 CometCamNote_Speaker ${objName}_speaker "Speaker interface" "The interface for the presentation speaker" -set_slide_viewer ${objName}_img
 CometChoice ${objName}_cc_mode "mode" {Choose a mode (PRESENTATION, QUESTIONS} -set_daughters_R [list PRESENTATION QUESTIONS]
 this Add_nested_daughters [list ${objName}_img ${objName}_speaker ] [list ${objName}_img ${objName}_speaker] {} {}
   ${objName}_speaker set_slide_viewer ${objName}_img
   [${objName}_speaker get_telec] Subscribe_to_set_val $objName "$objName maj_slide \[[${objName}_speaker get_telec] get_val\]" UNIQUE
   CometRoot ${objName}_cr_speaker "CamNote speaker" {Interface for camnote speaker} ""
     PhysicalHTML_root ${objName}_cr_speaker_PM_P_HTML "HTML root for CamNote Speaker" ""
     ${objName}_cr_speaker_LM_LP set_PM_active ${objName}_cr_speaker_PM_P_HTML
     ${objName}_cr_speaker Add_daughter_R ${objName}_speaker
   this set_speaker ${objName}_speaker admin speaker

 ${objName}_cc_mode Subscribe_to_set_currents $objName "if \{\[string equal \{\} \$lc\]\} \{\} else \{$objName set_mode \[\$lc get_text\]\}" UNIQUE
 ${objName}_speaker Add_daughter_R ${objName}_cc_mode

# Logical parts
 set this(LM_LP) "${objName}_LM_LP";
   CometCamNote_LM_P  $this(LM_LP) $this(LM_LP) "The logical presentation of $name"
   this Add_LM $this(LM_LP);
 set this(LM_FC) "${objName}_LM_FC";
   CometCamNote_LM_FC $this(LM_FC) $this(LM_FC) "This logical part manage different protocoles"
   this Add_LM $this(LM_FC);

# Evaluate arguments and return
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCamNote [L_methodes_set_CamNote] {$this(FC)} {$this(L_LM)}
Methodes_get_LC CometCamNote [L_methodes_get_CamNote] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method CometCamNote set_mode {m} {
 foreach c [this get_L_users] {
   $c set_mode $m
  }
 foreach LM [this get_L_LM] {$LM set_mode $m}
 return $m
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote get_root_for_user {u} {
 return ${objName}_cr_${u}
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometCamNote Add_Examinator {id p} {
   CometRoot ${objName}_cr_$id "${id}'s examinator interface" "Interface of examinator $id" {}
     ${objName}_cr_${id}_LM_LP set_PM_active [PhysicalHTML_root ${objName}_cr_${id}_PM_P_HTML "HTML root for examinator $id" {On the fly generated}]
   CometCamNote_Examinator ${objName}_$id   "${id}'s examinator interface" "Interface of examinator $id" -set_id $id -set_pass $p
     ${objName}_cr_${id} Add_daughter_R ${objName}_$id

   [this get_Common_FC] Add_Examinator ${objName}_${id} $p $id

   this Add_nested_daughters ${objName}_$id ${objName}_$id {} {}
     ${objName}_$id set_slide_viewer ${objName}_img
     this maj_user ${objName}_$id [[${objName}_speaker get_telec] get_val]
     [${objName}_$id get_telec] Subscribe_to_set_val $objName "if {\[string equal \[$objName get_mode\] QUESTIONS\]} {$objName maj_slide \[[${objName}_$id get_telec] get_val\]}" UNIQUE
   foreach LM [this get_L_LM] {$LM Add_Examinator ${objName}_${id} $p $id}
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote Sub_Examinator {n p} {
 if {[eval [this get_Common_FC] Sub_Examinator ${objName}_$n $p $n] == 1} {
   ${objName}_$n     dispose
   ${objName}_cr_$n  dispose
  }
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote set_Examinators {L_n_p} {
 foreach e [[this get_Common_FC] get_L_Examinators] {this Sub_Examinator}
 foreach n_p $L_n_p {
   set n  [lindex $n_p 0]
   set p  [lindex $n_p 1]
   this Add_Examinator $n $p
  }
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote set_presentation_name {n} {
 [this get_Common_FC] set_presentation_name $n
 set this(L_files) [glob "${n}*"]
 if {[llength $this(L_files)]>0} {${objName}_img load_img [lindex $this(L_files) 0]}
 [${objName}_speaker get_telec] configure -set_b_inf 1 -set_b_sup [llength $this(L_files)] -set_val 1 -set_L_slides $this(L_files)
 foreach examinator [this get_Examinators] {
   set ce [lindex $examinator 0]
   [$ce get_telec] configure -set_b_inf 1 -set_b_sup [llength $this(L_files)] -set_val 1 -set_L_slides $this(L_files)
  }
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote maj_user {L_cu num_slide} {
 foreach cu $L_cu {
   set cu_telec [$cu get_telec]
   $cu_telec configure -set_b_inf 1 -set_b_sup [llength $this(L_files)] -set_val $num_slide
  }
}

#___________________________________________________________________________________________________________________________________________
method CometCamNote maj_slide {num} {
 if {$this(is_setting)} {return}
 puts "$objName maj_slide $num"
 set this(is_setting) 1
   # Update SlideControlers
   set nb  [llength $this(L_files)]
   if {$nb>0 && $num <= $nb} {
     set img [lindex $this(L_files) [expr $num-1]]
     puts "  new image is $img"
     if {[string equal $img [${objName}_img get_img_file_name]]} {} else {${objName}_img load_img $img}
    }

   set telec [[this get_speaker] get_telec]; if {[$telec get_val] != $num} {$telec configure -set_val $num}
   foreach examinator [this get_Examinators] {
     set ce [lindex $examinator 0]
     set telec [$ce get_telec] ; if {[$telec get_val] != $num} {$telec configure -set_val $num}
    }
   # End of update
 set this(is_setting) 0
}
