#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
#_________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_U PM_U_Container
#_________________________________________________________________________________________________________________________________
method Interleaving_PM_P_U constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id GDD_Interleaving_PM_P_U

   this set_default_op_gdd_file    [Comet_files_root]Comets/CSS_STYLESHEETS/GDD/Common_GDD_requests.css++
   this set_default_css_style_file [Comet_files_root]Comets/CSS_STYLESHEETS/Interleaving/Common_GDD_requests.css++

   set this(current_view) ""
   
 eval "$objName configure $args"
 return $objName
}

#_________________________________________________________________________________________________________________________________
Generate_accessors Interleaving_PM_P_U [list current_view]

#_________________________________________________________________________________________________________________________________
method Interleaving_PM_P_U set_current_view {LC} {
 if {$this(current_view) != ""} {
   [CSS++ $objName "#$objName > $this(current_view)"] Show_elements 0 *
  }
 puts "\[CSS++ $objName \"#$objName > $LC\"\] Show_elements 1 *"
 [CSS++ $objName "#$objName > $LC"] Show_elements 1 *
 set this(current_view) $LC
}

#_________________________________________________________________________________________________________________________________
method Interleaving_PM_P_U set_LM {LM} {
 set rep [this inherited $LM]
 
   set this(top_container)       [CPool get_a_comet CometContainer]
     set this(menu_container)    [CPool get_a_comet CometContainer]
     set this(content_container) [CPool get_a_comet CometContainer]
	 $this(top_container) Add_daughters_R [list $this(menu_container) $this(content_container)]
	 

   this set_L_nested_handle_LM    $this(top_container)_LM_LP
   this set_L_nested_daughters_LM $this(content_container)_LM_LP

 return $rep
}

#_________________________________________________________________________________________________________________________________
method Interleaving_PM_P_U Add_daughter {PM {index -1}} {
 # Is it necessary to add a container for PM?
 if {[$PM get_real_LC] != $this(top_container)   &&   [lsearch [this get_out_daughters] $PM] == -1} {
  # We also create an activator
   set name [[$PM get_real_LC] get_name]
   set act  [CPool get_a_comet CometActivator -set_text $name -Add_MetaData "related_to" $PM -Add_style_class "DISPLAY $PM"]
   $act Subscribe_to_activate $objName "puts {Display $name}; $objName set_current_view [$PM get_real_LC]" UNIQUE
   $this(menu_container) Add_daughter_R $act
  }
  
 set rep [this inherited $PM $index]

   if {$rep > 0 && [$PM get_real_LC] != $this(top_container) && [this get_current_view] == ""} {
     if {[catch "$objName set_current_view [$PM get_real_LC]" err]} {puts "Error in $objName Add_daughter $PM $index:\n  - cmd $objName set_current_view [$PM get_real_LC]\n  -err : $err"}
	} elseif {[$PM get_real_LC] != $this(top_container)} {$PM Show_elements 0 *
	       }

 return $rep		   
}
