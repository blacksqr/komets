inherit PM_P_menu_TK PM_TK

#___________________________________________________________________________________________________________________________________________
method PM_P_menu_TK constructor {name descr args} {
 this inherited $name $descr
   this set_GDD_id Choice_DropDown_TK
 this set_root_for_daughters NULL
 set this(all_currents) ""
 set this(var_txt_menu) "${objName}_var_txt"
 
 eval "$objName configure $args"
 return $objName
}

#___________________________________________________________________________________________________________________________________________
method PM_P_menu_TK dispose {} {puts "$objName PM_P_menu_TK::dispose"; this inherited}

#______________________________________________________ Adding the choices functions _______________________________________________________
Methodes_set_LC PM_P_menu_TK $L_methodes_set_choices {$this(FC)} {}
Methodes_get_LC PM_P_menu_TK $L_methodes_get_choices {$this(FC)}

#___________________________________________________________________________________________________________________________________________
method PM_P_menu_TK get_or_create_prims {root} {
 set common_FC [$this(LM) get_Common_FC]
 set this(root) $root

# set choiceLabel   [$common_FC get_label_name]
 set choiceOptions [$common_FC get_L_choices]

# set label_name "$root.tk_${objName}_label"
 set M_options [lrange $choiceOptions 0 [llength $choiceOptions]]
 set options_name "$root.tk_${objName}_options"

 if {[winfo exists $options_name]} {} else {
#   puts "In $objName; We try to create label :\n  $label_name"
#   label $label_name -text $choiceLabel
   if {[string equal $M_options {}]} {
     tk_optionMenu $options_name "${objName}_choice" $M_options
    } else {eval tk_optionMenu $options_name "${objName}_choice" $M_options}
   $options_name configure -textvariable $this(var_txt_menu)
  }

# defining primitives
 this Add_MetaData PRIM_STYLE_CLASS [list $options_name "PARAM RESULT OUT IN"]


# Bindings
# set L [list $label_name $options_name]
 set L [list $options_name]
 this set_prim_handle $L
 this set_root_for_daughters ""
 
# this set_currents [$common_FC get_currents]
 this maj_choices
 

 return [this set_prim_handle $L]
}
#___________________________________________________________________________________________________________________________________________
method PM_P_menu_TK maj_choices        {}   {
global debug

	 set L_prims [this get_prim_handle]
#	 set racine [lindex $L_prims 1]
	 set racine [lindex $L_prims 0]
	 if {[winfo exists $racine]} {} else {if { $debug } { puts "Racine $racine do not exists" }
					      return}
	 set common_FC    [$this(LM) get_Common_FC]
	 set LC           [$this(LM) get_LC]
	 #set LC_daughters [$LC get_daughters]
	 set LC_daughters [this get_L_choices]
	 $racine.menu delete 0 last
	 set    cmd {}
	   append cmd "$common_FC set_state Done;"

         set type radiobutton
         if {[expr [this get_nb_max_choices] > 1]} {set type checkbutton}
         set this(type) $type

         switch $type {
           radiobutton {foreach c $LC_daughters {$racine.menu add $type -label [$c get_name] -command "set ${objName}_choice \{[$c get_name]\}; $objName Add_choosed $c; $cmd"}
                       }
           checkbutton {foreach c $LC_daughters {
                          set this(vars_checks,$c) "${objName}_$c"
                          global $this(vars_checks,$c)
                          set $this(vars_checks,$c) 0
                          $racine.menu add $type -label [$c get_name] -variable $this(vars_checks,$c) -command "set ${objName}_choice \{[$c get_name]\}; $objName Add_choosed $c; $cmd"
                         }
                       }
          }

	 set LC [this get_LC]
         this set_currents [$LC get_currents]
}

#___________________________________________________________________________________________________________________________________________                
# Ne pas oublier de traduire tout ça en terme des options de selection du menu
# Prendre garde aussi au fait que si on a des checkbox c'est le bordel au niveau des variables
method PM_P_menu_TK Add_choosed {c} {
 set common_FC    [$this(LM) get_Common_FC]
 set L            [$common_FC get_currents]
 if {[Add_element L $c]} {
#  # C'est un ajout
   if {[llength $L] > [this get_nb_max_choices]} {set L [lreplace $L 0 0]}
  } else {
#     # C'est un retrait
      if {[llength $L] < [this get_nb_min_choices]} {} else {Sub_element L $c}
     }
 [$objName get_LC] set_currents $L
}

#___________________________________________________________________________________________________________________________________________
method PM_P_menu_TK set_currents       {lc} {
global debug
     if {$debug} {puts "$objName set_currents $lc"}
#     if {[string equal $lc {}]} {return}
#     set racine       [lindex    $this(primitives_handle) 1]
     set racine       [lindex    $this(primitives_handle) 0]
     if {[winfo exists $racine]} {} else {
        global debug
        if { $debug } { puts "Racine $racine do not exists" }
        return
    }

    global ${objName}_choice
    set LC           [$this(LM) get_LC]
    set LC_daughters [$LC       get_daughters]
    set this(all_currents) $lc

# Tout désélectionner
    switch $this(type) {
      radiobutton {set ${objName}_choice {}}
      checkbutton {foreach d $LC_daughters {
                     global $this(vars_checks,$d)
                     set $this(vars_checks,$d) 0
                    }
                  }
     }

# Sélectionner ce dont on est sur
    switch $this(type) {
      radiobutton {if {[string equal $lc {}]} {} else {set ${objName}_choice [$lc get_name]}
                  }
      checkbutton {foreach c $lc {
                     global $this(vars_checks,$c)
                     set $this(vars_checks,$c) 1
                    }
                  }
     }
    global $this(var_txt_menu)
    set c_last [lindex $lc end]
    if {[string equal $c_last {}]} {
      set $this(var_txt_menu) {}
     } else {set $this(var_txt_menu) [$c_last get_name]
            }
}

#___________________________________________________________________________________________________________________________________________
method PM_P_menu_TK Add_choices {L} {
 this maj_choices
}

#___________________________________________________________________________________________________________________________________________
method PM_P_menu_TK set_L_choices { L_choices } {
 this maj_choices
 set c [lindex $L_choices 0]
 this set_currents $c
}

#___________________________________________________________________________________________________________________________________________
method PM_P_menu_TK set_nb_max_choices {nb} {[this get_Common_FC] set_nb_max_choices $nb
                                             this maj_choices
                                            }

