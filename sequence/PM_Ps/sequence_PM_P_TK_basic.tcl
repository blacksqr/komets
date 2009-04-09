inherit PM_P_sequence_TK_basic PM_TK

#___________________________________________________________________________________________________________________________________________
method PM_P_sequence_TK_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CT_Sequence_AUI_basic_CUI_simple_TK
   set this(top_frame) {}
   this set_nb_max_daughters 1
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC PM_P_sequence_TK_basic [L_methodes_set_sequence] {} {}
Methodes_get_LC PM_P_sequence_TK_basic [L_methodes_get_sequence] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters PM_P_sequence_TK_basic [L_methodes_set_sequence]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method PM_P_sequence_TK_basic Add_prim_mother {c L_prims {index -1}} {
 pack $this(frame_cont) -side top   -expand 1 -fill both
 pack $this(frame_nav)  -side top   -expand 1 -fill x
 pack $this(bt_next)    -side right
 pack $this(bt_prev)    -side right
 
 return [this inherited $c $L_prims $index]
}

#___________________________________________________________________________________________________________________________________________
method PM_P_sequence_TK_basic get_or_create_prims {root} {
 set this(top_frame) "$root.tk_${objName}_top_frame"
   set this(frame_cont) "$this(top_frame).cont"
   set this(frame_nav)  "$this(top_frame).nav"
     set this(bt_next) "$this(frame_nav).next"
	 set this(bt_prev) "$this(frame_nav).prev"
 if {[winfo exists $this(top_frame)]} {} else {
   frame $this(top_frame)
     frame $this(frame_cont); 
	 frame $this(frame_nav) ; 
	   button $this(bt_next) -text Validate -command "$objName prim_Next"    ; 
	   button $this(bt_prev) -text Cancel   -command "$objName prim_Previous";
   this Add_MetaData PRIM_STYLE_CLASS [list $this(frame_cont) "PARAM RESULT OUT CONTENT" \
											$this(frame_nav)  "PARAM IN NAVIGATION" \
											$this(bt_next)    "PARAM IN NEXT" \
											$this(bt_prev)    "PARAM IN PREV PREVIOUS" \
											$this(top_frame)  "PARAM RESULT OUT GLOBAL_CONTAINER" \
									  ]
  }

 this Display_current_step
 this set_root_for_daughters $this(frame_cont)
 set L [list $this(top_frame)] 
 return [this set_prim_handle $L]
}

#___________________________________________________________________________________________________________________________________________
method PM_P_sequence_TK_basic Previous {} {this Display_current_step}
method PM_P_sequence_TK_basic Next     {} {this Display_current_step}
method PM_P_sequence_TK_basic set_step {} {}

#___________________________________________________________________________________________________________________________________________
method PM_P_sequence_TK_basic Display_current_step {} {
 set step [this get_step]
 set L_LC_d [[this get_LC] get_out_daughters]
   if {$step > 0} {$this(bt_prev) configure -command "$objName prim_Previous" -fg black}
   if {$step < ([llength $L_LC_d]-1)} {$this(bt_next) configure -command "$objName prim_Next" -fg black}
 set LC [this get_LC]
   set daughter [this get_daughters]
   if {![string equal $daughter {}]} {
     [$daughter get_LC] UnSubscribe_to_Propagate_task_completed_info $objName
    }
   this set_daughters {}
   set LC_daughter [lindex [$LC get_out_daughters] $step]
   if {![string equal $LC_daughter {}]} {
     [this get_LM] Connect_PM_descendants $objName ${LC_daughter}_LM_LP
	 $LC_daughter Subscribe_to_Propagate_task_completed_info $objName "$objName Task_completion_changed_for $LC_daughter" UNIQUE
	 this Task_completion_changed_for $LC_daughter
    }
# Disactive button depending on step
# XXX PROTO
 return
 
 if {$step <= 0} {$this(bt_prev) configure -command "" -fg grey} 
 if {$step >= ([llength $L_LC_d]-1)} {$this(bt_next) configure -command "" -fg grey} 

}

#___________________________________________________________________________________________________________________________________________
method PM_P_sequence_TK_basic Task_completion_changed_for {LC_daughter} {
 # XXX DEBUG PROTO
 return
 if {[$LC_daughter Is_Task_completed]} {
   $this(bt_next) configure -command "$objName prim_Next" -fg black
  } else {$this(bt_next) configure -command "" -fg grey}
}
