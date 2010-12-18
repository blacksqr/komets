inherit Interleaving_PM_P_menu_TK PM_TK

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_menu_TK constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id ScrollableMonospaceInterleaving_menu_TK
   #this set_nb_max_daughters 0
   set this(pipo_frame) ""
   set this(id_window) 0
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_menu_TK get_current_LC_daughter {} {
 return $this(current_LC_daughter)
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_menu_TK get_or_create_prims {root} {
# Getting the toplevel
 set top $root
 while {![string equal Toplevel [winfo class $top]] && ![string equal Tkcon [winfo class $top]]} {set top [winfo parent $top]}
 #puts "  $objName : Toplevel trouvé dans $top"
# Define the handle
 set menu_name "$top.menu_system"
 if {![winfo exists $menu_name]} {menu $menu_name}
 set this(pipo_frame) "$top.pipo_frame_$objName"
 if {![winfo exists $this(pipo_frame)]} {frame $this(pipo_frame)}
 
 if {![winfo exists $menu_name._$objName]} {
   menu $menu_name._$objName -tearoff 0
  }
 $menu_name add cascade -menu $menu_name._$objName -label [[this get_LC] get_name]
 $top configure -menu $menu_name

 this set_prim_handle "$menu_name._$objName"
 this set_root_for_daughters $this(pipo_frame)

 this maj_interleaved_daughters

 return [this set_prim_handle $menu_name._$objName]
}

#___________________________________________________________________________________________________________________________________________
Methodes_set_LC Interleaving_PM_P_menu_TK [P_L_methodes_set_CometInterleaving] {}  {}
Methodes_get_LC Interleaving_PM_P_menu_TK [P_L_methodes_get_CometInterleaving] {}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_menu_TK Update_menu_label {C tk_menu new_name} {
	if {[winfo exists $tk_menu]} {
		 set i [$tk_menu  index [$C get_name]]
		 $tk_menu entryconfigure $i -label $new_name
		} else {$C UnSubscribe_to_set_name $objName}
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_menu_TK maj_interleaved_daughters {} {
 set LC [this get_LC]
 set L_comets [$LC get_out_daughters]
# Check if a menu still exist
 set m [this get_prim_handle]
 if {![winfo exists $m]} {return}

 foreach c [$LC get_out_daughters] {
   if {[catch "$m index \{[$c get_name]\}" res]} {
     $m add command -label [$c get_name]
	 $c Subscribe_to_set_name $objName "$objName Update_menu_label $c $m \$n" UNIQUE
    }
   $m entryconfigure [$m index [$c get_name]] -command "$objName Connect_to_compatible_PM $c"
  }
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_menu_TK get_a_window_for {LC} {
# Search for a free container
 set L_free_cont [CSS++ $objName "\#$objName > CometContainer.Inner_$objName\[Do_prims_still_exist == 0\]"]
 if {[llength $L_free_cont] > 0} {
   set rep [[lindex $L_free_cont 0] get_LC]
   #$rep set_daughters_R {}
   return $rep
  }
# If not, create a new one
 set cont_name "${objName}_window_$this(id_window)"
 incr this(id_window)
 CometContainer $cont_name [$LC get_name] {} -Add_style_class Inner_$objName
   ${cont_name}_LM_LP set_L_actives_PM [PhysicalContainer_TK_window ${cont_name}_PM_P_TK_win_[${cont_name}_LM_LP get_a_unique_id] "Window for element $LC in menu $objName" {}]
 return $cont_name
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_menu_TK Connect_to_compatible_PM {LC} {
 # Problem when LC is an activator ?
 set L_PM [CSS++ $objName "#${LC}->PMs \\<--< $objName/"]
 if {$L_PM == ""} {
   puts "  $objName Interleaving_PM_P_menu_TK::Connect_to_compatible_PM $LC\n    Impossible to find a PM of $LC descendant of $objName"
   return
  }
 this maj_interleaved_daughters
 # Can we trigger an activate method?
 foreach PM $L_PM {
   set LC [$PM get_LC]
   if {[$LC Has_MetaData TRIGGERABLE_ITEM]} {set PM [CSS++ $objName "#$PM [$LC Val_MetaData TRIGGERABLE_ITEM]"]}
   set L_methods [gmlObject info methods $PM]
   if {[lsearch $L_methods prim_activate] >= 0} {$PM prim_activate; return;}
  }
  
 # create a windows, connect to PM
 set win [this get_prim_handle]._win_for_$LC
 if {![winfo exists $win]} {
	 toplevel $win
	 set PM [lindex $L_PM 0]; puts "plug $PM ?"
	 catch {destroy [$PM get_prim_handle]}
	 $PM get_or_create_prims $win
	 [$PM get_LM] Connect_PM_descendants $PM
	 pack [$PM get_prim_handle] -expand 1 -fill both
	}
}

