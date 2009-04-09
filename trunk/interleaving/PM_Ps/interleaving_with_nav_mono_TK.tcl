#___________________________________________________________________________________________________________________________________________
# Monospace PM Interleaving
#___________________________________________________________________________________________________________________________________________
inherit Interleaving_PM_P_nav_mono_TK PM_TK

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_nav_mono_TK constructor {name descr args} {

 set this(current_LC_daughter) ""

# Pour faire une var statique
 set class(mastatic) toto
 this inherited $name $descr
   
 this set_nb_max_daughters 1

 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_nav_mono_TK get_current_LC_daughter {} {
 return $this(current_LC_daughter)
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_nav_mono_TK set_current_LC_daughter {d} {
# This PM has to be connected to an active PM of the subspace realated to d
 set LM [this get_LM]
 foreach LM_d [$LM get_handle_comet_daughters] {
   if {[expr [$LM_d Has_for_daughter "${d}_LM_LP"] != -1]} {
#     puts "$objName : $d trouvé sous $LM_d"
     this set_daughters ""
     set this(current_LC_daughter) $d
#     $LM Add_daughter_PM $objName  $LM_d
       set PMD [$LM Try_to_connect_PM_with $objName [$LM_d get_L_PM] -1]
#       puts "$objName : \n  LM_d : $LM_d\n  PM_ds : [$LM_d get_L_PM]\n  PMD : $PMD"
       if {[string length $PMD]} {
         $LM Connect_PM_descendants $objName $LM_d
        } else {
         set L_factories [$LM_d get_L_compatible_factories_with_ptf [${objName}_cou get_ptf]]
         foreach f $L_factories {
           set PMD [$f Generate [$LM_d get_LC] $LM_d]
           if {[string length $PMD]} {this Add_daughter $PMD
                                      break
                                     }
          }
        }
     break
    }
  }
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_nav_mono_TK maj_interleaved_daughters {} {
 set LC [this get_LC]
 set pos [lsearch [$LC get_daughters] $this(current_LC_daughter)]
# puts "On cherche $this(current_LC_daughter) dans \"[$LC get_daughters]\"\n  | $pos"
 if {$pos == -1} {
#   puts "__ The current daughter is no more a valid daughter, we have to choose another one"
   this set_current_LC_daughter [lindex [$LC get_daughters] 0]
  } else {this set_current_LC_daughter [this get_current_LC_daughter]}
# puts fin
}


#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________
#___________________________________________________________________________________________________________________________________________

inherit Interleaving_PM_P_nav_mono_TK_menu Interleaving_PM_P_nav_mono_TK

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_nav_mono_TK_menu constructor {name descr args} {
 set this(var_name) "${objName}_var"
   this set_GDD_id ScrollableMonospaceInterleaving_TK
   this inherited $name $descr
 eval "$objName configure $args"
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_nav_mono_TK_menu get_or_create_prims {root} {
# Define the handle
  set menu_name "${root}.tk_menu"

 if {[winfo exists $menu_name]} {
  } else {set LC [this get_LC]
          eval tk_optionMenu $menu_name "${objName}_var" "Interlaced comets" ""
         }


 this set_prim_handle $menu_name
 this set_root_for_daughters $root

 this maj_interleaved_daughters

 return [this set_prim_handle $menu_name]
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_nav_mono_TK_menu set_current_LC_daughter {d} {
 this inherited $d
 set ${objName}_var [$d get_name]
}

#___________________________________________________________________________________________________________________________________________
method Interleaving_PM_P_nav_mono_TK_menu maj_interleaved_daughters {} {
 global debug

 set L_prims [this get_prim_handle]
 set racine  [lindex $L_prims 0]
 if {[winfo exists $racine]} {
  } else {if { $debug } { puts "  $objName : Racine $racine do not exists" }
	  return
         }

 set LC           [$this(LM) get_LC]
 set LC_daughters [$LC get_daughters]
 $racine.menu delete 0 last

 foreach c $LC_daughters {
   $racine.menu add radiobutton -label [$c get_name] -command "set ${objName}_var \"[$c get_name]\";\
                                                               $objName set_current_LC_daughter $c"
  }

 this inherited
}



