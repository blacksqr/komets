#_______________________________________________ Définition of the presentations __________________________________________________
#___________________________________________________________________________________________________________________________________________
inherit CometTravel_PM_P_TK_base PM_TK

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_TK_base constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id CometTravel_PM_P_TK_base
   set this(top_frame) ""
 eval "$objName configure $args"
 return $objName
}
#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_TK_base dispose {} {this inherited}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC CometTravel_PM_P_TK_base [P_L_methodes_set_CometTravel] {} {}
Methodes_get_LC CometTravel_PM_P_TK_base [P_L_methodes_get_CometTravel] {$this(FC)}

#___________________________________________________________________________________________________________________________________________
Generate_PM_setters CometTravel_PM_P_TK_base [P_L_methodes_set_CometTravel_COMET_RE]

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_TK_base Add_prim_mother {c L_prims {index -1}} {
 pack $this(top_frame).f_src     -side top  -expand 1 -fill x
 pack $this(top_frame).f_src.lab -side left -expand 0 -fill none
 pack $this(top_frame).f_src.ent -side left -expand 1 -fill x
 pack $this(top_frame).f_dst     -side top  -expand 1 -fill x
 pack $this(top_frame).f_dst.lab -side left -expand 0 -fill none
 pack $this(top_frame).f_dst.ent -side left -expand 1 -fill x
 pack $this(top_frame).bt_compute -side top -fill x
 pack $this(top_frame).lab_img -side top -fill none
 pack $this(top_frame).txt_travel -side top -fill both
 
 return [this inherited $c $L_prims $index]
}

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_TK_base get_or_create_prims {root} {
 set this(top_frame) "$root.tk_${objName}_topframe"
 if {![winfo exists $this(top_frame)]} {
   frame $this(top_frame)
     frame $this(top_frame).f_src;                       
	   label $this(top_frame).f_src.lab -text "From : "; 
	   global ${objName}_tk_txt_from; set ${objName}_tk_txt_from ""
	     entry $this(top_frame).f_src.ent -text ${objName}_tk_txt_from; 
     frame $this(top_frame).f_dst;                       
	   label $this(top_frame).f_dst.lab -text "To : "; 
	     global ${objName}_tk_txt_to; set ${objName}_tk_txt_to ""
	     entry $this(top_frame).f_dst.ent -text ${objName}_tk_txt_to; 
	 button $this(top_frame).bt_compute -text "GO !" -command "$objName Do_Compute"; 
	   
	 set this(img_tk_name) "[this get_LM]_Activator_PM_P_button_TK_TK_img_ressource"
	   image create photo $this(img_tk_name)
	 label $this(top_frame).lab_img -image $this(img_tk_name)
	   
	 text $this(top_frame).txt_travel -height 4 -width 40 -state disabled
	   
  }
 
 this Add_MetaData PRIM_STYLE_CLASS [list $this(top_frame).f_src      "PARAM IN from"                           \
                                          $this(top_frame).f_dst      "PARAM IN to"                             \
										  $this(top_frame).bt_compute "PARAM IN CONFIRM COMPUTE compute_travel" \
										  $this(top_frame).lab_img    "RESULT travel image"                     \
										  $this(top_frame).txt_travel "RESULT travel text"                      \
                                    ]
 
 this set_root_for_daughters $this(top_frame)
 
 this set_loc_src [this get_loc_src]
 this set_loc_dst [this get_loc_dst]
 this set_travel  [this get_travel]
 
 return [this set_prim_handle $this(top_frame)]
}

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_TK_base Do_Compute {} {
 if {![winfo exists $this(top_frame)]} {return}
   global ${objName}_tk_txt_from
   global ${objName}_tk_txt_to
   this prim_set_loc_src [subst $${objName}_tk_txt_from]
   this prim_set_loc_dst [subst $${objName}_tk_txt_to]
   this prim_Compute_travel
}

#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_TK_base set_loc_src {l} {
 if {![winfo exists $this(top_frame)]} {return}
   global ${objName}_tk_txt_from
   set ${objName}_tk_txt_from $l
}

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_TK_base set_loc_dst {l} {
 if {![winfo exists $this(top_frame)]} {return}
   global ${objName}_tk_txt_to
   set ${objName}_tk_txt_to $l
}

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_TK_base set_travel {t} {
 if {![winfo exists $this(top_frame)]} {return}
   image create photo $this(img_tk_name) -file [lindex $t 0]
   $this(top_frame).txt_travel configure -state normal
     $this(top_frame).txt_travel delete 0.0 end
     $this(top_frame).txt_travel insert 0.0 [lindex $t 1]
   $this(top_frame).txt_travel configure -state disabled
}

#___________________________________________________________________________________________________________________________________________
method CometTravel_PM_P_TK_base Compute_travel {} {}
