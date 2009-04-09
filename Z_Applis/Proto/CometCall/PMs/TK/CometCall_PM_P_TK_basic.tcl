#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometCall_PM_P_TK_basic PM_TK

#___________________________________________________________________________________________________________________________________________
if {[info commands CometCall_PM_P_TK_basic_photo_CALL] == ""} {
  image create photo CometCall_PM_P_TK_basic_photo_CALL -file CALL.bmp
 }
 
#___________________________________________________________________________________________________________________________________________
method CometCall_PM_P_TK_basic constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CometCall_PM_P_TK_basic
   set this(top_frame) ""
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method CometCall_PM_P_TK_basic dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometCall_PM_P_TK_basic [P_L_methodes_set_CometCall] {} {}
Methodes_get_LC CometCall_PM_P_TK_basic [P_L_methodes_get_CometCall] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometCall_PM_P_TK_basic [P_L_methodes_set_CometCall_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometCall_PM_P_TK_basic Add_prim_mother {c L_prims {index -1}} {
 pack $this(top_frame).frame_bt     -side bottom -expand 0 -fill none
   pack $this(top_frame).frame_bt.lab_contact -side top -expand 0 -fill none
   pack $this(top_frame).frame_bt.bt_img      -side top -expand 0 -fill none
 pack $this(top_frame).lab_name     -expand 1 -fill x
 pack $this(top_frame).txt_addresse -expand 1 -fill both
 
 return [this inherited $c $L_prims $index]
}

#___________________________________________________________________________________________________________________________________________
method CometCall_PM_P_TK_basic get_or_create_prims {root} {
 set this(top_frame) "$root.tk_${objName}_topframe"
 if {![winfo exists $this(top_frame)]} {
   frame $this(top_frame)
     label  $this(top_frame).lab_name     -text [this get_name]
	 text   $this(top_frame).txt_addresse -width 50 -height 5 -state disabled
	 frame  $this(top_frame).frame_bt
	    label $this(top_frame).frame_bt.lab_contact -text [this get_contact]
	    button $this(top_frame).frame_bt.bt_img -image CometCall_PM_P_TK_basic_photo_CALL
	 button $this(top_frame).validate     -text    "Validate" 
  }
 
 this Add_MetaData PRIM_STYLE_CLASS [list $this(top_frame).lab_name             "DECORATION GUIDANCE name"                 \
										  $this(top_frame).txt_addresse         "DECORATION GUIDANCE addresse address"     \
										  $this(top_frame).frame_bt.lab_contact "DECORATION GUIDANCE contact number phone" \
										  $this(top_frame).frame_bt.bt_img      "PARAM IN call"                            \
                                    ]
 
 this set_root_for_daughters $this(top_frame)
 
 this set_adresse [this get_adresse]
 
 return [this set_prim_handle $this(top_frame)]
}

#___________________________________________________________________________________________________________________________________________
Generate_accessors CometCall_PM_P_TK_basic [list top_frame]

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometCall_PM_P_TK_basic set_name {l} {
 if {![winfo exists $this(top_frame)]} {return}
   $this(top_frame).lab_name configure -text $l
}

#___________________________________________________________________________________________________________________________________________
method CometCall_PM_P_TK_basic set_contact {v} {
 if {![winfo exists $this(top_frame)]} {return}
   $this(top_frame).lab_contact configure -text $v
}

#___________________________________________________________________________________________________________________________________________
method CometCall_PM_P_TK_basic set_adresse {v} {
 if {![winfo exists $this(top_frame)]} {return}
   $this(top_frame).txt_addresse configure -state normal
   $this(top_frame).txt_addresse delete 0.0 end
   $this(top_frame).txt_addresse insert 0.0 $v
   $this(top_frame).txt_addresse configure -state disable
}

#___________________________________________________________________________________________________________________________________________
method CometCall_PM_P_TK_basic Ask_sentence {} {}
