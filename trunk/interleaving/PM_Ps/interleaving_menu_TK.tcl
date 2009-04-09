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
 #puts "  $objName : Menu = \"$menu_name\""
 if {![winfo exists $menu_name]} {
   menu $menu_name
   set this(pipo_frame) "$top.pipo_frame"
   frame $this(pipo_frame)
  }
 if {![winfo exists $menu_name.$objName]} {
   menu $menu_name.$objName -tearoff 0
  }
 $menu_name add cascade -menu $menu_name.$objName -label [[this get_LC] get_name]
 $top configure -menu $menu_name

 this set_prim_handle "$menu_name.$objName"
 this set_root_for_daughters $this(pipo_frame)

 this maj_interleaved_daughters

 return [this set_prim_handle $menu_name.$objName]
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
 set L_PM [CSS++ $objName $LC]
 if {[string equal $L_PM {}]} {
   puts "  $objName Interleaving_PM_P_menu_TK::Connect_to_compatible_PM $LC\n    Impossible to find a PM of $LC descendant of $objName"
   return
  }
 this maj_interleaved_daughters
 # Can we trigger an activate method?
 foreach PM $L_PM {
   set L_methods [gmlObject info methods $PM]
   if {[lsearch $L_methods activate] >= 0} {$PM activate; return;}
  }
 # If not then just display it in a new window
 set cont_name [this get_a_window_for $LC]
   $cont_name set_name [$LC get_name]
   [this get_LM] Connect_PM_descendants $objName ${cont_name}_LM_LP
   $cont_name set_daughters_R $LC
}

