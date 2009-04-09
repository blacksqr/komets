inherit DChoice_PM_P_interleaving_markers_TK PM_TK

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_interleaving_markers_TK constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id ChoiceInterleavingMarkersTK
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_interleaving_markers_TK dispose {} {this inherited}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC DChoice_PM_P_interleaving_markers_TK $L_methodes_set_choices {$this(FC)} {}
Methodes_get_LC DChoice_PM_P_interleaving_markers_TK $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_interleaving_markers_TK get_or_create_prims {root} {
 set common_FC  [$this(LM) get_Common_FC]

# Define the handle
 set frame_name    "$root.tk_${objName}_label"

 if {[winfo exists $frame_name]} {} else {
   frame $frame_name
  }

 this set_root_for_daughters $frame_name

 set L  [list $frame_name ]
 return [this set_prim_handle $L]
}
#___________________________________________________________________________________________________________________________________________
method DChoice_PM_P_interleaving_markers_TK maj_choices {} {}

